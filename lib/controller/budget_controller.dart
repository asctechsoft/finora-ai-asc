import 'package:get/get.dart';
import '../models/ui_models/category_catalog.dart';
import '../repository/finance_repository.dart';
import '../utils/date_helper.dart';

class BudgetLine {
  final String categoryKey;
  final String label;
  final double budget;
  final double spent;
  BudgetLine(this.categoryKey, this.label, this.budget, this.spent);
  double get progress => budget <= 0 ? 0 : (spent / budget).clamp(0.0, 1.0);
  int get percent => (progress * 100).round();
}

class BudgetController extends GetxController {
  final _repo = FinanceRepository();

  final lines = <BudgetLine>[].obs;
  final totalBudget = 0.0.obs;
  final totalSpent = 0.0.obs;
  final loading = true.obs;

  String get monthKey => DateHelper.currentMonthKey();
  double get remaining => (totalBudget.value - totalSpent.value).clamp(0, totalBudget.value);
  int get percentUsed =>
      totalBudget.value <= 0 ? 0 : ((totalSpent.value / totalBudget.value) * 100).round();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    final budgets = await _repo.budgetsForMonth(monthKey);
    final result = <BudgetLine>[];
    double tb = 0, ts = 0;
    for (final entry in budgets.entries) {
      final spent = await _repo.spentForCategory(entry.key, monthKey);
      final meta = CategoryCatalog.meta(entry.key);
      result.add(BudgetLine(entry.key, meta.label, entry.value, spent));
      tb += entry.value;
      ts += spent;
    }
    result.sort((a, b) => b.spent.compareTo(a.spent));
    lines.value = result;
    totalBudget.value = tb;
    totalSpent.value = ts;
    loading.value = false;
  }
}
