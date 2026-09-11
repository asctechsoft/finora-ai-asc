import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/onboarding_controller.dart';
import '../../presentation/common_components/category_badge.dart';
import '../../presentation/common_components/onboarding_scaffold.dart';
import '../../presentation/common_components/primary_button.dart';
import '../../utils/money_format.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OnboardingController>();
    return OnboardingScaffold(
      step: 5,
      totalSteps: 6,
      bottom: PrimaryButton(label: 'continue_'.tr, onPressed: () => Get.toNamed(RouteName.goals)),
      child: ListView(
        children: [
          const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary, size: 30),
          const SizedBox(height: 12),
          Text('income_title'.tr,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.heading)),
          const SizedBox(height: 10),
          Text('income_subtitle'.tr,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
          const SizedBox(height: 18),
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < c.incomes.length; i++) ...[
                      _IncomeRow(
                        badge: CategoryBadge(categoryKey: c.incomes[i].categoryKey, size: 40),
                        name: c.incomes[i].name,
                        cadence: c.incomes[i].cadence,
                        amount: Money.format(c.incomes[i].amount, c.currency.value),
                      ),
                      if (i != c.incomes.length - 1) const Divider(height: 1, color: AppColors.divider),
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
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
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
                    const Icon(Icons.bar_chart_rounded, color: AppColors.primary, size: 30),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('total_monthly_income'.tr,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        Text(Money.format(c.totalMonthlyIncome, c.currency.value),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.heading)),
                      ],
                    ),
                    const Spacer(),
                    Text(c.currency.value,
                        style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
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
                const Icon(Icons.eco_rounded, color: AppColors.positive, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('income_tip'.tr,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, height: 1.3)),
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
  const _IncomeRow({required this.badge, required this.name, required this.cadence, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: [
          badge,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
                Text(cadence, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.heading)),
          const SizedBox(width: 6),
          const Icon(Icons.more_horiz_rounded, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}
