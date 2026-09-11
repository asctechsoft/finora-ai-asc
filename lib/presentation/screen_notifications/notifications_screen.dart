import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/notification_controller.dart';
import '../../models/data_models/app_notification.dart';
import '../../utils/date_helper.dart';
import '../../values/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(NotificationController());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('notifications'.tr),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_rounded, color: AppColors.primary)),
        ],
      ),
      body: Obx(() {
        final list = c.visible;
        final today = list.where((n) => DateHelper.dayHeader(n.timestamp) == 'today'.tr).toList();
        final earlier = list.where((n) => DateHelper.dayHeader(n.timestamp) != 'today'.tr).toList();
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            Text('notifications_subtitle'.tr,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 14),
            Row(
              children: [
                _FilterPill(label: '${'filter_all'.tr} (${c.items.length})', value: 'all', current: c.filter),
                const SizedBox(width: 8),
                _FilterPill(label: '${'filter_alerts'.tr} (${c.alertCount})', value: 'alerts', current: c.filter, dot: true),
                const SizedBox(width: 8),
                _FilterPill(label: '${'filter_updates'.tr} (${c.updateCount})', value: 'updates', current: c.filter),
              ],
            ),
            const SizedBox(height: 18),
            if (today.isNotEmpty) ...[
              _GroupLabel('today'.tr),
              ...today.map((n) => _NotificationCard(n: n)),
              const SizedBox(height: 8),
            ],
            if (earlier.isNotEmpty) ...[
              _GroupLabel('earlier'.tr),
              ...earlier.map((n) => _NotificationCard(n: n)),
            ],
          ],
        );
      }),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final String value;
  final RxString current;
  final bool dot;
  const _FilterPill({required this.label, required this.value, required this.current, this.dot = false});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sel = current.value == value;
      return GestureDetector(
        onTap: () => current.value = value,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: sel ? AppColors.primary : AppColors.card,
            borderRadius: BorderRadius.circular(20),
            boxShadow: sel ? null : AppColors.softShadow,
          ),
          child: Row(
            children: [
              Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: sel ? Colors.white : AppColors.textSecondary)),
              if (dot) ...[
                const SizedBox(width: 6),
                Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.negative, shape: BoxShape.circle)),
              ],
            ],
          ),
        ),
      );
    });
  }
}

class _GroupLabel extends StatelessWidget {
  final String label;
  const _GroupLabel(this.label);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.heading)),
      );
}

class _NotificationCard extends StatelessWidget {
  final AppNotification n;
  const _NotificationCard({required this.n});

  static const _meta = {
    'budget': (Icons.bar_chart_rounded, AppColors.negative),
    'bill': (Icons.calendar_today_rounded, AppColors.info),
    'insight': (Icons.auto_awesome_rounded, AppColors.married),
    'milestone': (Icons.savings_rounded, AppColors.positive),
    'travel': (Icons.flight_rounded, AppColors.warning),
    'unusual': (Icons.shopping_bag_rounded, AppColors.dating),
  };

  @override
  Widget build(BuildContext context) {
    final m = _meta[n.type] ?? (Icons.notifications_rounded, AppColors.primary);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: m.$2.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(m.$1, color: m.$2, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(n.title,
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
                    ),
                    Text(DateFormat('h:mm a').format(n.timestamp),
                        style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(n.body,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
