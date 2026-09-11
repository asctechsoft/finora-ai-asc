class PlanGoal {
  final int? id;
  final int planId;
  final String goalKey;
  final double target;
  final double saved;

  /// Share of the plan's monthly budget, in percent.
  final int allocation;
  final DateTime? deadline;
  final String note;

  PlanGoal({
    this.id,
    required this.planId,
    required this.goalKey,
    this.target = 0,
    this.saved = 0,
    this.allocation = 0,
    this.deadline,
    this.note = '',
  });

  double get progress => target <= 0 ? 0 : (saved / target).clamp(0.0, 1.0);
  int get percent => (progress * 100).round();
  double get remaining => (target - saved).clamp(0, target);

  PlanGoal copyWith({double? target, double? saved, int? allocation, String? note}) => PlanGoal(
        id: id,
        planId: planId,
        goalKey: goalKey,
        target: target ?? this.target,
        saved: saved ?? this.saved,
        allocation: allocation ?? this.allocation,
        deadline: deadline,
        note: note ?? this.note,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'plan_id': planId,
        'goal_key': goalKey,
        'target': target,
        'saved': saved,
        'allocation': allocation,
        'deadline': deadline?.toIso8601String(),
        'note': note,
      };

  factory PlanGoal.fromMap(Map<String, dynamic> m) => PlanGoal(
        id: m['id'] as int?,
        planId: m['plan_id'] as int? ?? 0,
        goalKey: m['goal_key'] as String? ?? 'saving',
        target: (m['target'] as num?)?.toDouble() ?? 0,
        saved: (m['saved'] as num?)?.toDouble() ?? 0,
        allocation: m['allocation'] as int? ?? 0,
        deadline: (m['deadline'] as String?) != null
            ? DateTime.tryParse(m['deadline'] as String)
            : null,
        note: m['note'] as String? ?? '',
      );
}
