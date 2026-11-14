import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../student/student_shell.dart';
import '../advisor/advisor_shell.dart';
import 'register_screen.dart';
import '../../widgets/brand_mark.dart';

class LoginScreen extends StatefulWidget {
  final bool initialAdvisorRole;

  const LoginScreen({super.key, this.initialAdvisorRole = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _identifierCtrl;
  late final TextEditingController _passwordCtrl;
  bool _obscure = true;
  late bool _advisorRole;

  @override
  void initState() {
    super.initState();
    _advisorRole = widget.initialAdvisorRole;
    _identifierCtrl = TextEditingController(
      text: _advisorRole ? kMockAdvisor.email : kMockStudent.rollNo,
    );
    _passwordCtrl = TextEditingController(
      text: _advisorRole ? kMockAdvisor.password : kMockStudent.password,
    );
  }

  void _login() {
    if (_identifierCtrl.text.trim().isEmpty || _passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }
    final id = _identifierCtrl.text.trim();
    if (_advisorRole && id == kMockAdvisor.email && _passwordCtrl.text == kMockAdvisor.password) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdvisorShell()),
      );
      return;
    }
    if (!_advisorRole && (id == kMockStudent.rollNo || id == kMockStudent.email) && _passwordCtrl.text == kMockStudent.password) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const StudentShell()),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid credentials. Use the mock student or advisor credentials.')),
    );
  }

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: AppColors.accent, size: 11),
                      SizedBox(width: 5),
                      Icon(Icons.circle, color: AppColors.accent, size: 11),
                      SizedBox(width: 8),
                      Text('UNIVERSITY PORTAL  ·  LIVE', style: TextStyle(color: Color(0xFF315643), fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Center(child: BrandMark(size: 112)),
              const SizedBox(height: AppSpacing.xl),
              const Text('Activity Points', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textPrimary, fontSize: 32, height: 1.15, fontWeight: FontWeight.w800, letterSpacing: -0.8)),
              const SizedBox(height: AppSpacing.xs),
              const Text('College Activity Point Allocation', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: AppColors.surface.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(999), border: Border.all(color: AppColors.whiteBorder, width: 1.5)),
                child: Row(children: [_roleButton('Student', false), _roleButton('Advisor', true)]),
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                color: AppColors.surface.withValues(alpha: 0.78),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg + 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_advisorRole ? 'Email Address' : 'Roll Number', style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                          const Text('Verified Format', style: TextStyle(color: Color(0xFF007A45), fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _identifierCtrl,
                        decoration: InputDecoration(
                          hintText: _advisorRole ? 'name@college.edu' : 'Enter your roll number',
                          prefixIcon: Icon(_advisorRole ? Icons.badge_outlined : Icons.assignment_ind_outlined, color: AppColors.textDisabled),
                          fillColor: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Password', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                          TextButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password recovery is not connected in this prototype.'))), child: const Text('Forgot password?')),
                        ],
                      ),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textDisabled),
                          fillColor: Colors.white.withValues(alpha: 0.82),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.65), borderRadius: BorderRadius.circular(14)),
                        child: Row(children: [
                          Container(width: 34, height: 34, decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.bolt_rounded, color: AppColors.accentLight, size: 20)),
                          const SizedBox(width: AppSpacing.sm),
                          const Expanded(child: Text('Track every certificate and activity point in one place.', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.textSecondary, fontSize: 13))),
                        ]),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        height: 58,
                        child: ElevatedButton.icon(
                          onPressed: _login,
                          icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                          label: const Text('Login'),
                          iconAlignment: IconAlignment.end,
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: AppColors.onAccent, textStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 17, fontWeight: FontWeight.w700), shape: const StadiumBorder()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 14, backgroundColor: Color(0xFFE5E7EB), child: Text('KT', style: TextStyle(fontSize: 10, color: AppColors.textPrimary, fontWeight: FontWeight.w700))),
                  SizedBox(width: 4),
                  CircleAvatar(radius: 14, backgroundColor: Color(0xFFDCE7F7), child: Text('AP', style: TextStyle(fontSize: 10, color: AppColors.textPrimary, fontWeight: FontWeight.w700))),
                  SizedBox(width: 4),
                  CircleAvatar(radius: 14, backgroundColor: AppColors.accent, child: Text('+3k', style: TextStyle(fontSize: 10, color: AppColors.onAccent, fontWeight: FontWeight.w700))),
                  SizedBox(width: 10),
                  Text('Used by 42+ Campus Clubs', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: const Text('Register', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleButton(String label, bool advisor) {
    final selected = _advisorRole == advisor;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _advisorRole = advisor;
          _identifierCtrl.text = advisor ? kMockAdvisor.email : kMockStudent.rollNo;
          _passwordCtrl.text = advisor ? kMockAdvisor.password : kMockStudent.password;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: selected ? const [BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(advisor ? Icons.badge_outlined : Icons.school_outlined, size: 19, color: selected ? AppColors.onAccent : AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Text(label, textAlign: TextAlign.center, style: TextStyle(color: selected ? AppColors.onAccent : AppColors.textSecondary, fontSize: 15, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
