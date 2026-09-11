import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';
import '../../controller/user_profile_controller.dart';
import '../../models/ui_models/life_mode.dart';
import '../../presentation/common_components/app_card.dart';
import '../../presentation/common_components/progress_ring.dart';
import '../../presentation/common_components/section_header.dart';
import '../../utils/date_helper.dart';
import '../../utils/life_mode_config.dart';
import '../../utils/money_format.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';
import 'components/home_hero_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HomeController());
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: c.refreshData,
          color: AppColors.primary,
          child: Obx(() {
            final cfg = c.config;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
              children: [
                _TopBar(),
                const SizedBox(height: 14),
                _GreetingRow(config: cfg),
                const SizedBox(height: 16),
                HomeHeroCard(
                  label: cfg.heroLabel,
                  icon: cfg.heroIcon,
                  amount: Money.format(c.safeToSpend, c.profile.baseCurrency.value),
                  budget: Money.format(cfg.budget, c.profile.baseCurrency.value),
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _PulseBanner(config: cfg),
                const SizedBox(height: 20),
                SectionHeader(title: 'this_month'.tr, actionLabel: 'see_all'.tr,
                    onAction: () => Get.toNamed(RouteName.transactions)),
                const SizedBox(height: 10),
                _SummaryTiles(config: cfg),
                const SizedBox(height: 20),
                _BudgetPulse(),
                const SizedBox(height: 20),
                SectionHeader(title: 'upcoming_bills'.tr, actionLabel: 'see_all'.tr,
                    onAction: () => Get.toNamed(RouteName.calendar)),
                const SizedBox(height: 10),
                _UpcomingBills(config: cfg),
                const SizedBox(height: 20),
                Text('quick_actions'.tr,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.heading)),
                const SizedBox(height: 12),
                _QuickActions(config: cfg),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            gradient: AppColors.primaryButton,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(Icons.change_history_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        const Text('ASC Finance AI',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.heading)),
        const Spacer(),
        GestureDetector(
          onTap: () => Get.toNamed(RouteName.notifications),
          child: const Icon(Icons.notifications_none_rounded, color: AppColors.heading),
        ),
      ],
    );
  }
}

class _GreetingRow extends StatelessWidget {
  final HomeConfig config;
  const _GreetingRow({required this.config});

  @override
  Widget build(BuildContext context) {
    final profile = Get.find<UserProfileController>();
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primaryTint,
          child: Icon(profile.lifeMode.value.icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateHelper.timeOfDayGreeting(),
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text(config.greetingNames,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.heading)),
            ],
          ),
        ),
        _ModeChip(),
      ],
    );
  }
}

/// Tapping the chip lets the user switch Life Mode to preview each Home variant.
class _ModeChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profile = Get.find<UserProfileController>();
    return GestureDetector(
      onTap: () => _pickMode(context, profile),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            Icon(profile.lifeMode.value.icon, size: 16, color: profile.lifeMode.value.accent),
            const SizedBox(width: 6),
            Text(profile.lifeMode.value.chipLabel,
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading, fontSize: 13)),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _pickMode(BuildContext context, UserProfileController profile) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text('switch_life_mode'.tr,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.heading)),
            const SizedBox(height: 8),
            for (final m in [
              LifeMode.solo, LifeMode.dating, LifeMode.livingTogether,
              LifeMode.married, LifeMode.withChild,
            ])
              ListTile(
                leading: Icon(m.icon, color: m.accent),
                title: Text(m.title),
                trailing: profile.lifeMode.value == m
                    ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  profile.setLifeMode(m);
                  Navigator.pop(context);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _PulseBanner extends StatelessWidget {
  final HomeConfig config;
  const _PulseBanner({required this.config});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryTintSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.eco_rounded, color: AppColors.primary, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('"${config.pulseTitle}"',
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
                const SizedBox(height: 2),
                Text(config.pulseSubtitle,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTiles extends StatelessWidget {
  final HomeConfig config;
  const _SummaryTiles({required this.config});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < config.tiles.length; i++) ...[
          Expanded(
            child: AppCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(config.tiles[i].label,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Text(config.tiles[i].value,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.heading)),
                  const SizedBox(height: 4),
                  Text(config.tiles[i].delta,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: config.tiles[i].deltaPositive ? AppColors.positive : AppColors.negative)),
                ],
              ),
            ),
          ),
          if (i != config.tiles.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _BudgetPulse extends StatelessWidget {
  const _BudgetPulse();
  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Get.toNamed(RouteName.budgetList),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryTint,
            child: Icon(Icons.eco_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('budget_pulse'.tr,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text('on_track'.tr,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                Text('under_budget'.tr,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const ProgressRing(progress: 0.62, size: 46, stroke: 6),
        ],
      ),
    );
  }
}

class _UpcomingBills extends StatelessWidget {
  final HomeConfig config;
  const _UpcomingBills({required this.config});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < config.bills.length; i++) ...[
          Expanded(
            child: AppCard(
              padding: const EdgeInsets.all(14),
              onTap: () => Get.toNamed(RouteName.calendar),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(config.bills[i].icon, color: config.bills[i].color, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(config.bills[i].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.heading)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(config.bills[i].amount,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.heading)),
                  const SizedBox(height: 2),
                  Text(config.bills[i].due,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          if (i != config.bills.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  final HomeConfig config;
  const _QuickActions({required this.config});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < config.actions.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTintSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(config.actions[i].icon, color: AppColors.primary),
                ),
                const SizedBox(height: 6),
                Text(config.actions[i].label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.2)),
              ],
            ),
          ),
          if (i != config.actions.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}
