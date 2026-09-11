import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/budget_controller.dart';
import '../../controller/user_profile_controller.dart';
import '../../models/ui_models/category_catalog.dart';
import '../../presentation/common_components/primary_button.dart';
import '../../presentation/common_components/progress_ring.dart';
import '../../utils/date_helper.dart';
import '../../utils/money_format.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class BudgetListScreen extends StatelessWidget {
  const BudgetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(BudgetController());
    final currency = Get.find<UserProfileController>().baseCurrency.value;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('budgets'.tr),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_rounded, color: AppColors.primary)),
        ],
      ),
      body: Obx(() {
        if (c.loading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            Text('budgets_subtitle'.tr,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text('this_month'.tr, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.heading)),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textSecondary),
                    ],
                  ),
                ),
                const Spacer(),
                Text(DateHelper.monthLabel(DateTime.now()),
                    style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ProgressRing(
                  progress: c.totalBudget.value <= 0 ? 0 : c.totalSpent.value / c.totalBudget.value,
                  size: 130,
                  stroke: 14,
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(Money.format(c.totalSpent.value, currency),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.heading)),
                      Text('of_amount'.trArgs([Money.format(c.totalBudget.value, currency)]),
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      Text('spent'.tr, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Money.format(c.remaining, currency),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      Text('left_to_spend'.tr, style: const TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTintSoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${c.percentUsed}%',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
                            Text('of_budget_used'.tr, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...c.lines.map((line) => _CategoryRow(line: line, currency: currency)),
            const SizedBox(height: 16),
            PrimaryButton(label: 'view_insights'.tr, onPressed: () {}),
          ],
        );
      }),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final BudgetLine line;
  final String currency;
  const _CategoryRow({required this.line, required this.currency});

  @override
  Widget build(BuildContext context) {
    final meta = CategoryCatalog.meta(line.categoryKey);
    return GestureDetector(
      onTap: () => Get.toNamed(RouteName.budgetDetail, arguments: line.categoryKey),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(meta.icon, color: meta.color, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(meta.label,
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
                      ),
                      Text('${Money.format(line.spent, currency)} / ${Money.format(line.budget, currency)}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: line.progress,
                      minHeight: 8,
                      backgroundColor: AppColors.trackBg,
                      valueColor: AlwaysStoppedAnimation(
                          line.progress >= 1 ? AppColors.negative : meta.color),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('${line.percent}%',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
