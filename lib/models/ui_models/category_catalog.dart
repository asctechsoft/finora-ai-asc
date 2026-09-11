import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../values/app_colors.dart';

/// Static catalog mapping a category [key] to its icon + color. The database
/// stores the key; the UI resolves visuals + localized label here.
class CategoryMeta {
  final String key;
  final String labelKey;
  final IconData icon;
  final Color color;

  const CategoryMeta(this.key, this.labelKey, this.icon, this.color);

  String get label => labelKey.tr;
}

class CategoryCatalog {
  CategoryCatalog._();

  static const List<CategoryMeta> expense = [
    CategoryMeta('housing', 'cat_housing', Icons.home_rounded, AppColors.housing),
    CategoryMeta('food', 'cat_food', Icons.restaurant_rounded, AppColors.food),
    CategoryMeta('transport', 'cat_transport', Icons.directions_car_rounded, AppColors.transport),
    CategoryMeta('shopping', 'cat_shopping', Icons.shopping_bag_rounded, AppColors.shopping),
    CategoryMeta('entertainment', 'cat_entertainment', Icons.sports_esports_rounded, AppColors.entertainment),
    CategoryMeta('health', 'cat_health', Icons.favorite_rounded, AppColors.health),
    CategoryMeta('education', 'cat_education', Icons.school_rounded, AppColors.education),
    CategoryMeta('bills', 'cat_bills', Icons.receipt_long_rounded, AppColors.info),
    CategoryMeta('childcare', 'cat_childcare', Icons.child_care_rounded, AppColors.family),
    CategoryMeta('other', 'cat_other', Icons.category_rounded, AppColors.other),
  ];

  static const List<CategoryMeta> incomeCats = [
    CategoryMeta('salary', 'cat_salary', Icons.payments_rounded, AppColors.income),
    CategoryMeta('freelance', 'cat_freelance', Icons.work_rounded, AppColors.warning),
    CategoryMeta('investment', 'cat_investment', Icons.trending_up_rounded, AppColors.info),
    CategoryMeta('gift', 'cat_gift', Icons.card_giftcard_rounded, AppColors.dating),
    CategoryMeta('other_income', 'cat_other_income', Icons.attach_money_rounded, AppColors.other),
  ];

  static CategoryMeta meta(String key) {
    for (final c in expense) {
      if (c.key == key) return c;
    }
    for (final c in incomeCats) {
      if (c.key == key) return c;
    }
    return const CategoryMeta('other', 'cat_other', Icons.category_rounded, AppColors.other);
  }
}
