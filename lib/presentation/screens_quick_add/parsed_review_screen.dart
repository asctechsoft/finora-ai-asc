import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/quick_add_controller.dart';
import '../../models/ui_models/category_catalog.dart';
import '../../models/ui_models/transaction_enums.dart';
import '../../presentation/common_components/primary_button.dart';
import '../../utils/date_helper.dart';
import '../../utils/money_format.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class ParsedReviewScreen extends StatelessWidget {
  const ParsedReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuickAddController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          final d = c.draft.value;
          if (d == null) {
            return Center(child: Text('nothing_to_review'.tr));
          }
          final conf = c.confidence.value;
          final meta = CategoryCatalog.meta(d.categoryKey);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.arrow_back_rounded, color: AppColors.heading),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const LinearProgressIndicator(
                          value: 4 / 5,
                          minHeight: 6,
                          backgroundColor: AppColors.trackBg,
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text('4/5', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 16),
                    Text('review_title'.tr,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.heading)),
                    const SizedBox(height: 6),
                    Text('review_subtitle'.tr,
                        style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 16),
                    _ConfidenceBanner(conf: conf),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: AppColors.softShadow,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _AmountRow(
                            amount: Money.format(d.amount, d.currency, decimals: true),
                            currency: d.currency,
                            onEdit: () => _editAmount(context, c, d.amount),
                          ),
                          const Divider(height: 1, color: AppColors.divider),
                          _Row(
                            label: 'category'.tr,
                            icon: meta.icon,
                            iconColor: meta.color,
                            value: meta.label,
                            onTap: () => _pickCategory(context, c),
                          ),
                          const Divider(height: 1, color: AppColors.divider),
                          _Row(
                            label: 'merchant'.tr,
                            icon: Icons.storefront_rounded,
                            iconColor: AppColors.primary,
                            value: d.merchant.isEmpty ? 'unknown'.tr : d.merchant,
                          ),
                          const Divider(height: 1, color: AppColors.divider),
                          _Row(
                            label: 'date'.tr,
                            icon: Icons.calendar_today_rounded,
                            iconColor: AppColors.info,
                            value: DateHelper.dayHeader(d.date) == 'Today'
                                ? 'Today, ${DateHelper.friendlyDate(d.date).split(', ').sublist(1).join(', ')}'
                                : DateHelper.friendlyDate(d.date),
                          ),
                          const Divider(height: 1, color: AppColors.divider),
                          _Row(
                            label: 'wallet_account'.tr,
                            icon: Icons.account_balance_wallet_rounded,
                            iconColor: AppColors.warning,
                            value: d.wallet,
                          ),
                          const Divider(height: 1, color: AppColors.divider),
                          _Row(
                            label: 'paid_by'.tr,
                            icon: Icons.person_rounded,
                            iconColor: AppColors.textSecondary,
                            value: d.payer,
                          ),
                          const Divider(height: 1, color: AppColors.divider),
                          _Row(
                            label: 'split_rule'.tr,
                            icon: Icons.groups_rounded,
                            iconColor: AppColors.dating,
                            value: d.splitRule.label,
                          ),
                          const Divider(height: 1, color: AppColors.divider),
                          _RecurringRow(
                            value: d.recurring != Recurring.off,
                            onChanged: (v) => c.updateDraft(
                                (t) => t.copyWith(recurring: v ? Recurring.monthly : Recurring.off)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTintSoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.edit_note_rounded, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text('${'add_note'.tr}\n${'add_note_hint'.tr}',
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: PrimaryButton(
                  label: 'add_transaction'.tr,
                  onPressed: () async {
                    final id = await c.saveDraft();
                    Get.offNamed(RouteName.addSuccess, arguments: id);
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _editAmount(BuildContext context, QuickAddController c, double current) {
    final ctrl = TextEditingController(text: current == 0 ? '' : current.toString());
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('amount'.tr),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(hintText: '0.00'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dctx), child: Text('cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(80, 44)),
            onPressed: () {
              final v = double.tryParse(ctrl.text.replaceAll(',', '.')) ?? current;
              c.updateDraft((t) => t.copyWith(amount: v));
              Navigator.pop(dctx);
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }

  void _pickCategory(BuildContext context, QuickAddController c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: CategoryCatalog.expense
              .map((m) => ListTile(
                    leading: Icon(m.icon, color: m.color),
                    title: Text(m.label),
                    onTap: () {
                      c.updateDraft((t) => t.copyWith(categoryKey: m.key));
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _ConfidenceBanner extends StatelessWidget {
  final double conf;
  const _ConfidenceBanner({required this.conf});
  @override
  Widget build(BuildContext context) {
    final high = conf >= 0.8;
    final pct = (conf * 100).round();
    final color = high ? AppColors.positive : AppColors.warning;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(high ? Icons.auto_awesome_rounded : Icons.info_rounded, color: color, size: 20),
          const SizedBox(width: 10),
          Text(high ? 'high_confidence'.tr : 'double_check'.tr,
              style: TextStyle(fontWeight: FontWeight.w700, color: color)),
          const Spacer(),
          Text('$pct%', style: TextStyle(fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String amount;
  final String currency;
  final VoidCallback onEdit;
  const _AmountRow({required this.amount, required this.currency, required this.onEdit});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Text('amount'.tr, style: const TextStyle(color: AppColors.textSecondary)),
            const Spacer(),
            Text(amount,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.heading)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.trackBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(currency, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textSecondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final String value;
  final VoidCallback? onTap;
  const _Row({required this.label, required this.icon, required this.iconColor, required this.value, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 130,
              child: Text(label, style: const TextStyle(color: AppColors.textSecondary)),
            ),
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(value,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _RecurringRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _RecurringRow({required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 130, child: Text('recurring'.tr, style: const TextStyle(color: AppColors.textSecondary))),
          const Icon(Icons.repeat_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text('repeat_transaction'.tr,
                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.heading, fontSize: 13)),
          ),
          Switch.adaptive(value: value, activeThumbColor: AppColors.primary, onChanged: onChanged),
        ],
      ),
    );
  }
}
