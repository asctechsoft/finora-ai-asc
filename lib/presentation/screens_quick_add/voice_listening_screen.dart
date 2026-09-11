import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/quick_add_controller.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class VoiceListeningScreen extends StatefulWidget {
  const VoiceListeningScreen({super.key});

  @override
  State<VoiceListeningScreen> createState() => _VoiceListeningScreenState();
}

class _VoiceListeningScreenState extends State<VoiceListeningScreen>
    with SingleTickerProviderStateMixin {
  final c = Get.find<QuickAddController>();
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    c.startListening();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Future<void> _stop() async {
    await c.stopListening();
    Get.offNamed(RouteName.parsedReview);
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
              const SizedBox(height: 8),
              Text('listening_title'.tr,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.heading)),
              const SizedBox(height: 8),
              Text('listening_subtitle'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const Spacer(),
              AnimatedBuilder(
                animation: _anim,
                builder: (_, __) {
                  final scale = 1 + _anim.value * 0.12;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 180 * scale,
                        height: 180 * scale,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.08),
                        ),
                      ),
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.15),
                        ),
                      ),
                      Container(
                        width: 88,
                        height: 88,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.heroGradient,
                        ),
                        child: const Icon(Icons.mic_rounded, color: Colors.white, size: 40),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 40,
                child: AnimatedBuilder(
                  animation: _anim,
                  builder: (_, __) => _Waveform(t: _anim.value),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => Text(
                    c.transcript.value.isEmpty
                        ? '“…”'
                        : '“${c.transcript.value}”',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.heading),
                  )),
              const Spacer(),
              Row(
                children: [
                  Expanded(child: _chip(Icons.language_rounded, 'detected_language'.tr, 'English (US)')),
                  const SizedBox(width: 12),
                  Expanded(child: _chip(Icons.graphic_eq_rounded, 'listening'.tr, 'speak_now'.tr)),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _stop,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.trackBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.stop_rounded, color: AppColors.negative),
                      const SizedBox(width: 8),
                      Text('tap_to_stop'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.back(),
                child: Text('cancel'.tr,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryTintSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.heading)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  final double t;
  const _Waveform({required this.t});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(32, (i) {
        final h = 6 + (math.sin((i * 0.6) + t * 6).abs() * 28);
        return Container(
          width: 3,
          height: h,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
