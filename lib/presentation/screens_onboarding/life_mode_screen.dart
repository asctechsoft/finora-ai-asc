import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/onboarding_controller.dart';
import '../../models/ui_models/life_mode.dart';
import '../../presentation/common_components/onboarding_scaffold.dart';
import '../../presentation/common_components/primary_button.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class LifeModeScreen extends StatelessWidget {
  const LifeModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OnboardingController>();
    const grid = [
      LifeMode.solo, LifeMode.dating, LifeMode.livingTogether,
      LifeMode.married, LifeMode.withChild, LifeMode.withParents,
    ];
    return OnboardingScaffold(
      step: 4,
      totalSteps: 6,
      bottom: PrimaryButton(label: 'continue_'.tr, onPressed: () => Get.toNamed(RouteName.income)),
      child: ListView(
        children: [
          const Icon(Icons.groups_rounded, color: AppColors.primary, size: 30),
          const SizedBox(height: 12),
          Text('life_mode_title'.tr,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.heading)),
          const SizedBox(height: 10),
          Text('life_mode_subtitle'.tr,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
          const SizedBox(height: 18),
          Obx(() => GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.55,
                children: grid
                    .map((m) => _ModeCard(
                          mode: m,
                          selected: c.lifeMode.value == m,
                          onTap: () => c.lifeMode.value = m,
                        ))
                    .toList(),
              )),
          const SizedBox(height: 12),
          Obx(() => _ModeCard(
                mode: LifeMode.custom,
                selected: c.lifeMode.value == LifeMode.custom,
                onTap: () => c.lifeMode.value = LifeMode.custom,
                wide: true,
              )),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final LifeMode mode;
  final bool selected;
  final VoidCallback onTap;
  final bool wide;
  const _ModeCard({required this.mode, required this.selected, required this.onTap, this.wide = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryTintSoft : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider, width: selected ? 2 : 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(mode.icon, color: mode.accent, size: 24),
                  const SizedBox(height: 8),
                  Text(mode.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(mode.subtitle,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: selected ? AppColors.primary : AppColors.textTertiary, width: 2),
                color: selected ? AppColors.primary : Colors.transparent,
              ),
              child: selected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
