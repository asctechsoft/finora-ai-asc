import 'package:dsp_base/comm_app.dart';
import 'package:dsp_base/app_localize.dart';
import 'package:dsp_base/convenience_imports.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'configs/pref_const.dart';
import 'controller/quick_add_controller.dart';
import 'controller/user_profile_controller.dart';
import 'values/app_pages.dart';
import 'values/app_theme.dart';
import 'values/route_name.dart';

/// Locales Finora ships translations for (lib/xml_strings/values + values-vi).
const List<Locale> kSupportedLocales = [Locale('en', 'US'), Locale('vi', 'VN')];

void _ensureLocaleConfigured() {
  final saved = PrefAssist.getString(PrefConst.language);
  if (saved.isNotEmpty) {
    final parts = saved.split('_');
    final locale = parts.length == 2 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
    final supported = kSupportedLocales.any((l) => l.languageCode == locale.languageCode);
    if (supported) {
      CommLocalize.setAppLocale(locale);
      return;
    }
  }
  final sys = CommLocalize.getSystemLocale();
  final match = kSupportedLocales.firstWhere(
    (l) => l.languageCode == (sys?.languageCode ?? 'en'),
    orElse: () => const Locale('en', 'US'),
  );
  CommLocalize.setAppLocale(match);
  final key = '${match.languageCode}_${match.countryCode}';
  PrefAssist.setString(PrefConst.language, key);
}

Future<void> main() async {
  await commRunApp(
    () => const FinoraApp(),
    onBindingInitialized: (widgetsBinding) async {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      try {
        await Firebase.initializeApp();
      } catch (e) {
        debugPrint('Firebase init failed: $e');
      }

      await initializeDateFormatting();

      // Load Finora's own translations (dsp_base only loads its package strings).
      await CommLocalize.loadTranslations('lib/xml_strings', 'strings.xml');
      _ensureLocaleConfigured();
    },
  );
}

class FinoraApp extends StatelessWidget {
  const FinoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CommApp(
      title: 'Finora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      locale: CommLocalize.getAppLocale(),
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: kSupportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: RouteName.splash,
      initialBinding: BindingsBuilder(() {
        Get.put(UserProfileController(), permanent: true);
        Get.put(QuickAddController(), permanent: true);
      }),
      getPages: AppPages.pages,
    );
  }
}
