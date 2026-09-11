import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/plan_controller.dart';
import '../../controller/user_profile_controller.dart';
import '../../models/ui_models/currency_info.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';
import '../common_components/primary_button.dart';

/// Step 1/3 — name, period, monthly budget, optional description.
class PlanBasicInfoScreen extends StatefulWidget {
  const PlanBasicInfoScreen({super.key});

  @override
  State<PlanBasicInfoScreen> createState() => _PlanBasicInfoScreenState();
}

class _PlanBasicInfoScreenState extends State<PlanBasicInfoScreen> {
  final _c = Get.find<PlanController>();
  late final TextEditingController _name;
  late final TextEditingController _budget;
  late final TextEditingController _desc;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: _c.draftName.value);
    _budget = TextEditingController(
        text: _c.draftBudget.value <= 0 ? '' : _c.draftBudget.value.toStringAsFixed(0));
    _desc = TextEditingController(text: _c.draftDescription.value);
  }

  @override
  void dispose() {
    _name.dispose();
    _budget.dispose();
    _desc.dispose();
    super.dispose();
  }

  bool get _valid => _name.text.trim().isNotEmpty && (double.tryParse(_budget.text.trim()) ?? 0) > 0;

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 10),
      initialDateRange: DateTimeRange(
        start: _c.draftStart.value ?? DateTime(now.year, now.month, 1),
        end: _c.draftEnd.value ?? DateTime(now.year, 12, 31),
      ),
    );
    if (picked == null) return;
    _c.draftStart.value = picked.start;
    _c.draftEnd.value = picked.end;
  }

  @override
  Widget build(BuildContext context) {
    final currency = Get.find<UserProfileController>().baseCurrency.value;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text('plan_create_title'.tr,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.heading)),
            Text('plan_step'.trArgs(['1']),
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              children: [
                Text('plan_basic_info'.tr,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.heading)),
                const SizedBox(height: 18),
                _Label('plan_name'.tr),
                _Field(
                  controller: _name,
                  hint: 'plan_name_hint'.tr,
                  onChanged: (v) => setState(() => _c.draftName.value = v),
                ),
                const SizedBox(height: 16),
                _Label('plan_period'.tr),
                Obx(() => GestureDetector(
                      onTap: _pickRange,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        decoration: _boxDecoration,
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                size: 18, color: AppColors.textSecondary),
                            const SizedBox(width: 10),
                            Text(_rangeLabel,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: AppColors.heading)),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 16),
                _Label('plan_monthly_budget'.tr),
                _Field(
                  controller: _budget,
                  hint: '0',
                  keyboardType: TextInputType.number,
                  suffix: CurrencyInfo.byCode(currency).symbol,
                  onChanged: (v) =>
                      setState(() => _c.draftBudget.value = double.tryParse(v.trim()) ?? 0),
                ),
                const SizedBox(height: 16),
                _Label('plan_description'.tr),
                _Field(
                  controller: _desc,
                  hint: 'plan_description_hint'.tr,
                  maxLines: 4,
                  onChanged: (v) => _c.draftDescription.value = v,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: PrimaryButton(
              label: 'continue_'.tr,
              trailingIcon: null,
              enabled: _valid,
              onPressed: () => Get.toNamed(RouteName.planGoalSelect),
            ),
          ),
        ],
      ),
    );
  }

  String get _rangeLabel {
    final s = _c.draftStart.value;
    final e = _c.draftEnd.value;
    if (s == null || e == null) return 'plan_pick_period'.tr;
    return '${_d(s)} - ${_d(e)}';
  }

  static String _d(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

BoxDecoration get _boxDecoration => BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.divider),
    );

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      );
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? suffix;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const _Field({
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.maxLines = 1,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: _boxDecoration,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.heading),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          hintStyle: const TextStyle(color: AppColors.textTertiary, fontWeight: FontWeight.w400),
          suffixText: suffix,
          suffixStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
