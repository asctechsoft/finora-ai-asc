import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/plan_controller.dart';
import '../../controller/user_profile_controller.dart';
import '../../models/ui_models/goal_catalog.dart';
import '../../models/ui_models/plan_type.dart';
import '../../utils/money_format.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';
import '../common_components/primary_button.dart';

/// Screen 8 — final check before the plan is written to the database.
class PlanReviewScreen extends StatefulWidget {
  const PlanReviewScreen({super.key});

  @override
  State<PlanReviewScreen> createState() => _PlanReviewScreenState();
}

class _PlanReviewScreenState extends State<PlanReviewScreen> {
  final _c = Get.find<PlanController>();
  bool _saving = false;

  Future<void> _start() async {
    setState(() => _saving = true);
    await _c.saveDraft();
    Get.offNamed(RouteName.planSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final currency = Get.find<UserProfileController>().baseCurrency.value;
    final type = _c.draftType.value ?? PlanType.personal;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('plan_review'.tr), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: type.accent.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(type.icon, color: type.accent, size: 26),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_c.draftName.value,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.heading)),
                                const SizedBox(height: 2),
                                Text(type.title,
                                    style: const TextStyle(
                                        fontSize: 12.5, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1, color: AppColors.divider),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: 15, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(_range,
                              style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary)),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('plan_monthly_budget'.tr,
                                  style: const TextStyle(
                                      fontSize: 11, color: AppColors.textSecondary)),
                              Text(Money.format(_c.draftBudget.value, currency),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.heading)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text('plan_goal_list'.tr,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.heading)),
                const SizedBox(height: 12),
                ..._c.draftGoalKeys.map((key) {
                  final meta = GoalCatalog.meta(key);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: meta.color.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(meta.icon, color: meta.color, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(meta.label,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.heading,
                                  fontSize: 14)),
                        ),
                        Text(Money.format(_c.monthlyAmountOf(key), currency),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.heading,
                                fontSize: 13.5)),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: PrimaryButton(
              label: 'plan_start'.tr,
              trailingIcon: null,
              loading: _saving,
              onPressed: _start,
            ),
          ),
        ],
      ),
    );
  }

  String get _range {
    final s = _c.draftStart.value;
    final e = _c.draftEnd.value;
    if (s == null || e == null) return '';
    return '${_d(s)} - ${_d(e)}';
  }

  static String _d(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}
