import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../controller/quick_add_controller.dart';
import '../../presentation/common_components/primary_button.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class VoicePermissionScreen extends StatelessWidget {
  const VoicePermissionScreen({super.key});

  Future<void> _allow() async {
    await Permission.microphone.request();
    await Get.find<QuickAddController>().initSpeech();
    Get.offNamed(RouteName.voiceListening);
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close_rounded, color: AppColors.heading),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryTintSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mic_rounded, size: 60, color: AppColors.primary),
              ),
              const SizedBox(height: 28),
              Text('mic_title'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.heading)),
              const SizedBox(height: 10),
              Text('mic_subtitle'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
              const SizedBox(height: 28),
              _Bullet(
                icon: Icons.lock_rounded,
                title: 'mic_b1_title'.tr,
                sub: 'mic_b1_sub'.tr,
              ),
              _Bullet(
                icon: Icons.shield_rounded,
                title: 'mic_b2_title'.tr,
                sub: 'mic_b2_sub'.tr,
              ),
              _Bullet(
                icon: Icons.graphic_eq_rounded,
                title: 'mic_b3_title'.tr,
                sub: 'mic_b3_sub'.tr,
              ),
              const Spacer(),
              PrimaryButton(label: 'allow_microphone'.tr, trailingIcon: null, onPressed: _allow),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.back(),
                child: Text('not_now'.tr,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  const _Bullet({required this.icon, required this.title, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
                const SizedBox(height: 2),
                Text(sub, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
