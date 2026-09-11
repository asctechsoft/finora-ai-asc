import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/onboarding_controller.dart';
import '../../models/ui_models/currency_info.dart';
import '../../presentation/common_components/onboarding_scaffold.dart';
import '../../presentation/common_components/primary_button.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class LocaleScreen extends StatelessWidget {
  const LocaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OnboardingController>();
    return OnboardingScaffold(
      step: 2,
      totalSteps: 6,
      bottom: PrimaryButton(label: 'continue_'.tr, onPressed: () => Get.toNamed(RouteName.currency)),
      child: ListView(
        children: [
          const Icon(Icons.public_rounded, color: AppColors.primary, size: 30),
          const SizedBox(height: 12),
          Text('locale_setup'.tr,
              style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('locale_title'.tr,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.heading, height: 1.2)),
          const SizedBox(height: 10),
          Text('locale_subtitle'.tr,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
          const SizedBox(height: 20),
          _Label('country_region'.tr),
          const SizedBox(height: 8),
          _SearchField(hint: 'search_countries'.tr),
          const SizedBox(height: 10),
          Obx(() => Column(
                children: CountryInfo.all
                    .map((country) => _CountryRow(
                          country: country,
                          selected: c.country.value == country.code,
                          onTap: () => c.country.value = country.code,
                        ))
                    .toList(),
              )),
          const SizedBox(height: 6),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text('show_more_countries'.tr,
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 8),
          _Label('language'.tr),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: const [
                Icon(Icons.language_rounded, color: AppColors.textSecondary, size: 20),
                SizedBox(width: 12),
                Text('English', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.heading)),
                Spacer(),
                Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _CountryRow extends StatelessWidget {
  final CountryInfo country;
  final bool selected;
  final VoidCallback onTap;
  const _CountryRow({required this.country, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Text(country.flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(country.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.heading)),
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

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading, fontSize: 15));
}

class _SearchField extends StatelessWidget {
  final String hint;
  const _SearchField({required this.hint});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.trackBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.textTertiary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: AppColors.textTertiary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
