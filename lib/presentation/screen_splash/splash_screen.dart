import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/user_profile_controller.dart';
import '../../services/seed_service.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

const _kSplashWordmarkGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [AppColors.primaryDeep, AppColors.primary, Color(0xFF0EA5E9)],
);

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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/png/img_bg_splash.png', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),
                Image.asset('assets/images/png/img_splash.png', width: 180),
                const SizedBox(height: 20),
                ShaderMask(
                  shaderCallback: (bounds) => _kSplashWordmarkGradient.createShader(bounds),
                  child: const Text('TrackFlow',
                      style: TextStyle(
                          fontSize: 46, fontWeight: FontWeight.w900, color: Colors.white)),
                ),
                const SizedBox(height: 8),
                Text('app_tagline'.tr,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const Spacer(flex: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 64),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      backgroundColor: AppColors.divider,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text('splash_loading'.tr,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
