import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/plan_controller.dart';
import '../../controller/user_profile_controller.dart';
import '../../models/ui_models/goal_catalog.dart';
import '../../utils/money_format.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';
import '../common_components/primary_button.dart';

/// Step 3/3 — split the monthly budget across the selected goals.
class PlanBudgetScreen extends StatelessWidget {
  const PlanBudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PlanController>();
    final currency = Get.find<UserProfileController>().baseCurrency.value;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text('plan_allocate'.tr,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.heading)),
            Text('plan_step'.trArgs(['3']),
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
      body: Obx(() {
        final keys = c.draftGoalKeys.toList();
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                children: [
                  SizedBox(
                    height: 210,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            startDegreeOffset: -90,
                            sectionsSpace: 3,
                            centerSpaceRadius: 68,
                            sections: keys.map((key) {
                              final meta = GoalCatalog.meta(key);
                              return PieChartSectionData(
                                value: c.allocationOf(key).toDouble(),
                                color: meta.color,
                                radius: 26,
                                showTitle: false,
                              );
                            }).toList(),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(Money.format(c.draftBudget.value, currency),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.heading)),
                            Text('plan_per_month'.tr,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...keys.map((key) => _AllocationRow(
                        goalKey: key,
                        controller: c,
                        currency: currency,
                      )),
                  const SizedBox(height: 8),
                  _TotalRow(allocated: c.allocatedPercent),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: PrimaryButton(
                label: 'plan_finish'.tr,
                trailingIcon: null,
                enabled: c.allocatedPercent == 100,
                onPressed: () => Get.toNamed(RouteName.planReview),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  final String goalKey;
  final PlanController controller;
  final String currency;
  const _AllocationRow({
    required this.goalKey,
    required this.controller,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final meta = GoalCatalog.meta(goalKey);
    final percent = controller.allocationOf(goalKey);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: meta.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(meta.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.heading, fontSize: 14)),
          ),
          _PercentStepper(
            percent: percent,
            onChanged: (v) => controller.setAllocation(goalKey, v),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 96,
            child: Text(Money.format(controller.monthlyAmountOf(goalKey), currency),
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.heading)),
          ),
        ],
      ),
    );
  }
}

class _PercentStepper extends StatelessWidget {
  final int percent;
  final ValueChanged<int> onChanged;
  const _PercentStepper({required this.percent, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepButton(icon: Icons.remove_rounded, onTap: () => onChanged(percent - 5)),
        SizedBox(
          width: 42,
          child: Text('$percent%',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
        ),
        _StepButton(icon: Icons.add_rounded, onTap: () => onChanged(percent + 5)),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: AppColors.trackBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 15, color: AppColors.textSecondary),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final int allocated;
  const _TotalRow({required this.allocated});

  @override
  Widget build(BuildContext context) {
    final ok = allocated == 100;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: ok ? AppColors.primaryTintSoft : AppColors.negative.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(ok ? Icons.check_circle_rounded : Icons.info_outline_rounded,
              size: 18, color: ok ? AppColors.primary : AppColors.negative),
          const SizedBox(width: 10),
          Expanded(
            child: Text(ok ? 'plan_alloc_ok'.tr : 'plan_alloc_warning'.trArgs(['$allocated']),
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: ok ? AppColors.primary : AppColors.negative)),
          ),
        ],
      ),
    );
  }
}
