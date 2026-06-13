import 'package:cthulhu_solo_investigator_app/core/models/campaign.dart';
import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/auth/widgets/account_menu.dart';
import 'package:cthulhu_solo_investigator_app/modules/campaigns/dialogs/name_campaign_dialog.dart';
import 'package:cthulhu_solo_investigator_app/modules/campaigns/widgets/campaign_tile.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/dialogs/confirm_dialog.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/session_page.dart';
import 'package:cthulhu_solo_investigator_app/modules/menu/nav_bar_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CampaignsPage extends ConsumerWidget {
  const CampaignsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionControllerProvider);

    return Scaffold(
      appBar: const TopNavigationBarWidget(actions: [AccountMenu()]),
      body: state.loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.mythos))
          : _buildBody(context, ref, state.campaigns),
      floatingActionButton: state.loading
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _createCampaign(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('NUEVA PARTIDA'),
            ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, List<Campaign> campaigns) {
    if (campaigns.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'No hay partidas todavía.\nPulsa "Nueva partida" para comenzar tu investigación.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.parchmentDim, fontSize: 16, height: 1.4),
          ),
        ),
      );
    }
    final ordered = [...campaigns]
      ..sort((a, b) => b.lastPlayedAt.compareTo(a.lastPlayedAt));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
          .copyWith(bottom: 96),
      itemCount: ordered.length,
      itemBuilder: (_, i) {
        final c = ordered[i];
        return CampaignTile(
          campaign: c,
          onOpen: () => _openCampaign(context, ref, c.id),
          onMenu: () => _showCampaignMenu(context, ref, c),
        );
      },
    );
  }

  Future<void> _createCampaign(BuildContext context, WidgetRef ref) async {
    final name = await showNameCampaignDialog(
      context,
      title: 'Nueva partida',
      actionLabel: 'Crear',
    );
    if (name == null) return;
    final campaign = await ref.read(sessionControllerProvider.notifier).createCampaign(name);
    if (!context.mounted) return;
    _pushSession(context, campaign.id);
  }

  Future<void> _openCampaign(BuildContext context, WidgetRef ref, String id) async {
    await ref.read(sessionControllerProvider.notifier).selectCampaign(id);
    if (!context.mounted) return;
    _pushSession(context, id);
  }

  void _pushSession(BuildContext context, String id) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SessionPage()),
    );
  }

  Future<void> _showCampaignMenu(BuildContext context, WidgetRef ref, Campaign c) async {
    final choice = await showModalBottomSheet<_MenuChoice>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        side: BorderSide(color: AppColors.border),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                c.name,
                style: const TextStyle(
                  color: AppColors.mythos,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const Divider(color: AppColors.border, height: 1),
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline, color: AppColors.parchment),
              title: const Text('Renombrar', style: TextStyle(color: AppColors.parchment)),
              onTap: () => Navigator.of(ctx).pop(_MenuChoice.rename),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.blood),
              title: const Text('Eliminar partida',
                  style: TextStyle(color: AppColors.parchment)),
              onTap: () => Navigator.of(ctx).pop(_MenuChoice.delete),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (choice == null || !context.mounted) return;
    switch (choice) {
      case _MenuChoice.rename:
        final newName = await showNameCampaignDialog(
          context,
          title: 'Renombrar partida',
          actionLabel: 'Guardar',
          initial: c.name,
        );
        if (newName != null) {
          await ref.read(sessionControllerProvider.notifier).renameCampaign(c.id, newName);
        }
      case _MenuChoice.delete:
        final ok = await showConfirmDialog(
          context,
          title: 'Eliminar "${c.name}"',
          body: 'Se borrará esta partida y todo su contenido. ¿Continuar?',
        );
        if (ok == true) {
          await ref.read(sessionControllerProvider.notifier).deleteCampaign(c.id);
        }
    }
  }
}

enum _MenuChoice { rename, delete }
