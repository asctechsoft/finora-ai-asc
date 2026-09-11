import 'package:dsp_base/convenience_imports.dart';
import 'package:get/get.dart';
import '../configs/pref_const.dart';
import '../models/data_models/income_source.dart';
import '../models/ui_models/life_mode.dart';
import '../repository/finance_repository.dart';
import 'user_profile_controller.dart';

/// Collects onboarding selections across steps, persists at completion.
class OnboardingController extends GetxController {
  final _repo = FinanceRepository();

  final country = 'US'.obs;
  final language = 'en_US'.obs;
  final currency = 'USD'.obs;
  final lifeMode = LifeMode.solo.obs;

  // Income step
  final incomes = <IncomeSource>[
    IncomeSource(name: 'Salary', amount: 5000, cadence: 'Monthly', categoryKey: 'salary'),
    IncomeSource(name: 'Freelance', amount: 800, cadence: 'Variable', categoryKey: 'freelance'),
    IncomeSource(name: 'Investments', amount: 300, cadence: 'Monthly (avg)', categoryKey: 'investment'),
  ].obs;

  double get totalMonthlyIncome =>
      incomes.fold(0.0, (s, e) => s + e.amount);

  // Goals step — key -> enabled
  final goals = <String, bool>{
    'emergency': true,
    'home': false,
    'travel': true,
    'wealth': true,
    'debt': false,
    'retire': false,
    'other': false,
  }.obs;

  void toggleGoal(String key) => goals[key] = !(goals[key] ?? false);

  void addIncome() => incomes.add(
        IncomeSource(name: 'New source', amount: 0, cadence: 'Monthly', categoryKey: 'other_income'),
      );

  Future<void> complete() async {
    PrefAssist.setString(PrefConst.country, country.value);
    PrefAssist.setString(PrefConst.language, language.value);
    PrefAssist.setString(PrefConst.baseCurrency, currency.value);
    PrefAssist.setString(PrefConst.lifeMode, lifeMode.value.key);
    PrefAssist.setBoolean(PrefConst.onboardingCompleted, true);

    for (final inc in incomes) {
      await _repo.addIncome(IncomeSource(
        name: inc.name,
        amount: inc.amount,
        currency: currency.value,
        cadence: inc.cadence,
        categoryKey: inc.categoryKey,
      ));
    }

    if (Get.isRegistered<UserProfileController>()) {
      Get.find<UserProfileController>().load();
    }
  }
}
