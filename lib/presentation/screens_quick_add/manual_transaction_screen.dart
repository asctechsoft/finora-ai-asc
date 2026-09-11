import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/quick_add_controller.dart';
import '../../models/ui_models/category_catalog.dart';
import '../../models/ui_models/currency_info.dart';
import '../../models/ui_models/transaction_enums.dart';
import '../../presentation/common_components/primary_button.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class ManualTransactionScreen extends StatelessWidget {
  const ManualTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuickAddController>();
    final merchantCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('add_transaction_title'.tr)),
      body: Obx(() {
        final d = c.draft.value;
        if (d == null) return const SizedBox();
        final meta = CategoryCatalog.meta(d.categoryKey);
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 8),
                  _TypeToggle(
                    value: d.type,
                    onChanged: (t) => c.updateDraft((x) => x.copyWith(type: t)),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => _editAmount(context, c, d.amount),
                      child: Column(
                        children: [
                          Text('amount'.tr, style: const TextStyle(color: AppColors.textSecondary)),
                          const SizedBox(height: 6),
                          Text(
                            '${CurrencyInfo.byCode(d.currency).symbol}${d.amount == 0 ? '0' : d.amount.toStringAsFixed(d.amount % 1 == 0 ? 0 : 2)}',
                            style: const TextStyle(
                                fontSize: 44, fontWeight: FontWeight.w800, color: AppColors.heading),
                          ),
                          Text('tap_to_edit'.tr,
                              style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: AppColors.softShadow,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _PickRow(
                          label: 'category'.tr,
                          icon: meta.icon,
                          color: meta.color,
                          value: meta.label,
                          onTap: () => _pickCategory(context, c, d.type),
                        ),
                        const Divider(height: 1, color: AppColors.divider),
                        _FieldRow(
                          label: 'merchant_source'.tr,
                          icon: Icons.storefront_rounded,
                          color: AppColors.primary,
                          controller: merchantCtrl,
                          hint: 'optional'.tr,
                          onChanged: (v) => c.updateDraft((x) => x.copyWith(merchant: v)),
                        ),
                        const Divider(height: 1, color: AppColors.divider),
                        _PickRow(
                          label: 'wallet_account'.tr,
                          icon: Icons.account_balance_wallet_rounded,
                          color: AppColors.warning,
                          value: d.wallet,
                          onTap: () => _pickWallet(context, c),
                        ),
                        const Divider(height: 1, color: AppColors.divider),
                        _FieldRow(
                          label: 'notes'.tr,
                          icon: Icons.edit_note_rounded,
                          color: AppColors.textSecondary,
                          controller: noteCtrl,
                          hint: 'optional'.tr,
                          onChanged: (v) => c.updateDraft((x) => x.copyWith(note: v)),
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
                label: 'save_transaction'.tr,
                trailingIcon: null,
                enabled: d.amount > 0,
                onPressed: () async {
                  final id = await c.saveDraft();
                  Get.offNamed(RouteName.addSuccess, arguments: id);
                },
              ),
            ),
          ],
        );
      }),
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

  void _pickCategory(BuildContext context, QuickAddController c, TxnType type) {
    final cats = type == TxnType.income ? CategoryCatalog.incomeCats : CategoryCatalog.expense;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: cats
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

  void _pickWallet(BuildContext context, QuickAddController c) {
    const wallets = ['Chase Checking', 'Cash', 'Apple Pay', 'Savings'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: wallets
              .map((w) => ListTile(
                    leading: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.warning),
                    title: Text(w),
                    onTap: () {
                      c.updateDraft((t) => t.copyWith(wallet: w));
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final TxnType value;
  final ValueChanged<TxnType> onChanged;
  const _TypeToggle({required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.trackBg, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: TxnType.values.map((t) {
          final sel = t == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(t),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: sel ? AppColors.card : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: sel ? AppColors.softShadow : null,
                ),
                child: Text(t.label,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: sel ? AppColors.primary : AppColors.textSecondary)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PickRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String value;
  final VoidCallback onTap;
  const _PickRow({required this.label, required this.icon, required this.color, required this.value, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            SizedBox(width: 130, child: Text(label, style: const TextStyle(color: AppColors.textSecondary))),
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading))),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  const _FieldRow({required this.label, required this.icon, required this.color, required this.controller, required this.hint, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 130, child: Text(label, style: const TextStyle(color: AppColors.textSecondary))),
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
                hintStyle: const TextStyle(color: AppColors.textTertiary),
              ),
              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading),
            ),
          ),
        ],
      ),
    );
  }
}
