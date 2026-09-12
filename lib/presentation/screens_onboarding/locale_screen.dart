import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/onboarding_controller.dart';
import '../../models/ui_models/app_language.dart';
import '../../presentation/common_components/onboarding_scaffold.dart';
import '../../presentation/common_components/primary_button.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class LocaleScreen extends StatefulWidget {
  const LocaleScreen({super.key});

  @override
  State<LocaleScreen> createState() => _LocaleScreenState();
}

class _LocaleScreenState extends State<LocaleScreen> {
  final _c = Get.find<OnboardingController>();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final matches = AppLanguage.all.where((l) => l.matches(_query)).toList();
    return OnboardingScaffold(
      step: 2,
      totalSteps: 6,
      bottom: PrimaryButton(
        label: 'continue_'.tr,
        onPressed: () => Get.toNamed(RouteName.currency),
      ),
      child: ListView(
        children: [
          Image.asset('assets/images/png/img_language.png', height: 88),
          const SizedBox(height: 12),
          Text('locale_setup'.tr,
              style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('locale_title'.tr,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.heading, height: 1.2)),
          const SizedBox(height: 10),
          Text('locale_subtitle'.tr,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
          const SizedBox(height: 20),
          _Label('language'.tr),
          const SizedBox(height: 8),
          _SearchField(
            hint: 'search_languages'.tr,
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 10),
          if (matches.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text('no_language_found'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary)),
            )
          else
            Obx(() => Column(
                  children: matches
                      .map((lang) => _LanguageRow(
                            lang: lang,
                            selected: _c.language.value == lang.code,
                            onTap: () => _c.setLanguage(lang),
                          ))
                      .toList(),
                )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final AppLanguage lang;
  final bool selected;
  final VoidCallback onTap;
  const _LanguageRow({required this.lang, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Text(lang.flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(lang.label,
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
  final ValueChanged<String> onChanged;
  const _SearchField({required this.hint, required this.onChanged});

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
              onChanged: onChanged,
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
