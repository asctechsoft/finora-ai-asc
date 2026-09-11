import '../ui_models/transaction_enums.dart';

class TransactionRecord {
  final int? id;
  final TxnType type;
  final double amount;
  final String currency;
  final String categoryKey;
  final String wallet;
  final String merchant;
  final String note;
  final DateTime date;
  final String payer;
  final SplitRule splitRule;
  final Recurring recurring;
  final TxnSource source;
  final double confidence;
  final bool isPending;

  TransactionRecord({
    this.id,
    this.type = TxnType.expense,
    required this.amount,
    this.currency = 'USD',
    this.categoryKey = 'other',
    this.wallet = 'Cash',
    this.merchant = '',
    this.note = '',
    required this.date,
    this.payer = 'Me',
    this.splitRule = SplitRule.none,
    this.recurring = Recurring.off,
    this.source = TxnSource.manual,
    this.confidence = 1.0,
    this.isPending = false,
  });

  String get dateKey =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  /// Signed amount: expenses negative, income positive, transfers 0 for totals.
  double get signed => switch (type) {
        TxnType.expense => -amount,
        TxnType.income => amount,
        TxnType.transfer => 0,
      };

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'type': type.key,
        'amount': amount,
        'currency': currency,
        'category_key': categoryKey,
        'wallet': wallet,
        'merchant': merchant,
        'note': note,
        'date': date.toIso8601String(),
        'date_key': dateKey,
        'payer': payer,
        'split_rule': splitRule.key,
        'recurring': recurring.key,
        'source': source.key,
        'confidence': confidence,
        'is_pending': isPending ? 1 : 0,
      };

  factory TransactionRecord.fromMap(Map<String, dynamic> m) => TransactionRecord(
        id: m['id'] as int?,
        type: TxnTypeX.fromKey(m['type'] as String?),
        amount: (m['amount'] as num).toDouble(),
        currency: m['currency'] as String? ?? 'USD',
        categoryKey: m['category_key'] as String? ?? 'other',
        wallet: m['wallet'] as String? ?? 'Cash',
        merchant: m['merchant'] as String? ?? '',
        note: m['note'] as String? ?? '',
        date: DateTime.tryParse(m['date'] as String? ?? '') ?? DateTime.now(),
        payer: m['payer'] as String? ?? 'Me',
        splitRule: SplitRuleX.fromKey(m['split_rule'] as String?),
        recurring: RecurringX.fromKey(m['recurring'] as String?),
        source: TxnSourceX.fromKey(m['source'] as String?),
        confidence: (m['confidence'] as num?)?.toDouble() ?? 1.0,
        isPending: (m['is_pending'] as int? ?? 0) == 1,
      );

  TransactionRecord copyWith({
    int? id,
    TxnType? type,
    double? amount,
    String? currency,
    String? categoryKey,
    String? wallet,
    String? merchant,
    String? note,
    DateTime? date,
    String? payer,
    SplitRule? splitRule,
    Recurring? recurring,
    TxnSource? source,
    double? confidence,
    bool? isPending,
  }) =>
      TransactionRecord(
        id: id ?? this.id,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        categoryKey: categoryKey ?? this.categoryKey,
        wallet: wallet ?? this.wallet,
        merchant: merchant ?? this.merchant,
        note: note ?? this.note,
        date: date ?? this.date,
        payer: payer ?? this.payer,
        splitRule: splitRule ?? this.splitRule,
        recurring: recurring ?? this.recurring,
        source: source ?? this.source,
        confidence: confidence ?? this.confidence,
        isPending: isPending ?? this.isPending,
      );
}
