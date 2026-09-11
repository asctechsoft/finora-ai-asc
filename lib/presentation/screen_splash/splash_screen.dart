import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/user_profile_controller.dart';
import '../../services/seed_service.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final profile = Get.find<UserProfileController>();
    if (profile.onboarded) {
      await SeedService().ensureSeeded(profile.baseCurrency.value);
    }
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    Get.offAllNamed(profile.onboarded ? RouteName.home : RouteName.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: AppColors.primaryButton,
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppColors.cardShadow,
              ),
              child: const Icon(Icons.change_history_rounded, color: Colors.white, size: 52),
            ),
            const SizedBox(height: 24),
            const Text('ASC Finance AI',
                style: TextStyle(
                    fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.heading)),
            const SizedBox(height: 6),
            Text('app_tagline'.tr,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary)),
            const SizedBox(height: 40),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 2.6, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
