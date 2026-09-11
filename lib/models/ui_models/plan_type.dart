import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../values/app_colors.dart';

/// The five plan archetypes offered on "Chọn loại kế hoạch".
enum PlanType { personal, couple, familyChild, familyMulti, senior }

extension PlanTypeX on PlanType {
  String get key => name;

  static PlanType fromKey(String? key) =>
      PlanType.values.firstWhere((e) => e.name == key, orElse: () => PlanType.personal);

  String get title => switch (this) {
        PlanType.personal => 'plantype_personal_title'.tr,
        PlanType.couple => 'plantype_couple_title'.tr,
        PlanType.familyChild => 'plantype_family_child_title'.tr,
        PlanType.familyMulti => 'plantype_family_multi_title'.tr,
        PlanType.senior => 'plantype_senior_title'.tr,
      };

  String get subtitle => switch (this) {
        PlanType.personal => 'plantype_personal_sub'.tr,
        PlanType.couple => 'plantype_couple_sub'.tr,
        PlanType.familyChild => 'plantype_family_child_sub'.tr,
        PlanType.familyMulti => 'plantype_family_multi_sub'.tr,
        PlanType.senior => 'plantype_senior_sub'.tr,
      };

  /// Headline shown on the goal-suggestion screen ("Kế hoạch cá nhân").
  String get planTitle => switch (this) {
        PlanType.personal => 'plantype_personal_plan'.tr,
        PlanType.couple => 'plantype_couple_plan'.tr,
        PlanType.familyChild => 'plantype_family_child_plan'.tr,
        PlanType.familyMulti => 'plantype_family_multi_plan'.tr,
        PlanType.senior => 'plantype_senior_plan'.tr,
      };

  String get intro => switch (this) {
        PlanType.personal => 'plantype_personal_intro'.tr,
        PlanType.couple => 'plantype_couple_intro'.tr,
        PlanType.familyChild => 'plantype_family_child_intro'.tr,
        PlanType.familyMulti => 'plantype_family_multi_intro'.tr,
        PlanType.senior => 'plantype_senior_intro'.tr,
      };

  /// Motivational line shown in the banner speech bubble.
  String get quote => switch (this) {
        PlanType.personal => 'plantype_personal_quote'.tr,
        PlanType.couple => 'plantype_couple_quote'.tr,
        PlanType.familyChild => 'plantype_family_child_quote'.tr,
        PlanType.familyMulti => 'plantype_family_multi_quote'.tr,
        PlanType.senior => 'plantype_senior_quote'.tr,
      };

  IconData get icon => switch (this) {
        PlanType.personal => Icons.person_rounded,
        PlanType.couple => Icons.favorite_rounded,
        PlanType.familyChild => Icons.family_restroom_rounded,
        PlanType.familyMulti => Icons.groups_rounded,
        PlanType.senior => Icons.elderly_rounded,
      };

  Color get accent => switch (this) {
        PlanType.personal => AppColors.info,
        PlanType.couple => AppColors.dating,
        PlanType.familyChild => AppColors.warning,
        PlanType.familyMulti => AppColors.livingTogether,
        PlanType.senior => AppColors.married,
      };
}
