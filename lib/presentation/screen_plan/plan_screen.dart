import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/plan_controller.dart';
import '../../controller/user_profile_controller.dart';
import '../../models/data_models/plan.dart';
import '../../models/data_models/plan_goal.dart';
import '../../models/ui_models/goal_catalog.dart';
import '../../models/ui_models/plan_type.dart';
import '../../utils/money_format.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';
import '../common_components/primary_button.dart';
import '../common_components/section_header.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PlanController(), permanent: true);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (c.loading.value) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          return c.hasPlan ? _PlanOverview(c: c) : _EmptyState(c: c);
        }),
      ),
    );
  }
}

void _startWizard(PlanController c) {
  c.startDraft();
  Get.toNamed(RouteName.planType);
}

class _EmptyState extends StatelessWidget {
  final PlanController c;
  const _EmptyState({required this.c});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 110),
      children: [
        Text('plan_title'.tr,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.heading)),
        const SizedBox(height: 4),
        Text('plan_subtitle'.tr, style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 32),
        Image.asset('assets/images/png/img_muc_tieu.png', height: 220),
        const SizedBox(height: 28),
        Text('plan_empty_title'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.heading)),
        const SizedBox(height: 10),
        Text('plan_empty_sub'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: 28),
        PrimaryButton(
          label: 'plan_create_new'.tr,
          trailingIcon: null,
          onPressed: () => _startWizard(c),
        ),
      ],
    );
  }
}

class _PlanOverview extends StatelessWidget {
  final PlanController c;
  const _PlanOverview({required this.c});

  @override
  Widget build(BuildContext context) {
    final currency = Get.find<UserProfileController>().baseCurrency.value;
    // Everything reactive is read inside this builder so updates (e.g. a goal
    // deposit) repaint the overview — reads in child widgets would not.
    return Obx(() {
      final plan = c.activePlan!;
      final goals = c.goals.toList();
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: [
          Row(
            children: [
              Text('plan_title'.tr,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.heading)),
              const Spacer(),
              GestureDetector(
                onTap: () => _startWizard(c),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTintSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PlanSelector(c: c, plan: plan, planCount: c.plans.length),
          const SizedBox(height: 20),
          _ProgressCard(
            percent: c.overallPercent,
            progress: c.overallProgress,
            saved: c.totalSaved,
            remaining: c.totalRemaining,
            currency: currency,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _ActionButton(icon: Icons.bar_chart_rounded, label: 'plan_action_stats'.tr),
              const SizedBox(width: 12),
              _ActionButton(icon: Icons.tune_rounded, label: 'plan_action_adjust'.tr),
              const SizedBox(width: 12),
              _ActionButton(icon: Icons.add_circle_outline_rounded, label: 'plan_action_add_goal'.tr),
            ],
          ),
          const SizedBox(height: 24),
          SectionHeader(title: 'plan_goals'.tr, actionLabel: 'see_all'.tr, onAction: () {}),
          const SizedBox(height: 12),
          ...goals.map((g) => _GoalRow(goal: g, currency: currency)),
        ],
      );
    });
  }
}

class _PlanSelector extends StatelessWidget {
  final PlanController c;
  final Plan plan;
  final int planCount;
  const _PlanSelector({required this.c, required this.plan, required this.planCount});

  @override
  Widget build(BuildContext context) {
    final type = PlanTypeX.fromKey(plan.type);
    return GestureDetector(
      onTap: planCount < 2 ? null : () => _showPlanPicker(context),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: type.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(type.icon, color: type.accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: AppColors.heading, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(_range(plan),
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (c.plans.length > 1)
              const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showPlanPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('plan_switch'.tr,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.heading)),
              const SizedBox(height: 8),
              ...c.plans.map((p) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(PlanTypeX.fromKey(p.type).icon,
                        color: PlanTypeX.fromKey(p.type).accent),
                    title: Text(p.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: AppColors.heading, fontSize: 14)),
                    subtitle: Text(_range(p),
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    trailing: p.id == plan.id
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20)
                        : null,
                    onTap: () {
                      c.selectPlan(p.id!);
                      Navigator.pop(ctx);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  static String _range(Plan p) =>
      '${_d(p.startDate)} - ${_d(p.endDate)}';

  static String _d(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class _ProgressCard extends StatelessWidget {
  final int percent;
  final double progress;
  final double saved;
  final double remaining;
  final String currency;
  const _ProgressCard({
    required this.percent,
    required this.progress,
    required this.saved,
    required this.remaining,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('plan_progress'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
              const Spacer(),
              Text('$percent%',
                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.trackBg,
              valueColor: const AlwaysStoppedAnimation(AppColors.positive),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('plan_saved'.tr, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(width: 4),
              Text(Money.format(saved, currency),
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.positive)),
              const Spacer(),
              Text('plan_remaining'.tr,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(width: 4),
              Text(Money.format(remaining, currency),
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.heading)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Get.snackbar(label, 'coming_soon'.tr, snackPosition: SnackPosition.BOTTOM),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppColors.softShadow,
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(height: 6),
              Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  final PlanGoal goal;
  final String currency;
  const _GoalRow({required this.goal, required this.currency});

  @override
  Widget build(BuildContext context) {
    final meta = GoalCatalog.meta(goal.goalKey);
    return GestureDetector(
      onTap: () => Get.toNamed(RouteName.goalDetail, arguments: goal.id),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: meta.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(meta.icon, color: meta.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(meta.label,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, color: AppColors.heading, fontSize: 14)),
                      ),
                      Text('${goal.percent}%',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, color: AppColors.heading, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: goal.progress,
                      minHeight: 7,
                      backgroundColor: AppColors.trackBg,
                      valueColor: AlwaysStoppedAnimation(meta.color),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('${Money.format(goal.saved, currency)} / ${Money.format(goal.target, currency)}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
