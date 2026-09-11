import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';
import '../../controller/quick_add_controller.dart';
import '../../utils/money_format.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class AddSuccessScreen extends StatefulWidget {
  const AddSuccessScreen({super.key});

  @override
  State<AddSuccessScreen> createState() => _AddSuccessScreenState();
}

class _AddSuccessScreenState extends State<AddSuccessScreen> {
  final c = Get.find<QuickAddController>();
  late final int? _txnId = Get.arguments as int?;

  @override
  void initState() {
    super.initState();
    // Refresh Home so Safe-to-Spend reflects the new transaction.
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().refreshData();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _showUndo());
  }

  void _showUndo() {
    Get.rawSnackbar(
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('transaction_added'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          GestureDetector(
            onTap: () async {
              if (_txnId != null && _txnId >= 0) await c.undo(_txnId);
              if (Get.isRegistered<HomeController>()) Get.find<HomeController>().refreshData();
              Get.closeAllSnackbars();
              Get.offAllNamed(RouteName.home);
            },
            child: Text('undo'.tr,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
      backgroundColor: AppColors.heading,
      borderRadius: 14,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = c.draft.value;
    final amount = d == null ? '' : Money.format(d.amount, d.currency, decimals: true);
    final merchant = d?.merchant ?? '';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Get.offAllNamed(RouteName.home),
                  icon: const Icon(Icons.close_rounded, color: AppColors.heading),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.positive.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: AppColors.positive, size: 52),
              ),
              const SizedBox(height: 24),
              Text('added_success'.tr,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.heading)),
              const SizedBox(height: 8),
              Text('success_desc'.trArgs([amount, merchant]),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
              const SizedBox(height: 24),
              _SafeToSpendCard(delta: amount),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryTintSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_rounded, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('${'ai_insight'.tr}\n${'ai_insight_coffee'.tr}',
                          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed(RouteName.home),
                  child: Text('add_another'.tr),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    side: const BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Get.offAllNamed(RouteName.home);
                    Get.toNamed(RouteName.transactions);
                  },
                  child: Text('view_transactions'.tr,
                      style: const TextStyle(color: AppColors.heading, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SafeToSpendCard extends StatelessWidget {
  final String delta;
  const _SafeToSpendCard({required this.delta});
  @override
  Widget build(BuildContext context) {
    final home = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    final safe = home == null
        ? ''
        : Money.format(home.safeToSpend, home.profile.baseCurrency.value);
    final budget = home == null ? '' : Money.format(home.config.budget, home.profile.baseCurrency.value);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('updated_safe_to_spend'.tr,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(safe,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.heading)),
              const SizedBox(width: 10),
              Icon(Icons.arrow_downward_rounded, size: 16, color: AppColors.negative),
              Text(delta, style: const TextStyle(color: AppColors.negative, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 4),
          Text('of_this_month'.trArgs([budget]),
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
