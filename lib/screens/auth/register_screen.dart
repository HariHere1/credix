import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../student/student_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _rollCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _confirmPwCtrl = TextEditingController();
  bool _obscurePw = true;
  bool _obscureConfirm = true;

  void _submit() {
    if ([_rollCtrl, _nameCtrl, _emailCtrl, _pwCtrl, _confirmPwCtrl].any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all fields.')));
      return;
    }
    if (_pwCtrl.text != _confirmPwCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const StudentShell()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _rollCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.sm, AppSpacing.pagePadding, AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ACTIVITY POINTS', style: TextStyle(color: AppColors.textDisabled, fontSize: 9, letterSpacing: 1.2)),
                      Text('Register', style: TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Center(child: Container(width: 110, height: 4, decoration: BoxDecoration(color: AppColors.textPrimary, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: AppSpacing.xl),
              const Text('Create your CREDIX account', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              const Text('Register to upload certificates and track your activity points.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: AppSpacing.xl),
              TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
              const SizedBox(height: AppSpacing.md),
              TextFormField(controller: _rollCtrl, decoration: const InputDecoration(labelText: 'Roll Number')),
              const SizedBox(height: AppSpacing.md),
              TextFormField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _pwCtrl,
                obscureText: _obscurePw,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePw ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.textSecondary, size: 20),
                    onPressed: () => setState(() => _obscurePw = !_obscurePw),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _confirmPwCtrl,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.textSecondary, size: 20),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(height: 50, child: ElevatedButton(onPressed: _submit, child: const Text('Register'))),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Already have an account? Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
