import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../values/app_colors.dart';
import '../screen_placeholder/placeholder_tab.dart';
import '../screen_transactions/transactions_screen.dart';
import '../screens_quick_add/quick_add_sheet.dart';
import 'home_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  List<Widget> get _tabs => [
    const HomeScreen(),
    const TransactionsScreen(),
    PlaceholderTab(title: 'tab_plan'.tr, icon: Icons.insights_rounded,
        message: 'placeholder_plan'.tr),
    PlaceholderTab(title: 'tab_household'.tr, icon: Icons.groups_rounded,
        message: 'placeholder_household'.tr),
    PlaceholderTab(title: 'tab_ai_copilot'.tr, icon: Icons.auto_awesome_rounded,
        message: 'placeholder_ai'.tr),
  ];

  List<(IconData, String)> get _items => [
    (Icons.home_rounded, 'tab_home'.tr),
    (Icons.receipt_long_rounded, 'tab_transactions'.tr),
    (Icons.insights_rounded, 'tab_plan'.tr),
    (Icons.groups_rounded, 'tab_household'.tr),
    (Icons.public_rounded, 'tab_ai'.tr),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              children: [
                for (var i = 0; i < _items.length; i++)
                  Expanded(
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
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
