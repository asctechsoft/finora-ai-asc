import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/onboarding_controller.dart';
import '../../models/ui_models/currency_info.dart';
import '../../presentation/common_components/category_badge.dart';
import '../../presentation/common_components/onboarding_scaffold.dart';
import '../../presentation/common_components/primary_button.dart';
import '../../utils/money_format.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  void _editIncome(BuildContext context, OnboardingController c, int index) {
    final income = c.incomes[index];
    final nameCtrl = TextEditingController(text: income.name);
    final amountCtrl = TextEditingController(
        text: income.amount == 0
            ? ''
            : NumberFormat('#,##0').format(income.amount));
    final symbol = CurrencyInfo.byCode(c.currency.value).symbol;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dctx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CategoryBadge(categoryKey: income.categoryKey, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('edit_income_source'.tr,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.heading)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(dctx),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                          color: AppColors.trackBg, shape: BoxShape.circle),
                      child: const Icon(Icons.close_rounded,
                          size: 17, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _DialogLabel('income_source_name'.tr),
              const SizedBox(height: 8),
              _DialogField(controller: nameCtrl, autofocus: true),
              const SizedBox(height: 16),
              _DialogLabel('amount'.tr),
              const SizedBox(height: 8),
              _DialogField(
                controller: amountCtrl,
                prefix: symbol,
                keyboardType: TextInputType.number,
                inputFormatters: [_ThousandsInputFormatter()],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      c.removeIncome(index);
                      Navigator.pop(dctx);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.negative.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: AppColors.negative, size: 22),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(dctx),
                    child: Text('cancel'.tr,
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: 'save'.tr,
                trailingIcon: null,
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  final amount = double.tryParse(
                          amountCtrl.text.replaceAll(',', '').trim()) ??
                      0;
                  if (name.isEmpty) return;
                  c.updateIncome(index, name: name, amount: amount);
                  Navigator.pop(dctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OnboardingController>();
    return OnboardingScaffold(
      step: 5,
      totalSteps: 6,
      bottom: PrimaryButton(
          label: 'continue_'.tr, onPressed: () => Get.toNamed(RouteName.goals)),
      child: ListView(
        children: [
          const Icon(Icons.account_balance_wallet_rounded,
              color: AppColors.primary, size: 30),
          const SizedBox(height: 12),
          Text('income_title'.tr,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.heading)),
          const SizedBox(height: 10),
          Text('income_subtitle'.tr,
              style:
                  const TextStyle(color: AppColors.textSecondary, height: 1.4)),
          const SizedBox(height: 18),
          Obx(() => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: AppColors.softShadow,
                ),
                child: c.incomes.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text('no_income_sources'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: AppColors.textSecondary)),
                      )
                    : Column(
                        children: [
                          for (var i = 0; i < c.incomes.length; i++) ...[
                            _IncomeRow(
                              badge: CategoryBadge(
                                  categoryKey: c.incomes[i].categoryKey,
                                  size: 40),
                              name: c.incomes[i].name,
                              cadence: c.incomes[i].cadence,
                              amount: Money.format(
                                  c.incomes[i].amount, c.currency.value),
                              onTap: () => _editIncome(context, c, i),
                            ),
                            if (i != c.incomes.length - 1)
                              const Divider(
                                  height: 1, color: AppColors.divider),
                          ],
                        ],
                      ),
              )),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: c.addIncome,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryTintSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text('add_income_source'.tr,
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 14),
          Obx(() => Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primaryTintSoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bar_chart_rounded,
                        color: AppColors.primary, size: 30),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('total_monthly_income'.tr,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 13)),
                        Text(
                            Money.format(
                                c.totalMonthlyIncome, c.currency.value),
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.heading)),
                      ],
                    ),
                    const Spacer(),
                    Text(c.currency.value,
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              )),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.positive.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.eco_rounded,
                    color: AppColors.positive, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('income_tip'.tr,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          height: 1.3)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _IncomeRow extends StatelessWidget {
  final Widget badge;
  final String name;
  final String cadence;
  final String amount;
  final VoidCallback onTap;
  const _IncomeRow({
    required this.badge,
    required this.name,
    required this.cadence,
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            badge,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading)),
                  Text(cadence,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Text(amount,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, color: AppColors.heading)),
            const SizedBox(width: 6),
            const Icon(Icons.more_horiz_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _DialogLabel extends StatelessWidget {
  final String text;
  const _DialogLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary));
}

class _DialogField extends StatelessWidget {
  final TextEditingController controller;
  final String? prefix;
  final bool autofocus;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  const _DialogField({
    required this.controller,
    this.prefix,
    this.autofocus = false,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.trackBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(
            fontWeight: FontWeight.w700, color: AppColors.heading),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          prefixText: prefix,
          prefixStyle: const TextStyle(
              fontWeight: FontWeight.w700, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

/// Live-formats a numeric field with thousands separators, e.g. "20000000" -> "20,000,000".
class _ThousandsInputFormatter extends TextInputFormatter {
  static final _digitsOnly = RegExp(r'[^0-9]');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(_digitsOnly, '');
    if (digits.isEmpty) return const TextEditingValue(text: '');
    final formatted = NumberFormat('#,##0').format(int.parse(digits));
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
