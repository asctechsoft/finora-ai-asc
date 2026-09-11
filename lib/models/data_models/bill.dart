class Bill {
  final int? id;
  final String name;
  final double amount;
  final String currency;
  final String categoryKey;
  final DateTime dueDate;
  final String recurring;
  final bool isPaid;

  Bill({
    this.id,
    required this.name,
    required this.amount,
    this.currency = 'USD',
    this.categoryKey = 'bills',
    required this.dueDate,
    this.recurring = 'monthly',
    this.isPaid = false,
  });

  int get daysUntilDue {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.difference(today).inDays;
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'amount': amount,
        'currency': currency,
        'category_key': categoryKey,
        'due_date': dueDate.toIso8601String(),
        'recurring': recurring,
        'is_paid': isPaid ? 1 : 0,
      };

  factory Bill.fromMap(Map<String, dynamic> m) => Bill(
        id: m['id'] as int?,
        name: m['name'] as String? ?? '',
        amount: (m['amount'] as num).toDouble(),
        currency: m['currency'] as String? ?? 'USD',
        categoryKey: m['category_key'] as String? ?? 'bills',
        dueDate: DateTime.tryParse(m['due_date'] as String? ?? '') ?? DateTime.now(),
        recurring: m['recurring'] as String? ?? 'monthly',
        isPaid: (m['is_paid'] as int? ?? 0) == 1,
      );
}
