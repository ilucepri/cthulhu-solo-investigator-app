import 'package:cthulhu_solo_investigator_app/core/state/auth_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/auth/welcome_page.dart';
import 'package:cthulhu_solo_investigator_app/modules/campaigns/campaigns_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final guest = ref.watch(guestModeProvider);

    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.mythos)),
      ),
      error: (_, __) => const WelcomePage(),
      data: (user) {
        if (user != null || guest) return const CampaignsPage();
        return const WelcomePage();
      },
    );
  }
}
