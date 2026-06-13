import 'package:cthulhu_solo_investigator_app/core/state/auth_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/auth/widgets/social_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authActionsProvider).signInWithEmail(_email.text, _password.text);
    } catch (e) {
      if (mounted) setState(() => _error = _humanize(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Escribe primero tu email para restablecer la contraseña.');
      return;
    }
    try {
      await ref.read(authActionsProvider).sendPasswordReset(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Te hemos enviado un email a $email.')),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _error = _humanize(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ENTRAR')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                style: const TextStyle(color: AppColors.parchment),
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: true,
                style: const TextStyle(color: AppColors.parchment),
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _busy ? null : _resetPassword,
                  child: const Text(
                    'He olvidado la contraseña',
                    style: TextStyle(color: AppColors.parchmentDim),
                  ),
                ),
              ),
              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: AppColors.blood)),
                const SizedBox(height: 8),
              ],
              ElevatedButton(
                onPressed: _busy ? null : _submit,
                child: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: AppColors.parchment, strokeWidth: 2),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('ENTRAR', style: TextStyle(letterSpacing: 1.5)),
                      ),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('o', style: TextStyle(color: AppColors.parchmentDim)),
                  ),
                  Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: 16),
              SocialButtons(onError: (e) => setState(() => _error = _humanize(e))),
            ],
          ),
        ),
      ),
    );
  }
}

String _humanize(Object e) {
  final msg = e.toString();
  if (msg.contains('invalid-credential') || msg.contains('wrong-password')) {
    return 'Email o contraseña incorrectos.';
  }
  if (msg.contains('user-not-found')) return 'No existe ninguna cuenta con ese email.';
  if (msg.contains('too-many-requests')) {
    return 'Demasiados intentos. Prueba más tarde.';
  }
  if (msg.contains('network-request-failed')) return 'Sin conexión.';
  return 'Algo ha ido mal. Inténtalo otra vez.';
}
