import 'package:cthulhu_solo_investigator_app/core/constants/app_images.dart';
import 'package:cthulhu_solo_investigator_app/core/state/auth_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/auth/login_page.dart';
import 'package:cthulhu_solo_investigator_app/modules/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(
                AppImages.logo,
                width: 96,
                height: 96,
                colorFilter: const ColorFilter.mode(AppColors.mythos, BlendMode.srcIn),
              ),
              const SizedBox(height: 24),
              const Text(
                'SOLO INVESTIGATOR',
                style: TextStyle(
                  color: AppColors.parchment,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3.0,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Un manual para investigar en solitario\nlos misterios de los Antiguos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.parchmentDim,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('ENTRAR', style: TextStyle(letterSpacing: 1.5)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border, width: 1),
                    foregroundColor: AppColors.parchment,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                  child: const Text(
                    'CREAR CUENTA',
                    style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => ref.read(authActionsProvider).continueAsGuest(),
                child: const Text(
                  'Jugar sin cuenta',
                  style: TextStyle(
                    color: AppColors.parchmentDim,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.parchmentDim,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
