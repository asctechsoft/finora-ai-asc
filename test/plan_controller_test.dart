import 'package:flutter_test/flutter_test.dart';

import 'package:trackflow/controller/plan_controller.dart';
import 'package:trackflow/models/ui_models/plan_type.dart';

void main() {
  group('PlanController allocation', () {
    test('splits the budget to exactly 100% for any goal count', () {
      final c = PlanController();
      for (final keys in [
        ['saving'],
        ['daily', 'saving'],
        ['daily', 'education', 'saving', 'health', 'travel', 'emergency'],
      ]) {
        c.draftGoalKeys.value = keys;
        c.buildAllocation();
        expect(c.allocatedPercent, 100, reason: 'failed for $keys');
      }
    });

    test('derives monthly and total amounts from the plan period', () {
      final c = PlanController()
        ..draftType.value = PlanType.familyChild
        ..draftBudget.value = 25000000
        ..draftStart.value = DateTime(2025, 1, 1)
        ..draftEnd.value = DateTime(2025, 12, 31)
        ..draftGoalKeys.value = ['daily', 'saving'];
      c.buildAllocation();

      expect(c.draftMonths, 12);
      expect(c.monthlyAmountOf('daily'), 25000000 * c.allocationOf('daily') / 100);
      expect(c.targetAmountOf('daily'), c.monthlyAmountOf('daily') * 12);
    });

    test('dropping a goal also drops its allocation', () {
      final c = PlanController()..draftGoalKeys.value = ['daily', 'saving'];
      c.buildAllocation();
      c.toggleGoal('daily');

      expect(c.draftGoalKeys, ['saving']);
      expect(c.draftAllocation.containsKey('daily'), isFalse);
    });
  });
}
