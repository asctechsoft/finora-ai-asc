class Plan {
  final int? id;
  final String name;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final double monthlyBudget;
  final String description;
  final DateTime createdAt;

  Plan({
    this.id,
    required this.name,
    required this.type,
    required this.startDate,
    required this.endDate,
    this.monthlyBudget = 0,
    this.description = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Plan copyWith({
    int? id,
    String? name,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    double? monthlyBudget,
    String? description,
  }) =>
      Plan(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        monthlyBudget: monthlyBudget ?? this.monthlyBudget,
        description: description ?? this.description,
        createdAt: createdAt,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'type': type,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'monthly_budget': monthlyBudget,
        'description': description,
        'created_at': createdAt.toIso8601String(),
      };

  factory Plan.fromMap(Map<String, dynamic> m) => Plan(
        id: m['id'] as int?,
        name: m['name'] as String? ?? '',
        type: m['type'] as String? ?? 'personal',
        startDate: DateTime.tryParse(m['start_date'] as String? ?? '') ?? DateTime.now(),
        endDate: DateTime.tryParse(m['end_date'] as String? ?? '') ?? DateTime.now(),
        monthlyBudget: (m['monthly_budget'] as num?)?.toDouble() ?? 0,
        description: m['description'] as String? ?? '',
        createdAt: DateTime.tryParse(m['created_at'] as String? ?? ''),
      );
}
