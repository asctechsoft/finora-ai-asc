import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/onboarding_controller.dart';
import '../presentation/screen_placeholder/placeholder_tab.dart';
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
import '../presentation/screen_plan/goal_detail_screen.dart';
import '../presentation/screen_plan/plan_basic_info_screen.dart';
import '../presentation/screen_plan/plan_budget_screen.dart';
import '../presentation/screen_plan/plan_goal_select_screen.dart';
import '../presentation/screen_plan/plan_goal_suggest_screen.dart';
import '../presentation/screen_plan/plan_review_screen.dart';
import '../presentation/screen_plan/plan_success_screen.dart';
import '../presentation/screen_plan/plan_type_screen.dart';
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
    GetPage(
      name: RouteName.aiCopilot,
      page: () => PlaceholderTab(
        title: 'tab_ai_copilot'.tr,
        icon: Icons.auto_awesome_rounded,
        message: 'placeholder_ai'.tr,
      ),
    ),

    // Plan creation flow
    GetPage(name: RouteName.planType, page: () => const PlanTypeScreen()),
    GetPage(name: RouteName.planGoalSuggest, page: () => const PlanGoalSuggestScreen()),
    GetPage(name: RouteName.planBasicInfo, page: () => const PlanBasicInfoScreen()),
    GetPage(name: RouteName.planGoalSelect, page: () => const PlanGoalSelectScreen()),
    GetPage(name: RouteName.planBudget, page: () => const PlanBudgetScreen()),
    GetPage(name: RouteName.planReview, page: () => const PlanReviewScreen()),
    GetPage(name: RouteName.planSuccess, page: () => const PlanSuccessScreen()),
    GetPage(name: RouteName.goalDetail, page: () => const GoalDetailScreen()),

    // Plan / detail
    GetPage(name: RouteName.budgetList, page: () => const BudgetListScreen()),
    GetPage(name: RouteName.budgetDetail, page: () => const BudgetDetailScreen()),
    GetPage(name: RouteName.calendar, page: () => const CalendarScreen()),
    GetPage(name: RouteName.notifications, page: () => const NotificationsScreen()),
    GetPage(name: RouteName.transactions, page: () => const TransactionsScreen()),
  ];
}
