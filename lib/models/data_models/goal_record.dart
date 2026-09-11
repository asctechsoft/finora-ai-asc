class GoalRecord {
  final int? id;
  final String type;
  final String name;
  final double target;
  final double saved;
  final DateTime? deadline;
  final int priority;
  final bool enabled;

  GoalRecord({
    this.id,
    required this.type,
    required this.name,
    this.target = 0,
    this.saved = 0,
    this.deadline,
    this.priority = 0,
    this.enabled = true,
  });

  double get progress => target <= 0 ? 0 : (saved / target).clamp(0.0, 1.0);

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'type': type,
        'name': name,
        'target': target,
        'saved': saved,
        'deadline': deadline?.toIso8601String(),
        'priority': priority,
        'enabled': enabled ? 1 : 0,
      };

  factory GoalRecord.fromMap(Map<String, dynamic> m) => GoalRecord(
        id: m['id'] as int?,
        type: m['type'] as String? ?? 'custom',
        name: m['name'] as String? ?? '',
        target: (m['target'] as num?)?.toDouble() ?? 0,
        saved: (m['saved'] as num?)?.toDouble() ?? 0,
        deadline: (m['deadline'] as String?) != null
            ? DateTime.tryParse(m['deadline'] as String)
            : null,
        priority: m['priority'] as int? ?? 0,
        enabled: (m['enabled'] as int? ?? 1) == 1,
      );
}
