import 'package:dsp_base/convenience_imports.dart';
import 'package:get/get.dart';
import '../configs/pref_const.dart';
import '../configs/pref_defaults.dart';
import '../models/ui_models/life_mode.dart';

/// Permanent controller holding the user's profile prefs (reactive).
class UserProfileController extends GetxController {
  final name = PrefDefaults.userName.obs;
  final country = PrefDefaults.country.obs;
  final baseCurrency = PrefDefaults.baseCurrency.obs;
  final language = PrefDefaults.language.obs;
  final managementStyle = PrefDefaults.managementStyle.obs;
  final lifeMode = LifeMode.solo.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() {
    name.value = PrefAssist.getString(PrefConst.userName, defaultValue: PrefDefaults.userName);
    country.value = PrefAssist.getString(PrefConst.country, defaultValue: PrefDefaults.country);
    baseCurrency.value =
        PrefAssist.getString(PrefConst.baseCurrency, defaultValue: PrefDefaults.baseCurrency);
    language.value = PrefAssist.getString(PrefConst.language, defaultValue: PrefDefaults.language);
    managementStyle.value =
        PrefAssist.getString(PrefConst.managementStyle, defaultValue: PrefDefaults.managementStyle);
    lifeMode.value =
        LifeModeX.fromKey(PrefAssist.getString(PrefConst.lifeMode, defaultValue: PrefDefaults.lifeMode));
  }

  bool get onboarded => PrefAssist.getBoolean(PrefConst.onboardingCompleted);

  void setLifeMode(LifeMode mode) {
    lifeMode.value = mode;
    PrefAssist.setString(PrefConst.lifeMode, mode.key);
  }
}
