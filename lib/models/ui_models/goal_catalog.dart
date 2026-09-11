import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../values/app_colors.dart';
import 'plan_type.dart';

/// A plan goal template. The database stores [key]; visuals and localized
/// copy are resolved here, the same way [CategoryCatalog] works for spending.
class GoalMeta {
  final String key;
  final String labelKey;
  final String taglineKey;
  final IconData icon;
  final Color color;

  /// Default share of the monthly budget, in percent.
  final int weight;

  const GoalMeta(this.key, this.labelKey, this.taglineKey, this.icon, this.color, this.weight);

  String get label => labelKey.tr;
  String get tagline => taglineKey.tr;
}

class GoalCatalog {
  GoalCatalog._();

  static const daily =
      GoalMeta('daily', 'plangoal_daily', 'plangoal_daily_tag', Icons.calendar_today_rounded, AppColors.shopping, 30);
  static const saving =
      GoalMeta('saving', 'plangoal_saving', 'plangoal_saving_tag', Icons.savings_rounded, AppColors.positive, 20);
  static const invest =
      GoalMeta('invest', 'plangoal_invest', 'plangoal_invest_tag', Icons.trending_up_rounded, AppColors.info, 10);
  static const emergency =
      GoalMeta('emergency', 'plangoal_emergency', 'plangoal_emergency_tag', Icons.health_and_safety_rounded, AppColors.dating, 10);
  static const education =
      GoalMeta('education', 'plangoal_education', 'plangoal_education_tag', Icons.school_rounded, AppColors.married, 20);
  static const health =
      GoalMeta('health', 'plangoal_health', 'plangoal_health_tag', Icons.favorite_rounded, AppColors.negative, 10);
  static const house =
      GoalMeta('house', 'plangoal_house', 'plangoal_house_tag', Icons.home_rounded, AppColors.health, 10);
  static const travel =
      GoalMeta('travel', 'plangoal_travel', 'plangoal_travel_tag', Icons.flight_takeoff_rounded, AppColors.transport, 10);
  static const shopping =
      GoalMeta('shopping', 'plangoal_shopping', 'plangoal_shopping_tag', Icons.shopping_bag_rounded, AppColors.warning, 10);
  static const study =
      GoalMeta('study', 'plangoal_study', 'plangoal_study_tag', Icons.menu_book_rounded, AppColors.education, 10);
  static const wedding =
      GoalMeta('wedding', 'plangoal_wedding', 'plangoal_wedding_tag', Icons.favorite_border_rounded, AppColors.dating, 20);
  static const retire =
      GoalMeta('retire', 'plangoal_retire', 'plangoal_retire_tag', Icons.beach_access_rounded, AppColors.livingTogether, 20);

  static const List<GoalMeta> all = [
    daily, saving, invest, emergency, education, health,
    house, travel, shopping, study, wedding, retire,
  ];

  /// Goals every plan type can pick — the "Mục tiêu chung" section.
  static const List<GoalMeta> common = [daily, saving, invest, emergency];

  /// Goals specific to a plan type — the "Mục tiêu riêng" section.
  static List<GoalMeta> specific(PlanType type) => switch (type) {
        PlanType.personal => const [travel, shopping, house, study],
        PlanType.couple => const [house, wedding, travel, health],
        PlanType.familyChild => const [education, health, house, travel],
        PlanType.familyMulti => const [health, education, house, retire],
        PlanType.senior => const [health, retire, travel, house],
      };

  /// The six suggestions shown right after picking a plan type.
  static List<GoalMeta> suggestions(PlanType type) => switch (type) {
        PlanType.personal => const [saving, travel, shopping, house, study, invest],
        PlanType.couple => const [house, wedding, saving, travel, invest, emergency],
        PlanType.familyChild => const [daily, education, health, house, travel, emergency],
        PlanType.familyMulti => const [daily, health, education, emergency, saving, house],
        PlanType.senior => const [health, retire, emergency, saving, daily, travel],
      };

  static GoalMeta meta(String key) =>
      all.firstWhere((g) => g.key == key, orElse: () => saving);
}
