import 'package:cthulhu_solo_investigator_app/core/state/auth_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/auth/welcome_page.dart';
import 'package:cthulhu_solo_investigator_app/modules/campaigns/campaigns_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  void _closeOverlays(BuildContext context) {
    final nav = Navigator.maybeOf(context);
    if (nav == null) return;
    if (nav.canPop()) nav.popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (prev, next) {
      final wasIn = prev?.valueOrNull != null;
      final isIn = next.valueOrNull != null;
      if (!wasIn && isIn) _closeOverlays(context);
    });
    ref.listen(guestModeProvider, (prev, next) {
      if ((prev ?? false) == false && next == true) _closeOverlays(context);
    });

    final authState = ref.watch(authStateProvider);
    final guest = ref.watch(guestModeProvider);

    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      ),
      error: (_, __) => const WelcomePage(),
      data: (user) => (user != null || guest) ? const CampaignsPage() : const WelcomePage(),
    );
  }
}
