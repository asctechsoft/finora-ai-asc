import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/plan_controller.dart';
import '../../models/ui_models/plan_type.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class PlanTypeScreen extends StatelessWidget {
  const PlanTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PlanController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('plan_pick_type'.tr), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          Text('plan_pick_type_sub'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
          const SizedBox(height: 20),
          ...PlanType.values.map((type) => _TypeCard(
                type: type,
                onTap: () {
                  c.pickType(type);
                  Get.toNamed(RouteName.planGoalSuggest);
                },
              )),
        ],
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final PlanType type;
  final VoidCallback onTap;
  const _TypeCard({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: type.accent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: type.accent.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: type.accent.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(type.icon, color: type.accent, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type.title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.heading)),
                  const SizedBox(height: 4),
                  Text(type.subtitle,
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.textSecondary, height: 1.35)),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
