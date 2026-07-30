import 'package:cthulhu_solo_investigator_app/core/state/auth_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountMenu extends ConsumerWidget {
  const AccountMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final guest = ref.watch(guestModeProvider);

    final label = user?.email ?? (guest ? 'Modo invitado' : 'Sin cuenta');

    return PopupMenuButton<_Choice>(
      tooltip: 'Cuenta',
      icon: Icon(
        guest ? Icons.account_circle_outlined : Icons.account_circle,
        color: AppColors.text,
      ),
      color: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        side: BorderSide(color: AppColors.lineStrong),
      ),
      onSelected: (choice) async {
        final actions = ref.read(authActionsProvider);
        switch (choice) {
          case _Choice.signOut:
            if (user != null) {
              await actions.signOut();
            } else {
              actions.exitGuest();
            }
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem<_Choice>(
          enabled: false,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<_Choice>(
          value: _Choice.signOut,
          child: Row(
            children: [
              Icon(Icons.logout, color: AppColors.text),
              SizedBox(width: 12),
              Text('Cerrar sesión', style: TextStyle(color: AppColors.text)),
            ],
          ),
        ),
      ],
    );
  }
}

enum _Choice { signOut }
