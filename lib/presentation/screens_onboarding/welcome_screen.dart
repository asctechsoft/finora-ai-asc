import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/common_components/app_card.dart';
import '../../presentation/common_components/primary_button.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed(RouteName.locale),
                  child: Text('skip'.tr,
                      style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                ),
              ),
              const Spacer(),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryButton,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.change_history_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              const Text('ASC Finance AI',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.heading)),
              const SizedBox(height: 6),
              Text('app_tagline'.tr,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary)),
              const SizedBox(height: 14),
              Text(
                'welcome_subtitle'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.4),
              ),
              const Spacer(),
              AppCard(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Benefit(icon: Icons.chat_bubble_rounded, title: 'benefit_talk'.tr, sub: 'benefit_talk_sub'.tr),
                    _Benefit(icon: Icons.bar_chart_rounded, title: 'benefit_track'.tr, sub: 'benefit_track_sub'.tr),
                    _Benefit(icon: Icons.track_changes_rounded, title: 'benefit_plan'.tr, sub: 'benefit_plan_sub'.tr),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(label: 'get_started'.tr, onPressed: () => Get.toNamed(RouteName.locale)),
              const SizedBox(height: 14),
              Text(
                'welcome_footer'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  const _Benefit({required this.icon, required this.title, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
        const SizedBox(height: 2),
        Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
