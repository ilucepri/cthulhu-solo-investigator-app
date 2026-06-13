import 'package:cthulhu_solo_investigator_app/core/constants/app_images.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TopNavigationBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  const TopNavigationBarWidget({this.actions, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          SvgPicture.asset(
            AppImages.logo,
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(AppColors.mythos, BlendMode.srcIn),
          ),
          const SizedBox(width: 14),
          const Text('SOLO INVESTIGATOR'),
        ],
      ),
      actions: actions,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: AppColors.border),
      ),
    );
  }
}
