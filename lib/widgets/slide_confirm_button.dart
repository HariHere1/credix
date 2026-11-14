import 'dart:async';
import 'dart:math' show pi, sin;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A "slide to confirm" control.
///
/// Drag the thumb across the track: the fill trails behind it and the
/// control snaps into [onConfirm] once the thumb crosses
/// [confirmThreshold]. Pointer (touch and mouse) and keyboard
/// (focus it, then use ←/→ to move the thumb, Enter to confirm) are
/// both supported.
///
/// [onConfirm] may be async:
///   * while the returned [Future] runs, the thumb turns into a check
///     icon and the track swaps in [loadingLabel];
///   * when the [Future] resolves, the control lands on its confirmed
///     state ([confirmedLabel]);
///   * when the [Future] errors, the thumb springs back to idle so the
///     action can be retried.
///
/// In screens that navigate away on success the confirmed state only
/// flashes briefly; [resetAfter] governs how long it is shown before
/// the control resets itself.
class SlideConfirmButton extends StatefulWidget {
  /// Deliberate-confirmation work. Throw to signal failure — the
  /// control springs back to idle so the action can be retried.
  final Future<void> Function() onConfirm;

  /// Resting label shown on the track.
  final String label;

  /// Label swapped in while [onConfirm] is running.
  final String loadingLabel;

  /// Label shown once [onConfirm] resolves.
  final String confirmedLabel;

  /// Label briefly shown after validation or upload failure.
  final String errorLabel;

  /// Track height.
  final double height;

  /// Diameter of the draggable thumb.
  final double thumbSize;

  /// Track corner radius.
  final double borderRadius;

  /// Thumb position (0–1) at which the action confirms.
  final double confirmThreshold;

  /// How long the confirmed state is shown before resetting to idle.
  final Duration resetAfter;

  final Color? trackColor;
  final Color? fillColor;
  final Color? thumbColor;

  const SlideConfirmButton({
    super.key,
    required this.onConfirm,
    this.label = 'Slide to confirm',
    this.loadingLabel = 'Working…',
    this.confirmedLabel = 'Confirmed',
    this.errorLabel = 'Try again',
    this.height = 56,
    this.thumbSize = 46,
    this.borderRadius = AppSpacing.buttonRadius,
    this.confirmThreshold = 0.85,
    this.resetAfter = const Duration(seconds: 3),
    this.trackColor,
    this.fillColor,
    this.thumbColor,
  });

  @override
  State<SlideConfirmButton> createState() => _SlideConfirmButtonState();
}

enum _SlidePhase { idle, confirming, confirmed, error }

class _SlideConfirmButtonState extends State<SlideConfirmButton>
    with TickerProviderStateMixin {
  static const double _trackPadding = 6;
  static const double _keyboardStep = 0.12;

  final GlobalKey _trackKey = GlobalKey();

  _SlidePhase _phase = _SlidePhase.idle;
  bool _dragging = false;
  bool _focused = false;
  Timer? _resetTimer;

  /// Thumb position along the track, 0 (start) to 1 (end).
  late final AnimationController _position;

  /// Decaying oscillation played when the action is rejected.
  late final AnimationController _shake;

  @override
  void initState() {
    super.initState();
    _position = AnimationController(vsync: this);
    _shake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _position.dispose();
    _shake.dispose();
    super.dispose();
  }

  /// Usable travel distance of the thumb inside the track.
  double get _maxDrag {
    final box = _trackKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return 0;
    return box.size.width - widget.thumbSize - 2 * _trackPadding;
  }

  // ------------------------------------------------------------------
  // Gesture handling (pointer: touch + mouse).
  // ------------------------------------------------------------------

  void _handleDragStart(DragStartDetails _) {
    if (_phase != _SlidePhase.idle) return;
    _dragging = true;
    _position.stop();
    _shake.stop();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_phase != _SlidePhase.idle || !_dragging) return;
    final max = _maxDrag;
    if (max <= 0) return;
    _position.value =
        (_position.value + details.delta.dx / max).clamp(0.0, 1.0);
    // Snaps to confirm as soon as the thumb crosses the threshold.
    if (_position.value >= widget.confirmThreshold) _confirm();
  }

  void _handleDragEnd(DragEndDetails _) {
    if (!_dragging) return;
    _dragging = false;
    if (_phase != _SlidePhase.idle) return;
    if (_position.value >= widget.confirmThreshold) {
      _confirm();
    } else {
      _springBack();
    }
  }

  // ------------------------------------------------------------------
  // Keyboard handling.
  // ------------------------------------------------------------------

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (_phase != _SlidePhase.idle) return KeyEventResult.handled;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowRight) {
      _nudge(_keyboardStep);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      _nudge(-_keyboardStep);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      if (_position.value >= widget.confirmThreshold) {
        _confirm();
      } else {
        // Not far enough — hint that more sliding is required.
        _springBack(shake: true);
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _nudge(double step) {
    _position.stop();
    _shake.stop();
    _position.value = (_position.value + step).clamp(0.0, 1.0);
    if (_position.value >= widget.confirmThreshold) _confirm();
  }

  // ------------------------------------------------------------------
  // State machine.
  // ------------------------------------------------------------------

  Future<void> _confirm() async {
    if (_phase != _SlidePhase.idle) return;
    _dragging = false;
    setState(() => _phase = _SlidePhase.confirming);
    _position.animateTo(1.0,
        duration: const Duration(milliseconds: 180), curve: Curves.easeOut);
    HapticFeedback.mediumImpact();
    try {
      await widget.onConfirm();
      if (!mounted) return;
      HapticFeedback.lightImpact();
      setState(() => _phase = _SlidePhase.confirmed);
      _resetTimer?.cancel();
      _resetTimer = Timer(widget.resetAfter, _reset);
    } catch (_) {
      // The promise rejected — spring back to idle so it can be retried.
      if (!mounted) return;
      setState(() => _phase = _SlidePhase.error);
      _position.stop();
      _position.animateTo(0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutCubic);
      _shake.forward(from: 0);
      _resetTimer?.cancel();
      _resetTimer = Timer(const Duration(milliseconds: 650), _reset);
    }
  }

  void _springBack({bool shake = false}) {
    _position.stop();
    _position.animateWith(
      SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 320, damping: 20),
        _position.value,
        0,
        _position.value * 8,
      ),
    );
    if (shake) _shake.forward(from: 0);
  }

  void _reset() {
    _resetTimer?.cancel();
    if (!mounted) return;
    setState(() => _phase = _SlidePhase.idle);
    _position.stop();
    _position.animateTo(0,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOutCubic);
  }

  // ------------------------------------------------------------------
  // Build.
  // ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Focus(
        canRequestFocus: true,
        onFocusChange: (focused) => setState(() => _focused = focused),
        onKeyEvent: _handleKeyEvent,
        child: Semantics(
          button: true,
          enabled: _phase == _SlidePhase.idle,
          label: switch (_phase) {
            _SlidePhase.confirming => widget.loadingLabel,
            _SlidePhase.confirmed => widget.confirmedLabel,
            _SlidePhase.error => widget.errorLabel,
            _SlidePhase.idle => widget.label,
          },
          // Screen-reader activation skips the drag gesture entirely.
          onTap: _phase == _SlidePhase.idle ? _confirm : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: _handleDragStart,
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: _handleDragEnd,
            child: AnimatedBuilder(
              animation: Listenable.merge([_position, _shake]),
              builder: (context, _) {
                final shakeOffset =
                    sin(_shake.value * pi * 4) * 8 * (1 - _shake.value);
                final showingResult = _phase != _SlidePhase.idle;
                final hasFill = _dragging || _position.value > 0 || showingResult;
                final thumbLeft = _trackPadding + _position.value * _maxDrag;
                final fillWidth = hasFill ? thumbLeft + widget.thumbSize : 0.0;
                final labelOpacity = (_phase == _SlidePhase.idle)
                    ? (1 - _position.value / widget.confirmThreshold)
                        .clamp(0.0, 1.0)
                    : 1.0;
                final pillRadius = BorderRadius.circular(widget.height / 2);
                final fillColor = switch (_phase) {
                  _SlidePhase.confirming || _SlidePhase.confirmed => AppColors.success,
                  _SlidePhase.error => AppColors.error,
                  _SlidePhase.idle => (widget.fillColor ?? AppColors.sliderAccent).withOpacity(0.36),
                };
                final thumbColor = switch (_phase) {
                  _SlidePhase.confirming || _SlidePhase.confirmed => AppColors.success,
                  _SlidePhase.error => AppColors.error,
                  _SlidePhase.idle => widget.thumbColor ?? AppColors.accent,
                };

                return Transform.translate(
                  offset: Offset(shakeOffset, 0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    key: _trackKey,
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: widget.trackColor ?? AppColors.surfaceVariant,
                      borderRadius: pillRadius,
                      border: Border.all(
                        color: _focused ? AppColors.accent : AppColors.border,
                        width: _focused ? 1.5 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: pillRadius,
                      child: Stack(
                        children: [
                        // Fill trailing behind the thumb.
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: fillWidth,
                          child: TweenAnimationBuilder<Color?>(
                            duration: const Duration(milliseconds: 250),
                            tween: ColorTween(end: fillColor),
                            builder: (context, color, _) => DecoratedBox(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: pillRadius,
                              ),
                            ),
                          ),
                        ),
                        // Track label (loadingLabel while working).
                        Center(
                          child: Opacity(
                            opacity: labelOpacity,
                            child: Text(
                              switch (_phase) {
                                _SlidePhase.confirming => widget.loadingLabel,
                                _SlidePhase.confirmed => widget.confirmedLabel,
                                _SlidePhase.error => widget.errorLabel,
                                _SlidePhase.idle => widget.label,
                              },
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _phase == _SlidePhase.confirming ||
                                        _phase == _SlidePhase.confirmed
                                    ? AppColors.onAccent
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        // The thumb remains visible while success/error snaps
                        // back, so the result is clear to the student.
                        Positioned(
                            left: thumbLeft,
                            top: (widget.height - widget.thumbSize) / 2,
                            child: Container(
                              width: widget.thumbSize,
                              height: widget.thumbSize,
                              decoration: BoxDecoration(
                                color: thumbColor,
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x59000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _phase == _SlidePhase.confirming ||
                                        _phase == _SlidePhase.confirmed
                                    ? Icons.check_rounded
                                    : _phase == _SlidePhase.error
                                        ? Icons.close_rounded
                                        : Icons.chevron_right_rounded,
                                color: AppColors.onAccent,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
