import 'package:cthulhu_solo_investigator_app/core/models/campaign.dart';
import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/auth/widgets/account_menu.dart';
import 'package:cthulhu_solo_investigator_app/modules/campaigns/dialogs/name_campaign_dialog.dart';
import 'package:cthulhu_solo_investigator_app/modules/campaigns/widgets/campaign_tile.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/dialogs/confirm_dialog.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/session_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CampaignsPage extends ConsumerWidget {
  const CampaignsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionControllerProvider);
    if (state.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }
    final byCreated = [...state.campaigns]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final codes = <String, String>{
      for (int i = 0; i < byCreated.length; i++)
        byCreated[i].id: 'EXP-${(i + 1).toString().padLeft(3, '0')}',
    };
    final byRecency = [...state.campaigns]
      ..sort((a, b) => b.lastPlayedAt.compareTo(a.lastPlayedAt));

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _Header(),
            Expanded(child: _Body(campaigns: byRecency, codes: codes)),
            _NewButton(onPressed: () => _createCampaign(context, ref)),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 66, 22, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 22, height: 2, color: AppColors.accent),
                const SizedBox(height: 14),
                const Text(
                  'EXPEDIENTES ABIERTOS',
                  style: TextStyle(
                    color: AppColors.dim,
                    fontSize: 11,
                    letterSpacing: 2.6,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Investigador\nSolitario',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 27,
                    height: 1.15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: AccountMenu(),
          ),
        ],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  final List<Campaign> campaigns;
  final Map<String, String> codes;
  const _Body({required this.campaigns, required this.codes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (campaigns.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Ningún expediente todavía.\nAbre uno y empieza a tomar notas.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.dim,
              fontSize: 14.5,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 12),
      itemCount: campaigns.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final c = campaigns[i];
        return CampaignTile(
          campaign: c,
          code: codes[c.id] ?? 'EXP-000',
          onOpen: () => _openCampaign(context, ref, c.id),
          onLongPress: () => _showCampaignMenu(context, ref, c),
        );
      },
    );
  }
}

class _NewButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _NewButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00161826), AppColors.bg],
          stops: [0.0, 0.4],
        ),
      ),
      child: SizedBox(
        height: 48,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(PhosphorIconsRegular.plus, size: 18),
          label: const Text('NUEVO EXPEDIENTE'),
        ),
      ),
    );
  }
}

Future<void> _createCampaign(BuildContext context, WidgetRef ref) async {
  final name = await showNameCampaignDialog(
    context,
    title: 'Nuevo expediente',
    body: 'Dale un nombre al caso. Podrás cambiarlo luego.',
    action: 'ABRIR',
    hint: 'Nombre del expediente',
  );
  if (name == null) return;
  final campaign =
      await ref.read(sessionControllerProvider.notifier).createCampaign(name);
  if (!context.mounted) return;
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const SessionPage()),
  );
  // ignore: unused_local_variable
  final _ = campaign;
}

Future<void> _openCampaign(BuildContext context, WidgetRef ref, String id) async {
  await ref.read(sessionControllerProvider.notifier).selectCampaign(id);
  if (!context.mounted) return;
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const SessionPage()),
  );
}

Future<void> _showCampaignMenu(
  BuildContext context,
  WidgetRef ref,
  Campaign c,
) async {
  final choice = await showModalBottomSheet<_MenuChoice>(
    context: context,
    backgroundColor: AppColors.surfaceSunken,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      side: BorderSide(color: AppColors.accent800),
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
                color: AppColors.accent300,
                fontSize: 11,
                letterSpacing: 2.4,
              ),
            ),
          ),
          const Divider(color: AppColors.lineSoft, height: 1),
          ListTile(
            leading: const Icon(PhosphorIconsRegular.notePencil, color: AppColors.text),
            title: const Text('Renombrar', style: TextStyle(color: AppColors.text)),
            onTap: () => Navigator.of(ctx).pop(_MenuChoice.rename),
          ),
          ListTile(
            leading: const Icon(PhosphorIconsRegular.eraser, color: AppColors.muted),
            title: const Text('Eliminar expediente',
                style: TextStyle(color: AppColors.text)),
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
        title: 'Renombrar expediente',
        body: 'Cambia el nombre del caso.',
        action: 'GUARDAR',
        hint: 'Nombre del expediente',
        initial: c.name,
      );
      if (newName != null) {
        await ref.read(sessionControllerProvider.notifier).renameCampaign(c.id, newName);
      }
    case _MenuChoice.delete:
      final ok = await showConfirmDialog(
        context,
        title: 'Eliminar "${c.name}"',
        body: 'Se borrará este expediente y todo su contenido. ¿Continuar?',
        action: 'ELIMINAR',
      );
      if (ok == true) {
        await ref.read(sessionControllerProvider.notifier).deleteCampaign(c.id);
      }
  }
}

enum _MenuChoice { rename, delete }
