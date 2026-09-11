import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/plan_controller.dart';
import '../../controller/user_profile_controller.dart';
import '../../models/ui_models/currency_info.dart';
import '../../models/ui_models/goal_catalog.dart';
import '../../utils/money_format.dart';
import '../../values/app_colors.dart';
import '../common_components/primary_button.dart';

/// Screen 11 — a single plan goal, with a working "deposit" action.
class GoalDetailScreen extends StatelessWidget {
  const GoalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PlanController>();
    final goalId = Get.arguments as int?;
    final currency = Get.find<UserProfileController>().baseCurrency.value;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('goal_detail'.tr), centerTitle: true),
      body: Obx(() {
        final goal = goalId == null ? null : c.goalById(goalId);
        if (goal == null) {
          return Center(
            child: Text('goal_not_found'.tr,
                style: const TextStyle(color: AppColors.textSecondary)),
          );
        }
        final meta = GoalCatalog.meta(goal.goalKey);
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                children: [
                  Center(
                    child: Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        color: meta.color.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(meta.icon, color: meta.color, size: 36),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(meta.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.heading)),
                  const SizedBox(height: 4),
                  Text(meta.tagline,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 24),
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
                            Text('goal_progress'.tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, color: AppColors.heading)),
                            const Spacer(),
                            Text('${goal.percent}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800, color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: goal.progress,
                            minHeight: 10,
                            backgroundColor: AppColors.trackBg,
                            valueColor: AlwaysStoppedAnimation(meta.color),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('goal_saved'.tr,
                                    style: const TextStyle(
                                        fontSize: 11, color: AppColors.textSecondary)),
                                Text(Money.format(goal.saved, currency),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.positive)),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('goal_still_needed'.tr,
                                    style: const TextStyle(
                                        fontSize: 11, color: AppColors.textSecondary)),
                                Text(Money.format(goal.remaining, currency),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.negative)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: Icons.flag_rounded,
                          label: 'goal_target'.tr,
                          value: Money.format(goal.target, currency),
                        ),
                        const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                        _InfoRow(
                          icon: Icons.calendar_today_rounded,
                          label: 'goal_deadline'.tr,
                          value: goal.deadline == null ? '—' : _d(goal.deadline!),
                        ),
                        const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                        _InfoRow(
                          icon: Icons.autorenew_rounded,
                          label: 'goal_monthly_saving'.tr,
                          value: Money.format(c.monthlySavingFor(goal), currency),
                        ),
                        if (goal.note.isNotEmpty) ...[
                          const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                          _InfoRow(
                            icon: Icons.sticky_note_2_rounded,
                            label: 'goal_note'.tr,
                            value: goal.note,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: 'goal_deposit'.tr,
                      trailingIcon: null,
                      onPressed: () => _deposit(context, c, goalId!, currency),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Get.snackbar('goal_detail'.tr, 'coming_soon'.tr,
                        snackPosition: SnackPosition.BOTTOM),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Icon(Icons.more_horiz_rounded, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void _deposit(BuildContext context, PlanController c, int goalId, String currency) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('goal_deposit'.tr),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0',
            suffixText: CurrencyInfo.byCode(currency).symbol,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dctx), child: Text('cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(90, 44)),
            onPressed: () {
              final amount = double.tryParse(ctrl.text.trim()) ?? 0;
              final goal = c.goalById(goalId);
              if (goal != null && amount > 0) c.depositToGoal(goal, amount);
              Navigator.pop(dctx);
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }

  static String _d(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 13.5)),
          ),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: AppColors.heading, fontSize: 13.5)),
          ),
        ],
      ),
    );
  }
}
