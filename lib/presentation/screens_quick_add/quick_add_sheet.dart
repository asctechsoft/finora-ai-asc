import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/quick_add_controller.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class _Method {
  final IconData icon;
  final Color color;
  final String title;
  final String sub;
  final VoidCallback onTap;
  _Method(this.icon, this.color, this.title, this.sub, this.onTap);
}

class QuickAddSheet {
  static void show(BuildContext context) {
    // Ensure the controller exists for the whole quick-add flow.
    if (!Get.isRegistered<QuickAddController>()) {
      Get.put(QuickAddController(), permanent: true);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        final methods = [
          _Method(Icons.auto_awesome_rounded, AppColors.livingTogether, 'qa_ai'.tr, 'qa_ai_sub'.tr, () {
            Navigator.pop(ctx);
            Get.toNamed(RouteName.aiCopilot);
          }),
          _Method(Icons.mic_rounded, AppColors.primary, 'qa_voice'.tr, 'qa_voice_sub'.tr, () {
            Navigator.pop(ctx);
            Get.toNamed(RouteName.voicePermission);
          }),
          _Method(Icons.notes_rounded, AppColors.married, 'qa_type'.tr, 'qa_type_sub'.tr, () {
            Navigator.pop(ctx);
            _typeNaturally(context);
          }),
          _Method(Icons.photo_camera_rounded, AppColors.info, 'qa_receipt'.tr, 'qa_receipt_sub'.tr, () {
            Navigator.pop(ctx);
            Get.snackbar('Receipt Scan', 'coming_soon'.tr,
                snackPosition: SnackPosition.BOTTOM);
          }),
          _Method(Icons.description_rounded, AppColors.positive, 'qa_manual'.tr, 'qa_manual_sub'.tr, () {
            Navigator.pop(ctx);
            Get.find<QuickAddController>().newManualDraft();
            Get.toNamed(RouteName.manualTransaction);
          }),
          _Method(Icons.swap_horiz_rounded, AppColors.warning, 'qa_transfer'.tr, 'qa_transfer_sub'.tr, () {
            Navigator.pop(ctx);
            Get.snackbar('Transfer', 'coming_soon'.tr,
                snackPosition: SnackPosition.BOTTOM);
          }),
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text('quick_add'.tr,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.heading)),
                const SizedBox(height: 12),
                for (final m in methods) _MethodRow(m),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _typeNaturally(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('type_naturally'.tr),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'type_hint'.tr,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dctx), child: Text('cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(90, 44)),
            onPressed: () {
              if (ctrl.text.trim().isEmpty) return;
              Get.find<QuickAddController>().parseText(ctrl.text.trim());
              Navigator.pop(dctx);
              Get.toNamed(RouteName.parsedReview);
            },
            child: Text('parse'.tr),
          ),
        ],
      ),
    );
  }
}

class _MethodRow extends StatelessWidget {
  final _Method m;
  const _MethodRow(this.m);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: m.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: m.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(m.icon, color: m.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading, fontSize: 15)),
                  Text(m.sub, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
