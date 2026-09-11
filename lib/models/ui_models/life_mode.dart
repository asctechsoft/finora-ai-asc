import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../values/app_colors.dart';

enum LifeMode { solo, dating, livingTogether, married, withChild, withParents, custom }

extension LifeModeX on LifeMode {
  String get key => name;

  static LifeMode fromKey(String? key) {
    return LifeMode.values.firstWhere(
      (e) => e.name == key,
      orElse: () => LifeMode.solo,
    );
  }

  String get title => switch (this) {
    LifeMode.solo => 'lifemode_solo_title'.tr,
    LifeMode.dating => 'lifemode_dating_title'.tr,
    LifeMode.livingTogether => 'lifemode_living_title'.tr,
    LifeMode.married => 'lifemode_married_title'.tr,
    LifeMode.withChild => 'lifemode_child_title'.tr,
    LifeMode.withParents => 'lifemode_parents_title'.tr,
    LifeMode.custom => 'lifemode_custom_title'.tr,
  };

  String get subtitle => switch (this) {
    LifeMode.solo => 'lifemode_solo_sub'.tr,
    LifeMode.dating => 'lifemode_dating_sub'.tr,
    LifeMode.livingTogether => 'lifemode_living_sub'.tr,
    LifeMode.married => 'lifemode_married_sub'.tr,
    LifeMode.withChild => 'lifemode_child_sub'.tr,
    LifeMode.withParents => 'lifemode_parents_sub'.tr,
    LifeMode.custom => 'lifemode_custom_sub'.tr,
  };

  /// Short chip label shown on the Home header.
  String get chipLabel => switch (this) {
    LifeMode.solo => 'lifemode_solo_chip'.tr,
    LifeMode.dating => 'lifemode_dating_chip'.tr,
    LifeMode.livingTogether => 'lifemode_living_chip'.tr,
    LifeMode.married => 'lifemode_married_chip'.tr,
    LifeMode.withChild => 'lifemode_family_chip'.tr,
    LifeMode.withParents => 'lifemode_family_chip'.tr,
    LifeMode.custom => 'lifemode_custom_chip'.tr,
  };

  IconData get icon => switch (this) {
    LifeMode.solo => Icons.person_rounded,
    LifeMode.dating => Icons.favorite_rounded,
    LifeMode.livingTogether => Icons.home_rounded,
    LifeMode.married => Icons.diamond_rounded,
    LifeMode.withChild => Icons.family_restroom_rounded,
    LifeMode.withParents => Icons.groups_rounded,
    LifeMode.custom => Icons.settings_rounded,
  };

  Color get accent => switch (this) {
    LifeMode.solo => AppColors.solo,
    LifeMode.dating => AppColors.dating,
    LifeMode.livingTogether => AppColors.livingTogether,
    LifeMode.married => AppColors.married,
    LifeMode.withChild => AppColors.family,
    LifeMode.withParents => AppColors.family,
    LifeMode.custom => AppColors.other,
  };

  bool get isShared => this != LifeMode.solo && this != LifeMode.custom;
}
