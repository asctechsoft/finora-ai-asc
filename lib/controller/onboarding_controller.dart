import 'package:dsp_base/app_localize.dart';
import 'package:dsp_base/convenience_imports.dart';
import 'package:get/get.dart';
import '../configs/pref_const.dart';
import '../models/data_models/income_source.dart';
import '../models/ui_models/app_language.dart';
import '../models/ui_models/life_mode.dart';
import '../repository/finance_repository.dart';
import 'user_profile_controller.dart';

/// Collects onboarding selections across steps, persists at completion.
class OnboardingController extends GetxController {
  final _repo = FinanceRepository();

  final country = 'US'.obs;

  /// Seeded from the locale already resolved at startup, so the picker opens
  /// on the language the user is actually reading.
  final language =
      PrefAssist.getString(PrefConst.language, defaultValue: AppLanguage.english.code).obs;
  final currency = 'USD'.obs;
  final lifeMode = LifeMode.solo.obs;

  /// Free-text description shown only when [lifeMode] is [LifeMode.custom].
  final customLifeModeNote = ''.obs;

  // Income step — starts empty; the user adds their own sources.
  final incomes = <IncomeSource>[].obs;

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

  /// Applies the pick immediately so the rest of onboarding is translated.
  void setLanguage(AppLanguage lang) {
    language.value = lang.code;
    CommLocalize.setAppLocale(lang.locale);
    Get.updateLocale(lang.locale);
  }

  void toggleGoal(String key) => goals[key] = !(goals[key] ?? false);

  void addIncome() => incomes.add(
        IncomeSource(
            name: 'income_new_source'.tr, amount: 0, cadence: 'Monthly', categoryKey: 'other_income'),
      );

  void updateIncome(int index, {required String name, required double amount}) {
    if (index < 0 || index >= incomes.length) return;
    incomes[index] = incomes[index].copyWith(name: name, amount: amount);
  }

  void removeIncome(int index) {
    if (index < 0 || index >= incomes.length) return;
    incomes.removeAt(index);
  }

  Future<void> complete() async {
    PrefAssist.setString(PrefConst.country, country.value);
    PrefAssist.setString(PrefConst.language, language.value);
    PrefAssist.setString(PrefConst.baseCurrency, currency.value);
    PrefAssist.setString(PrefConst.lifeMode, lifeMode.value.key);
    PrefAssist.setString(PrefConst.customLifeModeNote,
        lifeMode.value == LifeMode.custom ? customLifeModeNote.value.trim() : '');
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
