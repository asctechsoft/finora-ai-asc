import '../models/data_models/app_notification.dart';
import '../models/data_models/bill.dart';
import '../models/data_models/goal_record.dart';
import '../models/data_models/income_source.dart';
import '../models/data_models/transaction_record.dart';
import '../models/ui_models/transaction_enums.dart';
import '../services/storage/database_helper.dart';
import '../services/storage/schema.dart';
import '../utils/date_helper.dart';

/// Single data-access point for all finance entities.
class FinanceRepository {
  final _db = DatabaseHelper.instance;

  // ---- Transactions ----
  Future<int> addTransaction(TransactionRecord t) =>
      _db.insert(DbSchema.tableTransactions, t.toMap());

  Future<void> deleteTransaction(int id) =>
      _db.delete(DbSchema.tableTransactions, where: 'id = ?', whereArgs: [id]);

  Future<List<TransactionRecord>> transactions({int? limit}) async {
    final rows = await _db.query(DbSchema.tableTransactions,
        orderBy: 'date DESC', limit: limit);
    return rows.map(TransactionRecord.fromMap).toList();
  }

  Future<List<TransactionRecord>> transactionsForMonth(String monthKey) async {
    final rows = await _db.query(DbSchema.tableTransactions,
        where: "substr(date_key,1,7) = ?", whereArgs: [monthKey], orderBy: 'date DESC');
    return rows.map(TransactionRecord.fromMap).toList();
  }

  Future<double> spentThisMonth() async {
    final txns = await transactionsForMonth(DateHelper.currentMonthKey());
    return txns
        .where((t) => t.type == TxnType.expense)
        .fold<double>(0, (s, t) => s + t.amount);
  }

  Future<double> spentForCategory(String categoryKey, String monthKey) async {
    final txns = await transactionsForMonth(monthKey);
    return txns
        .where((t) => t.type == TxnType.expense && t.categoryKey == categoryKey)
        .fold<double>(0, (s, t) => s + t.amount);
  }

  // ---- Income ----
  Future<int> addIncome(IncomeSource s) => _db.insert(DbSchema.tableIncome, s.toMap());
  Future<List<IncomeSource>> incomes() async {
    final rows = await _db.query(DbSchema.tableIncome);
    return rows.map(IncomeSource.fromMap).toList();
  }

  // ---- Bills ----
  Future<int> addBill(Bill b) => _db.insert(DbSchema.tableBills, b.toMap());
  Future<List<Bill>> bills() async {
    final rows = await _db.query(DbSchema.tableBills, orderBy: 'due_date ASC');
    return rows.map(Bill.fromMap).toList();
  }

  // ---- Goals ----
  Future<int> addGoal(GoalRecord g) => _db.insert(DbSchema.tableGoals, g.toMap());
  Future<List<GoalRecord>> goals() async {
    final rows = await _db.query(DbSchema.tableGoals, orderBy: 'priority ASC');
    return rows.map(GoalRecord.fromMap).toList();
  }

  // ---- Budgets ----
  Future<void> setBudget(String categoryKey, String periodKey, double amount) =>
      _db.insert(DbSchema.tableBudgets, {
        'category_key': categoryKey,
        'period_key': periodKey,
        'amount': amount,
      });

  Future<Map<String, double>> budgetsForMonth(String monthKey) async {
    final rows = await _db.query(DbSchema.tableBudgets,
        where: 'period_key = ?', whereArgs: [monthKey]);
    return {for (final r in rows) r['category_key'] as String: (r['amount'] as num).toDouble()};
  }

  // ---- Notifications ----
  Future<int> addNotification(AppNotification n) =>
      _db.insert(DbSchema.tableNotifications, n.toMap());
  Future<List<AppNotification>> notifications() async {
    final rows = await _db.query(DbSchema.tableNotifications, orderBy: 'timestamp DESC');
    return rows.map(AppNotification.fromMap).toList();
  }
}
