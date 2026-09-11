import 'package:get/get.dart';
import '../models/data_models/plan.dart';
import '../models/data_models/plan_goal.dart';
import '../models/ui_models/goal_catalog.dart';
import '../models/ui_models/plan_type.dart';
import '../repository/finance_repository.dart';

/// Owns the saved plans plus the draft state of the 3-step creation wizard.
class PlanController extends GetxController {
  final _repo = FinanceRepository();

  final plans = <Plan>[].obs;
  final goals = <PlanGoal>[].obs;
  final activePlanId = Rxn<int>();
  final loading = true.obs;

  // ---- Draft (creation wizard) ----
  final draftType = Rxn<PlanType>();
  final draftName = ''.obs;
  final draftStart = Rxn<DateTime>();
  final draftEnd = Rxn<DateTime>();
  final draftBudget = 0.0.obs;
  final draftDescription = ''.obs;
  final draftGoalKeys = <String>[].obs;
  final draftAllocation = <String, int>{}.obs;

  Plan? get activePlan {
    if (plans.isEmpty) return null;
    return plans.firstWhereOrNull((p) => p.id == activePlanId.value) ?? plans.first;
  }

  bool get hasPlan => plans.isNotEmpty;

  double get totalTarget => goals.fold(0.0, (s, g) => s + g.target);
  double get totalSaved => goals.fold(0.0, (s, g) => s + g.saved);
  double get totalRemaining => (totalTarget - totalSaved).clamp(0, totalTarget);
  double get overallProgress => totalTarget <= 0 ? 0 : (totalSaved / totalTarget).clamp(0.0, 1.0);
  int get overallPercent => (overallProgress * 100).round();

  /// Whole months covered by the draft period, at least 1.
  int get draftMonths {
    final start = draftStart.value;
    final end = draftEnd.value;
    if (start == null || end == null) return 1;
    final months = (end.year - start.year) * 12 + (end.month - start.month) + 1;
    return months < 1 ? 1 : months;
  }

  int allocationOf(String key) => draftAllocation[key] ?? 0;

  double monthlyAmountOf(String key) => draftBudget.value * allocationOf(key) / 100;

  double targetAmountOf(String key) => monthlyAmountOf(key) * draftMonths;

  int get allocatedPercent =>
      draftAllocation.entries.fold(0, (s, e) => s + (draftGoalKeys.contains(e.key) ? e.value : 0));

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    plans.value = await _repo.plans();
    activePlanId.value ??= plans.isEmpty ? null : plans.first.id;
    await loadGoals();
    loading.value = false;
  }

  Future<void> loadGoals() async {
    final id = activePlan?.id;
    goals.value = id == null ? <PlanGoal>[] : await _repo.planGoals(id);
  }

  Future<void> selectPlan(int planId) async {
    activePlanId.value = planId;
    await loadGoals();
  }

  // ---- Wizard ----
  void startDraft() {
    final now = DateTime.now();
    draftType.value = null;
    draftName.value = '';
    draftStart.value = DateTime(now.year, now.month, 1);
    draftEnd.value = DateTime(now.year, 12, 31);
    draftBudget.value = 0;
    draftDescription.value = '';
    draftGoalKeys.clear();
    draftAllocation.clear();
  }

  void pickType(PlanType type) => draftType.value = type;

  void toggleGoal(String key) {
    if (draftGoalKeys.contains(key)) {
      draftGoalKeys.remove(key);
      draftAllocation.remove(key);
    } else {
      draftGoalKeys.add(key);
    }
  }

  bool isGoalSelected(String key) => draftGoalKeys.contains(key);

  /// Seeds each selected goal with its catalog weight, then scales the set to 100%.
  void buildAllocation() {
    if (draftGoalKeys.isEmpty) {
      draftAllocation.clear();
      return;
    }
    final weights = {
      for (final key in draftGoalKeys) key: GoalCatalog.meta(key).weight,
    };
    final total = weights.values.fold(0, (s, w) => s + w);
    final scaled = <String, int>{};
    var running = 0;
    for (var i = 0; i < draftGoalKeys.length; i++) {
      final key = draftGoalKeys[i];
      if (i == draftGoalKeys.length - 1) {
        scaled[key] = 100 - running;
      } else {
        final pct = total <= 0 ? 0 : ((weights[key]! / total) * 100).round();
        scaled[key] = pct;
        running += pct;
      }
    }
    draftAllocation.value = scaled;
  }

  void setAllocation(String key, int percent) =>
      draftAllocation[key] = percent.clamp(0, 100);

  Future<void> saveDraft() async {
    final type = draftType.value ?? PlanType.personal;
    final start = draftStart.value ?? DateTime.now();
    final end = draftEnd.value ?? DateTime.now();
    final plan = Plan(
      name: draftName.value.trim(),
      type: type.key,
      startDate: start,
      endDate: end,
      monthlyBudget: draftBudget.value,
      description: draftDescription.value.trim(),
    );
    final planId = await _repo.addPlan(plan);
    for (final key in draftGoalKeys) {
      await _repo.addPlanGoal(PlanGoal(
        planId: planId,
        goalKey: key,
        target: targetAmountOf(key),
        allocation: allocationOf(key),
        deadline: end,
      ));
    }
    activePlanId.value = planId;
    await load();
  }

  Future<void> depositToGoal(PlanGoal goal, double amount) async {
    if (goal.id == null || amount <= 0) return;
    await _repo.updatePlanGoalSaved(goal.id!, goal.saved + amount);
    await loadGoals();
  }

  PlanGoal? goalById(int id) => goals.firstWhereOrNull((g) => g.id == id);

  /// Monthly contribution derived from the goal's share of the plan budget.
  double monthlySavingFor(PlanGoal goal) {
    final budget = activePlan?.monthlyBudget ?? 0;
    return budget * goal.allocation / 100;
  }
}
