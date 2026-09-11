import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/ui_models/life_mode.dart';
import '../values/app_colors.dart';

/// Home tile: [labelKey] is localized; value/delta are demo figures kept literal.
class HomeTile {
  final String labelKey;
  final String value;
  final String delta;
  final bool deltaPositive;
  const HomeTile(this.labelKey, this.value, this.delta, {this.deltaPositive = true});
  String get label => labelKey.tr;
}

class HomeAction {
  final String labelKey;
  final IconData icon;
  const HomeAction(this.labelKey, this.icon);
  String get label => labelKey.tr;
}

class HomeBill {
  final String nameKey;
  final String amount;
  final String dueKey;
  final String dueArg; // '' -> no param
  final IconData icon;
  final Color color;
  const HomeBill(this.nameKey, this.amount, this.dueKey, this.dueArg, this.icon, this.color);
  String get name => nameKey.tr;
  String get due => dueArg.isEmpty ? dueKey.tr : dueKey.trArgs([dueArg]);
}

/// Baseline per-mode Home content matching the Figma variants 1:1. Labels are
/// localized via keys; the Safe-to-Spend hero amount is overridden at runtime by
/// the real DB balance so Quick Add demonstrably moves it.
class HomeConfig {
  final String heroLabelKey;
  final IconData heroIcon;
  final double budget;
  final double safeToSpend;
  final String greetingNames; // sample data — kept literal
  final String pulseTitleKey;
  final String pulseSubKey;
  final List<HomeTile> tiles;
  final List<HomeAction> actions;
  final List<HomeBill> bills;

  const HomeConfig({
    required this.heroLabelKey,
    required this.heroIcon,
    required this.budget,
    required this.safeToSpend,
    required this.greetingNames,
    required this.pulseTitleKey,
    required this.pulseSubKey,
    required this.tiles,
    required this.actions,
    required this.bills,
  });

  String get heroLabel => heroLabelKey.tr;
  String get pulseTitle => pulseTitleKey.tr;
  String get pulseSubtitle => pulseSubKey.tr;

  static HomeConfig of(LifeMode mode) => switch (mode) {
        LifeMode.dating => _dating,
        LifeMode.livingTogether => _livingTogether,
        LifeMode.married => _married,
        LifeMode.withChild || LifeMode.withParents => _family,
        _ => _solo,
      };

  static const _solo = HomeConfig(
    heroLabelKey: 'safe_to_spend',
    heroIcon: Icons.eco_rounded,
    budget: 2000,
    safeToSpend: 1280,
    greetingNames: 'Alex',
    pulseTitleKey: 'pulse_solo_title',
    pulseSubKey: 'pulse_solo_sub',
    tiles: [
      HomeTile('tile_income', '\$5,000', '+2%'),
      HomeTile('tile_spending', '\$3,120', '-8%'),
      HomeTile('tile_savings', '\$1,100', '22%'),
    ],
    actions: [
      HomeAction('action_transfer', Icons.swap_horiz_rounded),
      HomeAction('action_add_expense', Icons.add_circle_outline_rounded),
      HomeAction('action_set_goal', Icons.flag_rounded),
      HomeAction('action_ask_ai', Icons.auto_awesome_rounded),
    ],
    bills: [
      HomeBill('bill_rent', '\$1,500', 'due_in_days', '5', Icons.home_rounded, AppColors.housing),
      HomeBill('bill_phone_plan', '\$80', 'due_in_days', '8', Icons.smartphone_rounded, AppColors.info),
    ],
  );

  static const _dating = HomeConfig(
    heroLabelKey: 'safe_to_spend_shared',
    heroIcon: Icons.favorite_rounded,
    budget: 1200,
    safeToSpend: 620,
    greetingNames: 'Taylor & Jordan',
    pulseTitleKey: 'pulse_dating_title',
    pulseSubKey: 'pulse_dating_sub',
    tiles: [
      HomeTile('tile_joint_spending', '\$1,860', '+6%', deltaPositive: false),
      HomeTile('tile_your_share', '\$980', '52%'),
      HomeTile('tile_partner_share', '\$880', '48%'),
    ],
    actions: [
      HomeAction('action_split_bill', Icons.call_split_rounded),
      HomeAction('action_add_expense', Icons.add_circle_outline_rounded),
      HomeAction('action_set_date_goal', Icons.flag_rounded),
      HomeAction('action_ask_ai', Icons.auto_awesome_rounded),
    ],
    bills: [
      HomeBill('bill_dinner_reservation', '\$120', 'due_tomorrow', '', Icons.restaurant_rounded, AppColors.food),
      HomeBill('bill_streaming_shared', '\$28', 'due_in_days', '4', Icons.play_circle_rounded, AppColors.entertainment),
    ],
  );

  static const _livingTogether = HomeConfig(
    heroLabelKey: 'safe_to_spend_shared',
    heroIcon: Icons.home_rounded,
    budget: 2500,
    safeToSpend: 1420,
    greetingNames: 'Sam & Riley',
    pulseTitleKey: 'pulse_living_title',
    pulseSubKey: 'pulse_living_sub',
    tiles: [
      HomeTile('tile_income', '\$6,200', '+4%'),
      HomeTile('tile_expenses', '\$4,180', '-6%'),
      HomeTile('tile_shared_savings', '\$1,050', '17%'),
    ],
    actions: [
      HomeAction('action_split_expense', Icons.call_split_rounded),
      HomeAction('action_add_bill', Icons.add_circle_outline_rounded),
      HomeAction('action_set_shared_goal', Icons.flag_rounded),
      HomeAction('action_ask_ai', Icons.auto_awesome_rounded),
    ],
    bills: [
      HomeBill('bill_rent', '\$1,800', 'due_in_days', '5', Icons.home_rounded, AppColors.housing),
      HomeBill('bill_groceries', '\$300', 'due_in_days', '3', Icons.shopping_cart_rounded, AppColors.food),
    ],
  );

  static const _married = HomeConfig(
    heroLabelKey: 'safe_to_spend_joint',
    heroIcon: Icons.diamond_rounded,
    budget: 4000,
    safeToSpend: 2350,
    greetingNames: 'Chris & Morgan',
    pulseTitleKey: 'pulse_married_title',
    pulseSubKey: 'pulse_married_sub',
    tiles: [
      HomeTile('tile_income', '\$10,200', '+5%'),
      HomeTile('tile_expenses', '\$6,850', '-4%'),
      HomeTile('tile_net_worth', '\$124,000', '+2%'),
    ],
    actions: [
      HomeAction('action_add_goal', Icons.flag_rounded),
      HomeAction('action_pay_off_debt', Icons.credit_card_rounded),
      HomeAction('action_plan_big_purchase', Icons.savings_rounded),
      HomeAction('action_ask_ai', Icons.auto_awesome_rounded),
    ],
    bills: [
      HomeBill('bill_mortgage', '\$2,200', 'due_in_days', '6', Icons.home_rounded, AppColors.housing),
      HomeBill('bill_car_loan', '\$450', 'due_in_days', '9', Icons.directions_car_rounded, AppColors.transport),
    ],
  );

  static const _family = HomeConfig(
    heroLabelKey: 'safe_to_spend_household',
    heroIcon: Icons.family_restroom_rounded,
    budget: 3500,
    safeToSpend: 1890,
    greetingNames: 'Pat & Jamie',
    pulseTitleKey: 'pulse_family_title',
    pulseSubKey: 'pulse_family_sub',
    tiles: [
      HomeTile('tile_income', '\$8,500', '+3%'),
      HomeTile('tile_expenses', '\$6,120', '-5%', deltaPositive: false),
      HomeTile('tile_family_savings', '\$1,300', '15%'),
    ],
    actions: [
      HomeAction('action_add_child_expense', Icons.child_care_rounded),
      HomeAction('action_family_goal', Icons.flag_rounded),
      HomeAction('action_plan_education', Icons.school_rounded),
      HomeAction('action_ask_ai', Icons.auto_awesome_rounded),
    ],
    bills: [
      HomeBill('bill_childcare', '\$1,200', 'due_in_days', '4', Icons.child_care_rounded, AppColors.family),
      HomeBill('bill_school_tuition', '\$600', 'due_in_days', '10', Icons.school_rounded, AppColors.education),
    ],
  );
}
