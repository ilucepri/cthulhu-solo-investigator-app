import 'package:cthulhu_solo_investigator_app/core/models/campaign.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CampaignTile extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback onOpen;
  final VoidCallback onMenu;

  const CampaignTile({
    required this.campaign,
    required this.onOpen,
    required this.onMenu,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: InkWell(
        onTap: onOpen,
        onLongPress: onMenu,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.menu_book_outlined, color: AppColors.mythos, size: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campaign.name,
                      style: const TextStyle(
                        color: AppColors.parchment,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _subtitle(),
                      style: const TextStyle(color: AppColors.parchmentDim, fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Más opciones',
                onPressed: onMenu,
                icon: const Icon(Icons.more_vert, color: AppColors.parchmentDim),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitle() {
    final parts = <String>[];
    if (campaign.rolls.isNotEmpty) {
      parts.add('${campaign.rolls.length} tiradas');
    }
    if (campaign.mythsCounter > 0) {
      parts.add('Mitos ${campaign.mythsCounter}');
    }
    parts.add('última: ${_formatDate(campaign.lastPlayedAt)}');
    return parts.join(' · ');
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }
}
