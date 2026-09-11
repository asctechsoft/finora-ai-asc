import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/plan_controller.dart';
import '../../models/ui_models/goal_catalog.dart';
import '../../models/ui_models/plan_type.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';
import '../common_components/primary_button.dart';

/// Screen 3/4 — goal ideas tailored to the plan type the user just picked.
class PlanGoalSuggestScreen extends StatelessWidget {
  const PlanGoalSuggestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PlanController>();
    final type = c.draftType.value ?? PlanType.personal;
    final suggestions = GoalCatalog.suggestions(type);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(type.planTitle), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              children: [
                Text(type.intro,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
                const SizedBox(height: 18),
                _Banner(type: type),
                const SizedBox(height: 22),
                Text('plan_common_goals'.tr,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.heading)),
                const SizedBox(height: 10),
                Obx(() => Column(
                      children: suggestions
                          .map((g) => _GoalPickRow(
                                meta: g,
                                selected: c.isGoalSelected(g.key),
                                onTap: () => c.toggleGoal(g.key),
                              ))
                          .toList(),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Obx(() => PrimaryButton(
                  label: 'continue_'.tr,
                  trailingIcon: null,
                  enabled: c.draftGoalKeys.isNotEmpty,
                  onPressed: () => Get.toNamed(RouteName.planBasicInfo),
                )),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final PlanType type;
  const _Banner({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            type.accent.withValues(alpha: 0.18),
            AppColors.primaryTintSoft,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(type.icon, color: type.accent, size: 36),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.softShadow,
              ),
              child: Text(type.quote,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.heading, height: 1.4)),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalPickRow extends StatelessWidget {
  final GoalMeta meta;
  final bool selected;
  final VoidCallback onTap;
  const _GoalPickRow({required this.meta, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: meta.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(meta.icon, color: meta.color, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(meta.label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.heading, fontSize: 14)),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: selected ? AppColors.primary : AppColors.textTertiary, width: 2),
                color: selected ? AppColors.primary : Colors.transparent,
              ),
              child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
