import 'package:cthulhu_solo_investigator_app/core/models/campaign.dart';
import 'package:cthulhu_solo_investigator_app/core/models/myths_level.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CampaignTile extends StatelessWidget {
  final Campaign campaign;
  final String code;
  final VoidCallback onOpen;
  final VoidCallback onLongPress;

  const CampaignTile({
    required this.campaign,
    required this.code,
    required this.onOpen,
    required this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final level = MythsLevel.forCounter(campaign.mythsCounter);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onOpen,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.line, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ribbon(campaign.mythsCounter > 7),
                  Expanded(child: _content(level)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ribbon(bool intense) {
    return SizedBox(
      width: 3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: intense
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.accent, AppColors.accent700],
                )
              : null,
          color: intense ? null : AppColors.lineStrong,
        ),
      ),
    );
  }

  Widget _content(MythsLevel level) {
    final fill = (campaign.mythsCounter / 20).clamp(0.0, 1.0);
    final metaBits = <String>[
      if (campaign.rolls.isNotEmpty) '${campaign.rolls.length} tiradas',
      'última: ${_formatDate(campaign.lastPlayedAt)}',
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 15, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  code,
                  style: const TextStyle(
                    color: AppColors.dim,
                    fontSize: 10,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              Text(
                level.label,
                style: TextStyle(
                  color: level.color,
                  fontSize: 10,
                  letterSpacing: 1.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            campaign.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            metaBits.join('  ·  '),
            style: const TextStyle(color: AppColors.muted, fontSize: 12.5),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B2D3A),
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: fill,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.accent700, AppColors.accent],
                          ),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'MITOS ${campaign.mythsCounter}',
                style: const TextStyle(
                  color: AppColors.dim,
                  fontSize: 11,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'hoy';
    }
    final yd = now.subtract(const Duration(days: 1));
    if (d.year == yd.year && d.month == yd.month && d.day == yd.day) {
      return 'ayer';
    }
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm';
  }
}
