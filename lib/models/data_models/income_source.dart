class IncomeSource {
  final int? id;
  final String name;
  final double amount;
  final String currency;
  final String cadence;
  final String categoryKey;

  IncomeSource({
    this.id,
    required this.name,
    required this.amount,
    this.currency = 'USD',
    this.cadence = 'Monthly',
    this.categoryKey = 'salary',
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'amount': amount,
        'currency': currency,
        'cadence': cadence,
        'category_key': categoryKey,
      };

  factory IncomeSource.fromMap(Map<String, dynamic> m) => IncomeSource(
        id: m['id'] as int?,
        name: m['name'] as String? ?? '',
        amount: (m['amount'] as num?)?.toDouble() ?? 0,
        currency: m['currency'] as String? ?? 'USD',
        cadence: m['cadence'] as String? ?? 'Monthly',
        categoryKey: m['category_key'] as String? ?? 'salary',
      );

  IncomeSource copyWith({String? name, double? amount, String? cadence, String? categoryKey}) =>
      IncomeSource(
        id: id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        currency: currency,
        cadence: cadence ?? this.cadence,
        categoryKey: categoryKey ?? this.categoryKey,
      );
}
