import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/myths_counter_bar.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/myths_fab.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/notes_tab.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/roll_buttons_grid.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/roll_history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionPage extends ConsumerWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionControllerProvider);
    final active = state.active;
    if (active == null) {
      return const Scaffold(body: SizedBox.shrink());
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Volver a partidas',
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await ref.read(sessionControllerProvider.notifier).closeActive();
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
          title: Text(
            active.name,
            overflow: TextOverflow.ellipsis,
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, thickness: 1, color: AppColors.border),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'EVENTOS'),
                  Tab(text: 'HISTORIAL'),
                  Tab(text: 'NOTAS'),
                ],
              ),
              SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  children: [
                    RollButtonsGrid(),
                    RollHistoryList(),
                    NotesTab(),
                  ],
                ),
              ),
              MythsCounterBar(),
            ],
          ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: const MythsFab(),
      ),
    );
  }
}
