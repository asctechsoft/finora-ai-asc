class DbSchema {
  DbSchema._();

  static const String dbName = 'finora.db';
  static const int dbVersion = 1;

  static const String tableTransactions = 'transactions';
  static const String tableBudgets = 'budgets';
  static const String tableBills = 'bills';
  static const String tableGoals = 'goals';
  static const String tableIncome = 'income_sources';
  static const String tableNotifications = 'notifications';
  static const String tableWallets = 'wallets';

  static const String createTransactions = '''
    CREATE TABLE $tableTransactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL DEFAULT 'expense',
      amount REAL NOT NULL,
      currency TEXT NOT NULL DEFAULT 'USD',
      category_key TEXT NOT NULL DEFAULT 'other',
      wallet TEXT NOT NULL DEFAULT 'Cash',
      merchant TEXT NOT NULL DEFAULT '',
      note TEXT NOT NULL DEFAULT '',
      date TEXT NOT NULL,
      date_key TEXT NOT NULL,
      payer TEXT NOT NULL DEFAULT 'Me',
      split_rule TEXT NOT NULL DEFAULT 'none',
      recurring TEXT NOT NULL DEFAULT 'off',
      source TEXT NOT NULL DEFAULT 'manual',
      confidence REAL NOT NULL DEFAULT 1.0,
      is_pending INTEGER NOT NULL DEFAULT 0
    )
  ''';

  static const String createTransactionsIndex =
      'CREATE INDEX idx_txn_date_key ON $tableTransactions (date_key)';

  static const String createBudgets = '''
    CREATE TABLE $tableBudgets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      category_key TEXT NOT NULL,
      period_key TEXT NOT NULL,
      amount REAL NOT NULL DEFAULT 0,
      UNIQUE(category_key, period_key)
    )
  ''';

  static const String createBills = '''
    CREATE TABLE $tableBills (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      amount REAL NOT NULL,
      currency TEXT NOT NULL DEFAULT 'USD',
      category_key TEXT NOT NULL DEFAULT 'bills',
      due_date TEXT NOT NULL,
      recurring TEXT NOT NULL DEFAULT 'monthly',
      is_paid INTEGER NOT NULL DEFAULT 0
    )
  ''';

  static const String createGoals = '''
    CREATE TABLE $tableGoals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      name TEXT NOT NULL,
      target REAL NOT NULL DEFAULT 0,
      saved REAL NOT NULL DEFAULT 0,
      deadline TEXT,
      priority INTEGER NOT NULL DEFAULT 0,
      enabled INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String createIncome = '''
    CREATE TABLE $tableIncome (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      amount REAL NOT NULL DEFAULT 0,
      currency TEXT NOT NULL DEFAULT 'USD',
      cadence TEXT NOT NULL DEFAULT 'Monthly',
      category_key TEXT NOT NULL DEFAULT 'salary'
    )
  ''';

  static const String createNotifications = '''
    CREATE TABLE $tableNotifications (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL DEFAULT 'insight',
      title TEXT NOT NULL,
      body TEXT NOT NULL DEFAULT '',
      timestamp TEXT NOT NULL,
      is_read INTEGER NOT NULL DEFAULT 0
    )
  ''';

  static const String createWallets = '''
    CREATE TABLE $tableWallets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      type TEXT NOT NULL DEFAULT 'cash',
      currency TEXT NOT NULL DEFAULT 'USD',
      balance REAL NOT NULL DEFAULT 0
    )
  ''';

  static const List<String> allCreates = [
    createTransactions,
    createTransactionsIndex,
    createBudgets,
    createBills,
    createGoals,
    createIncome,
    createNotifications,
    createWallets,
  ];
}
