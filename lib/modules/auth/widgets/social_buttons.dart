import 'dart:io' show Platform;

import 'package:cthulhu_solo_investigator_app/core/state/auth_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocialButtons extends ConsumerWidget {
  final void Function(Object error)? onError;
  const SocialButtons({this.onError, super.key});

  bool get _showApple {
    if (kIsWeb) return false;
    return Platform.isIOS || Platform.isMacOS;
  }

  Future<void> _wrap(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      onError?.call(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(authActionsProvider);
    return Column(
      children: [
        _SocialButton(
          label: 'Continuar con Google',
          icon: Icons.g_mobiledata,
          onPressed: () => _wrap(actions.signInWithGoogle),
        ),
        if (_showApple) ...[
          const SizedBox(height: 10),
          _SocialButton(
            label: 'Continuar con Apple',
            icon: Icons.apple,
            onPressed: () => _wrap(actions.signInWithApple),
          ),
        ],
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _SocialButton({required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border, width: 1),
          foregroundColor: AppColors.parchment,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.mythos),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
