import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/plan_controller.dart';
import '../../models/ui_models/goal_catalog.dart';
import '../../models/ui_models/plan_type.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';
import '../common_components/primary_button.dart';

/// Step 2/3 — pick the goals the plan will track, grouped common / type-specific.
class PlanGoalSelectScreen extends StatefulWidget {
  const PlanGoalSelectScreen({super.key});

  @override
  State<PlanGoalSelectScreen> createState() => _PlanGoalSelectScreenState();
}

class _PlanGoalSelectScreenState extends State<PlanGoalSelectScreen> {
  final _c = Get.find<PlanController>();
  int _filter = 0; // 0 = all, 1 = selected, 2 = suggested

  @override
  Widget build(BuildContext context) {
    final type = _c.draftType.value ?? PlanType.personal;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text('plan_pick_goals'.tr,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.heading)),
            Text('plan_step'.trArgs(['2']),
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
      body: Obx(() {
        final common = _visible(GoalCatalog.common, type);
        final specific = _visible(GoalCatalog.specific(type), type);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                children: [
                  _Chip(
                    label: 'plan_filter_all'.tr,
                    selected: _filter == 0,
                    onTap: () => setState(() => _filter = 0),
                  ),
                  const SizedBox(width: 8),
                  _Chip(
                    label: 'plan_filter_selected'.trArgs(['${_c.draftGoalKeys.length}']),
                    selected: _filter == 1,
                    onTap: () => setState(() => _filter = 1),
                  ),
                  const SizedBox(width: 8),
                  _Chip(
                    label: 'plan_filter_suggested'.tr,
                    selected: _filter == 2,
                    onTap: () => setState(() => _filter = 2),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                children: [
                  if (common.isNotEmpty) ...[
                    _GroupLabel('plan_group_common'.tr),
                    ...common.map(_row),
                    const SizedBox(height: 18),
                  ],
                  if (specific.isNotEmpty) ...[
                    _GroupLabel('plan_group_specific'.trArgs([type.title])),
                    ...specific.map(_row),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: PrimaryButton(
                label: 'continue_'.tr,
                trailingIcon: null,
                enabled: _c.draftGoalKeys.isNotEmpty,
                onPressed: () {
                  _c.buildAllocation();
                  Get.toNamed(RouteName.planBudget);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  List<GoalMeta> _visible(List<GoalMeta> source, PlanType type) {
    return switch (_filter) {
      1 => source.where((g) => _c.isGoalSelected(g.key)).toList(),
      2 => source.where((g) => GoalCatalog.suggestions(type).any((s) => s.key == g.key)).toList(),
      _ => source,
    };
  }

  Widget _row(GoalMeta meta) => _GoalCheckRow(
        meta: meta,
        selected: _c.isGoalSelected(meta.key),
        onTap: () => _c.toggleGoal(meta.key),
      );
}

class _GroupLabel extends StatelessWidget {
  final String text;
  const _GroupLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.heading)),
      );
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textSecondary,
            )),
      ),
    );
  }
}

class _GoalCheckRow extends StatelessWidget {
  final GoalMeta meta;
  final bool selected;
  final VoidCallback onTap;
  const _GoalCheckRow({required this.meta, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: meta.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(meta.icon, color: meta.color, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(meta.label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.heading, fontSize: 14)),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: selected ? AppColors.primary : AppColors.textTertiary, width: 2),
                color: selected ? AppColors.primary : Colors.transparent,
              ),
              child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
