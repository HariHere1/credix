import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/admin_session.dart';
import '../models/admin_user.dart';
import '../widgets/admin_card.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _email = TextEditingController(text: 'admin@sjcetpalai.ac.in');
  final _password = TextEditingController(text: 'credix-demo');
  AdminRole _role = AdminRole.superAdmin;
  bool _locked = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      setState(() => _locked = true);
      return;
    }
    AdminSession.instance.signIn(AdminUser(
          name: _role == AdminRole.superAdmin ? 'Dr. Anand R.' : 'Admin User',
          email: _email.text.trim(),
          role: _role,
        ));
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: AdminCard(
              padding: const EdgeInsets.all(32),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                const _Brand(),
                const SizedBox(height: 28),
                Text('Admin sign in', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                const Text('SJCET Palai 2024 Scheme · Administration portal', style: TextStyle(color: Color(0xFF68736C))),
                const SizedBox(height: 24),
                TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
                const SizedBox(height: 14),
                TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
                const SizedBox(height: 14),
                DropdownButtonFormField<AdminRole>(initialValue: _role, decoration: const InputDecoration(labelText: 'Demo role', border: OutlineInputBorder()), items: AdminRole.values.map((r) => DropdownMenuItem(value: r, child: Text(r.label))).toList(), onChanged: (r) => setState(() => _role = r ?? _role)),
                if (_locked) const Padding(padding: EdgeInsets.only(top: 12), child: Text('Sign in locked: enter both email and password.', style: TextStyle(color: Color(0xFFCE2025)))),
                const SizedBox(height: 20),
                SizedBox(width: double.infinity, child: FilledButton(onPressed: _signIn, child: const Text('Sign in'))),
                const SizedBox(height: 12),
                const Text('Mock access · no account registration', style: TextStyle(fontSize: 12, color: Color(0xFF68736C))),
              ]),
            ),
          ),
        ),
      );
}

class _Brand extends StatelessWidget {
  const _Brand();
  @override
  Widget build(BuildContext context) => Row(children: [ClipRRect(borderRadius: BorderRadius.circular(11), child: Image.asset('assets/brand/credix_logo.png', width: 38, height: 38, fit: BoxFit.cover)), const SizedBox(width: 10), const Text('CREDIX', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.4))]);
}
