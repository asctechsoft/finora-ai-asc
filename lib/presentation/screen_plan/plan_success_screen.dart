import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';
import '../common_components/primary_button.dart';

/// Screen 9 — plan created.
class PlanSuccessScreen extends StatelessWidget {
  const PlanSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 116,
                height: 116,
                decoration: BoxDecoration(
                  color: AppColors.positive.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 92,
                    height: 92,
                    decoration: const BoxDecoration(
                      color: AppColors.positive,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 52),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text('plan_success_title'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.heading)),
              const SizedBox(height: 12),
              Text('plan_success_sub'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
              const SizedBox(height: 36),
              PrimaryButton(
                label: 'plan_success_view'.tr,
                trailingIcon: null,
                onPressed: () => Get.offAllNamed(RouteName.home, arguments: 2),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Get.offAllNamed(RouteName.home),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
                  ),
                  alignment: Alignment.center,
                  child: Text('plan_success_home'.tr,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
