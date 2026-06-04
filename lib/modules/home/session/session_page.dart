import 'package:cthulhu_solo_investigator_app/core/state/session_controller.dart';
import 'package:cthulhu_solo_investigator_app/core/theme/app_theme.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/myths_counter_bar.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/myths_fab.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/roll_buttons_grid.dart';
import 'package:cthulhu_solo_investigator_app/modules/home/session/widgets/roll_history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionPage extends ConsumerStatefulWidget {
  const SessionPage({super.key});

  @override
  ConsumerState<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends ConsumerState<SessionPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(sessionControllerProvider).loading;
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.mythos)),
      );
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            TabBar(
              controller: _tabs,
              tabs: const [
                Tab(text: 'EVENTOS'),
                Tab(text: 'HISTORIAL'),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: const [
                  RollButtonsGrid(),
                  RollHistoryList(),
                ],
              ),
            ),
            const MythsCounterBar(),
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: const MythsFab(),
    );
  }
}
