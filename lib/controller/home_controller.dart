import 'package:get/get.dart';
import '../models/data_models/bill.dart';
import '../models/data_models/goal_record.dart';
import '../models/data_models/transaction_record.dart';
import '../repository/finance_repository.dart';
import '../utils/life_mode_config.dart';
import 'user_profile_controller.dart';

class HomeController extends GetxController {
  final _repo = FinanceRepository();
  final profile = Get.find<UserProfileController>();

  final recentTxns = <TransactionRecord>[].obs;
  final upcomingBills = <Bill>[].obs;
  final goals = <GoalRecord>[].obs;
  final spentThisMonth = 0.0.obs;
  final loading = true.obs;

  HomeConfig get config => HomeConfig.of(profile.lifeMode.value);

  /// Safe-to-Spend = budget − real spending this month (so Quick Add moves it).
  double get safeToSpend => (config.budget - spentThisMonth.value).clamp(0, config.budget);

  @override
  void onInit() {
    super.onInit();
    refreshData();
    // Recompute when the user switches life mode from the header chip.
    ever(profile.lifeMode, (_) => update());
  }

  Future<void> refreshData() async {
    loading.value = true;
    recentTxns.value = await _repo.transactions(limit: 6);
    upcomingBills.value = (await _repo.bills()).where((b) => !b.isPaid).take(2).toList();
    goals.value = await _repo.goals();
    spentThisMonth.value = await _repo.spentThisMonth();
    loading.value = false;
  }
}
