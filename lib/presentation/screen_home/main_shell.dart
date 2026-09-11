import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../values/app_colors.dart';
import '../screen_plan/plan_screen.dart';
import '../screen_settings/settings_screen.dart';
import '../screen_transactions/transactions_screen.dart';
import '../screens_quick_add/quick_add_sheet.dart';
import 'home_screen.dart';

/// Sinks the docked FAB deeper into the bottom bar so only its top arc
/// peeks above the bar, instead of sitting centered on the bar's edge.
class _LoweredCenterDocked extends FloatingActionButtonLocation {
  const _LoweredCenterDocked();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final base = FloatingActionButtonLocation.centerDocked.getOffset(scaffoldGeometry);
    return Offset(base.dx, base.dy + 18);
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = switch (Get.arguments) {
    final int tab when tab >= 0 && tab < 4 => tab,
    _ => 0,
  };

  List<Widget> get _tabs => const [
    HomeScreen(),
    TransactionsScreen(),
    PlanScreen(),
    SettingsScreen(),
  ];

  List<(IconData, String)> get _items => [
    (Icons.home_rounded, 'tab_home'.tr),
    (Icons.bar_chart_rounded, 'tab_stats'.tr),
    (Icons.insights_rounded, 'tab_plan'.tr),
    (Icons.settings_rounded, 'tab_settings'.tr),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _index, children: _tabs),
      floatingActionButton: FloatingActionButton(
        onPressed: () => QuickAddSheet.show(context),
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: const _LoweredCenterDocked(),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.card,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        elevation: 8,
        padding: EdgeInsets.zero,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              children: [
                _navItem(0),
                _navItem(1),
                const SizedBox(width: 64),
                _navItem(2),
                _navItem(3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int i) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _index = i),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_items[i].$1,
                size: 24,
                color: _index == i ? AppColors.primary : AppColors.textTertiary),
            const SizedBox(height: 3),
            Text(_items[i].$2,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _index == i ? AppColors.primary : AppColors.textTertiary,
                )),
          ],
        ),
      ),
    );
  }
}
