import 'package:dsp_base/convenience_imports.dart';
import '../configs/pref_const.dart';
import '../models/data_models/app_notification.dart';
import '../models/data_models/bill.dart';
import '../models/data_models/goal_record.dart';
import '../models/data_models/transaction_record.dart';
import '../models/ui_models/transaction_enums.dart';
import '../repository/finance_repository.dart';
import '../utils/date_helper.dart';

/// Seeds demo transactions/budgets/bills/notifications on first run so the
/// dashboards render with realistic numbers matching the Figma flow.
class SeedService {
  final _repo = FinanceRepository();

  Future<void> ensureSeeded(String currency) async {
    if (PrefAssist.getBoolean(PrefConst.demoSeeded)) return;
    await _seedTransactions(currency);
    await _seedBudgets();
    await _seedBills(currency);
    await _seedGoals(currency);
    await _seedNotifications();
    PrefAssist.setBoolean(PrefConst.demoSeeded, true);
  }

  Future<void> _seedTransactions(String currency) async {
    final now = DateTime.now();
    final samples = <TransactionRecord>[
      TransactionRecord(amount: 23, categoryKey: 'food', merchant: 'Blue Bottle Coffee', wallet: 'Chase Checking', date: now, currency: currency),
      TransactionRecord(amount: 62, categoryKey: 'food', merchant: 'Whole Foods', wallet: 'Chase Checking', date: now.subtract(const Duration(hours: 5)), currency: currency),
      TransactionRecord(amount: 18, categoryKey: 'transport', merchant: 'Uber', wallet: 'Apple Pay', date: now.subtract(const Duration(days: 1)), currency: currency),
      TransactionRecord(amount: 120, categoryKey: 'shopping', merchant: 'Zara', wallet: 'Chase Checking', date: now.subtract(const Duration(days: 2)), currency: currency),
      TransactionRecord(amount: 45, categoryKey: 'entertainment', merchant: 'Cinema City', wallet: 'Cash', date: now.subtract(const Duration(days: 3)), currency: currency),
      TransactionRecord(type: TxnType.income, amount: 5000, categoryKey: 'salary', merchant: 'Acme Corp', wallet: 'Chase Checking', date: now.subtract(const Duration(days: 4)), currency: currency),
      TransactionRecord(amount: 210, categoryKey: 'housing', merchant: 'Electric Co', wallet: 'Chase Checking', date: now.subtract(const Duration(days: 5)), currency: currency),
    ];
    for (final t in samples) {
      await _repo.addTransaction(t);
    }
  }

  Future<void> _seedBudgets() async {
    final m = DateHelper.currentMonthKey();
    const plan = {
      'housing': 1500.0,
      'food': 600.0,
      'transport': 300.0,
      'shopping': 500.0,
      'entertainment': 300.0,
      'other': 300.0,
    };
    for (final e in plan.entries) {
      await _repo.setBudget(e.key, m, e.value);
    }
  }

  Future<void> _seedBills(String currency) async {
    final now = DateTime.now();
    await _repo.addBill(Bill(name: 'Rent', amount: 1500, categoryKey: 'housing', dueDate: now.add(const Duration(days: 5)), currency: currency));
    await _repo.addBill(Bill(name: 'Phone Plan', amount: 80, categoryKey: 'bills', dueDate: now.add(const Duration(days: 8)), currency: currency));
    await _repo.addBill(Bill(name: 'Electricity', amount: 120, categoryKey: 'bills', dueDate: now.add(const Duration(days: 12)), currency: currency));
    await _repo.addBill(Bill(name: 'Internet', amount: 60, categoryKey: 'bills', dueDate: now.add(const Duration(days: 18)), currency: currency));
  }

  Future<void> _seedGoals(String currency) async {
    await _repo.addGoal(GoalRecord(type: 'emergency', name: 'Emergency Fund', target: 10000, saved: 6200, priority: 0));
    await _repo.addGoal(GoalRecord(type: 'travel', name: 'Travel the World', target: 5000, saved: 1800, priority: 1));
    await _repo.addGoal(GoalRecord(type: 'wealth', name: 'Grow my Wealth', target: 20000, saved: 4300, priority: 2));
  }

  Future<void> _seedNotifications() async {
    final now = DateTime.now();
    final items = <AppNotification>[
      AppNotification(type: 'budget', title: 'Budget alert', body: "You've spent 80% of your Food & Dining budget.", timestamp: now.subtract(const Duration(hours: 1))),
      AppNotification(type: 'bill', title: 'Bill reminder', body: 'Your electricity bill of \$120 is due in 3 days.', timestamp: now.subtract(const Duration(hours: 2))),
      AppNotification(type: 'insight', title: 'AI insight', body: 'Your spending on coffee is 40% higher than last month.', timestamp: now.subtract(const Duration(hours: 3))),
      AppNotification(type: 'milestone', title: 'Savings milestone', body: "Great job! You've saved \$500 this month.", timestamp: now.subtract(const Duration(days: 1, hours: 2))),
      AppNotification(type: 'travel', title: 'Travel hint', body: 'Flight prices to Tokyo have dropped by 18%.', timestamp: now.subtract(const Duration(days: 1, hours: 6))),
      AppNotification(type: 'unusual', title: 'Unusual spending', body: 'We noticed a higher than usual spend at Apple (\$299).', timestamp: now.subtract(const Duration(days: 1, hours: 9))),
    ];
    for (final n in items) {
      await _repo.addNotification(n);
    }
  }
}
