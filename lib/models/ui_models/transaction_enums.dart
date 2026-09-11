import 'package:get/get.dart';

enum TxnType { expense, income, transfer }

extension TxnTypeX on TxnType {
  String get key => name;
  String get label => switch (this) {
    TxnType.expense => 'type_expense'.tr,
    TxnType.income => 'type_income'.tr,
    TxnType.transfer => 'type_transfer'.tr,
  };
  static TxnType fromKey(String? k) =>
      TxnType.values.firstWhere((e) => e.name == k, orElse: () => TxnType.expense);
}

enum SplitRule { none, equal, incomeRatio, fixed, percentage, custom }

extension SplitRuleX on SplitRule {
  String get key => name;
  String get label => switch (this) {
    SplitRule.none => 'split_none'.tr,
    SplitRule.equal => 'split_equal'.tr,
    SplitRule.incomeRatio => 'split_income_ratio'.tr,
    SplitRule.fixed => 'split_fixed'.tr,
    SplitRule.percentage => 'split_percentage'.tr,
    SplitRule.custom => 'split_custom'.tr,
  };
  static SplitRule fromKey(String? k) =>
      SplitRule.values.firstWhere((e) => e.name == k, orElse: () => SplitRule.none);
}

enum Recurring { off, weekly, monthly, custom }

extension RecurringX on Recurring {
  String get key => name;
  String get label => switch (this) {
    Recurring.off => 'One time',
    Recurring.weekly => 'Weekly',
    Recurring.monthly => 'Monthly',
    Recurring.custom => 'Custom',
  };
  static Recurring fromKey(String? k) =>
      Recurring.values.firstWhere((e) => e.name == k, orElse: () => Recurring.off);
}

enum TxnSource { manual, voice, receipt, transfer }

extension TxnSourceX on TxnSource {
  String get key => name;
  static TxnSource fromKey(String? k) =>
      TxnSource.values.firstWhere((e) => e.name == k, orElse: () => TxnSource.manual);
}

enum QuickAddMethod { voice, text, receipt, manual, transfer }
