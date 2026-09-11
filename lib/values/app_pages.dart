import 'package:get/get.dart';
import '../controller/onboarding_controller.dart';
import '../presentation/screen_splash/splash_screen.dart';
import '../presentation/screens_onboarding/welcome_screen.dart';
import '../presentation/screens_onboarding/locale_screen.dart';
import '../presentation/screens_onboarding/currency_screen.dart';
import '../presentation/screens_onboarding/life_mode_screen.dart';
import '../presentation/screens_onboarding/income_screen.dart';
import '../presentation/screens_onboarding/goals_screen.dart';
import '../presentation/screen_home/main_shell.dart';
import '../presentation/screens_quick_add/voice_permission_screen.dart';
import '../presentation/screens_quick_add/voice_listening_screen.dart';
import '../presentation/screens_quick_add/parsed_review_screen.dart';
import '../presentation/screens_quick_add/add_success_screen.dart';
import '../presentation/screens_quick_add/manual_transaction_screen.dart';
import '../presentation/screen_budget/budget_list_screen.dart';
import '../presentation/screen_budget/budget_detail_screen.dart';
import '../presentation/screen_calendar/calendar_screen.dart';
import '../presentation/screen_notifications/notifications_screen.dart';
import '../presentation/screen_transactions/transactions_screen.dart';
import 'route_name.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(name: RouteName.splash, page: () => const SplashScreen()),

    // Onboarding — OnboardingController lives across the whole flow.
    GetPage(
      name: RouteName.welcome,
      page: () => const WelcomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(OnboardingController(), permanent: true);
      }),
    ),
    GetPage(name: RouteName.locale, page: () => const LocaleScreen()),
    GetPage(name: RouteName.currency, page: () => const CurrencyScreen()),
    GetPage(name: RouteName.lifeMode, page: () => const LifeModeScreen()),
    GetPage(name: RouteName.income, page: () => const IncomeScreen()),
    GetPage(name: RouteName.goals, page: () => const GoalsScreen()),

    // Main shell
    GetPage(
      name: RouteName.home,
      page: () => const MainShell(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350),
    ),

    // Quick Add flow
    GetPage(name: RouteName.voicePermission, page: () => const VoicePermissionScreen()),
    GetPage(name: RouteName.voiceListening, page: () => const VoiceListeningScreen()),
    GetPage(name: RouteName.parsedReview, page: () => const ParsedReviewScreen()),
    GetPage(name: RouteName.addSuccess, page: () => const AddSuccessScreen()),
    GetPage(name: RouteName.manualTransaction, page: () => const ManualTransactionScreen()),

    // Plan / detail
    GetPage(name: RouteName.budgetList, page: () => const BudgetListScreen()),
    GetPage(name: RouteName.budgetDetail, page: () => const BudgetDetailScreen()),
    GetPage(name: RouteName.calendar, page: () => const CalendarScreen()),
    GetPage(name: RouteName.notifications, page: () => const NotificationsScreen()),
    GetPage(name: RouteName.transactions, page: () => const TransactionsScreen()),
  ];
}
