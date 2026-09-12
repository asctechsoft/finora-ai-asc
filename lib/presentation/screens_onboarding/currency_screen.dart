import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/onboarding_controller.dart';
import '../../models/ui_models/currency_info.dart';
import '../../presentation/common_components/onboarding_scaffold.dart';
import '../../presentation/common_components/primary_button.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OnboardingController>();
    return OnboardingScaffold(
      step: 3,
      totalSteps: 6,
      bottom: PrimaryButton(label: 'continue_'.tr, onPressed: () => Get.toNamed(RouteName.lifeMode)),
      child: ListView(
        children: [
          Image.asset('assets/images/png/img_tien_te.png', height: 88),
          const SizedBox(height: 12),
          Text('currency_title'.tr,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.heading)),
          const SizedBox(height: 10),
          Text('currency_subtitle'.tr,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: AppColors.trackBg, borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppColors.textTertiary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'search_currencies'.tr,
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: AppColors.textTertiary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Obx(() => Column(
                children: CurrencyInfo.all
                    .map((info) => _CurrencyRow(
                          info: info,
                          selected: c.currency.value == info.code,
                          onTap: () => c.currency.value = info.code,
                        ))
                    .toList(),
              )),
        ],
      ),
    );
  }
}

class _CurrencyRow extends StatelessWidget {
  final CurrencyInfo info;
  final bool selected;
  final VoidCallback onTap;
  const _CurrencyRow({required this.info, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.trackBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(info.symbol,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.white : AppColors.textSecondary)),
            ),
            const SizedBox(width: 14),
            SizedBox(
              width: 46,
              child: Text(info.code,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
            ),
            Expanded(
              child: Text(info.name, style: const TextStyle(color: AppColors.textSecondary)),
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
