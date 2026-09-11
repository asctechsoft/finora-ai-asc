import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/onboarding_controller.dart';
import '../../controller/user_profile_controller.dart';
import '../../presentation/common_components/onboarding_scaffold.dart';
import '../../presentation/common_components/primary_button.dart';
import '../../services/seed_service.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class _GoalOpt {
  final String key;
  final String label;
  final IconData icon;
  const _GoalOpt(this.key, this.label, this.icon);
}

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  static const _opts = [
    _GoalOpt('emergency', 'goal_emergency', Icons.shield_rounded),
    _GoalOpt('home', 'goal_home', Icons.home_rounded),
    _GoalOpt('travel', 'goal_travel', Icons.flight_rounded),
    _GoalOpt('wealth', 'goal_wealth', Icons.trending_up_rounded),
    _GoalOpt('debt', 'goal_debt', Icons.credit_card_rounded),
    _GoalOpt('retire', 'goal_retire', Icons.beach_access_rounded),
    _GoalOpt('other', 'goal_other', Icons.add_rounded),
  ];

  Future<void> _createPlan() async {
    final c = Get.find<OnboardingController>();
    await c.complete();
    await SeedService().ensureSeeded(c.currency.value);
    Get.find<UserProfileController>().load();
    Get.offAllNamed(RouteName.home);
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OnboardingController>();
    return OnboardingScaffold(
      step: 6,
      totalSteps: 6,
      bottom: PrimaryButton(
        label: 'create_my_plan'.tr,
        onPressed: _createPlan,
      ),
      child: ListView(
        children: [
          const Icon(Icons.track_changes_rounded, color: AppColors.primary, size: 30),
          const SizedBox(height: 12),
          Text('goals_title'.tr,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.heading)),
          const SizedBox(height: 10),
          Text('goals_subtitle'.tr,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppColors.softShadow,
            ),
            child: Column(
              children: [
                for (var i = 0; i < _opts.length; i++) ...[
                  Obx(() => Row(
                        children: [
                          Icon(_opts[i].icon, color: AppColors.primary, size: 22),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(_opts[i].label.tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: AppColors.heading)),
                          ),
                          Switch.adaptive(
                            value: c.goals[_opts[i].key] ?? false,
                            activeThumbColor: AppColors.primary,
                            onChanged: (_) => c.toggleGoal(_opts[i].key),
                          ),
                        ],
                      )),
                  if (i != _opts.length - 1)
                    const Divider(height: 1, color: AppColors.divider),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryTintSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('smart_plan_title'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
                      const SizedBox(height: 6),
                      Text('smart_plan_desc'.tr,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
