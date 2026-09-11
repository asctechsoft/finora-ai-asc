import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/budget_controller.dart';
import '../../controller/user_profile_controller.dart';
import '../../models/ui_models/category_catalog.dart';
import '../../utils/money_format.dart';
import '../../values/app_colors.dart';

class BudgetDetailScreen extends StatelessWidget {
  const BudgetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryKey = Get.arguments as String? ?? 'food';
    final meta = CategoryCatalog.meta(categoryKey);
    final c = Get.find<BudgetController>();
    final currency = Get.find<UserProfileController>().baseCurrency.value;
    final line = c.lines.firstWhere(
      (l) => l.categoryKey == categoryKey,
      orElse: () => BudgetLine(categoryKey, meta.label, 600, 420),
    );
    final daysLeft = _daysLeftInMonth();
    final dailyAllowance = daysLeft <= 0 ? 0.0 : (line.budget - line.spent).clamp(0, line.budget) / daysLeft;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Icon(meta.icon, color: meta.color, size: 22),
            const SizedBox(width: 8),
            Text(meta.label),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz_rounded, color: AppColors.heading)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          _Tabs(),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Money.format(line.spent, currency),
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.heading)),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('of ${Money.format(line.budget, currency)}',
                    style: const TextStyle(color: AppColors.textSecondary)),
              ),
              const Spacer(),
              Text('used'.trArgs(['${line.percent}%']),
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: line.progress,
              minHeight: 10,
              backgroundColor: AppColors.trackBg,
              valueColor: AlwaysStoppedAnimation(meta.color),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.speed_rounded,
                  iconColor: AppColors.primary,
                  label: 'spending_pace'.tr,
                  value: 'on_track'.tr,
                  sub: 'avg_per_day'.trArgs([Money.format(line.spent / _dayOfMonth(), currency)]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.wb_sunny_rounded,
                  iconColor: AppColors.warning,
                  label: 'daily_allowance'.tr,
                  value: Money.format(dailyAllowance.toDouble(), currency, decimals: true),
                  sub: 'per_day'.tr,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.positive.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.eco_rounded, color: AppColors.positive),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('${'nice_work'.tr}\n${'nice_work_desc'.tr}',
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4)),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text('spending_over_time'.tr,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.heading)),
          const SizedBox(height: 16),
          SizedBox(height: 180, child: _SpendingChart(color: meta.color, budget: line.budget)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryTintSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_rounded, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('${'ai_insight'.tr}\n${'ai_insight_dining'.tr}',
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _dayOfMonth() => DateTime.now().day;
  int _daysLeftInMonth() {
    final now = DateTime.now();
    final last = DateTime(now.year, now.month + 1, 0).day;
    return last - now.day;
  }
}

class _Tabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabs = ['overview'.tr, 'transactions'.tr, 'insights'.tr];
    return Row(
      children: List.generate(tabs.length, (i) {
        final sel = i == 0;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: sel ? AppColors.primary : AppColors.card,
              borderRadius: BorderRadius.circular(12),
              boxShadow: sel ? null : AppColors.softShadow,
            ),
            child: Text(tabs[i],
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: sel ? Colors.white : AppColors.textSecondary)),
          ),
        );
      }),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String sub;
  const _StatCard({required this.icon, required this.iconColor, required this.label, required this.value, required this.sub});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 26),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.heading)),
          Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _SpendingChart extends StatelessWidget {
  final Color color;
  final double budget;
  const _SpendingChart({required this.color, required this.budget});

  @override
  Widget build(BuildContext context) {
    // Demo cumulative weekly spend curve.
    final values = [60.0, 130.0, 210.0, 320.0, 420.0];
    const labels = ['Apr 1', 'Apr 8', 'Apr 15', 'Apr 22', 'Apr 30'];
    final maxY = budget;
    return BarChart(
      BarChartData(
        maxY: maxY,
        alignment: BarChartAlignment.spaceAround,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 2,
          getDrawingHorizontalLine: (_) => FlLine(color: AppColors.divider, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: maxY / 2,
              getTitlesWidget: (v, _) => Text('\$${v.toInt()}',
                  style: const TextStyle(fontSize: 10, color: AppColors.textTertiary)),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= labels.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(labels[i], style: const TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < values.length; i++)
            BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                toY: values[i],
                width: 18,
                borderRadius: BorderRadius.circular(6),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [color.withValues(alpha: 0.5), color],
                ),
              ),
            ]),
        ],
      ),
    );
  }
}
