import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/common_components/primary_button.dart';
import '../../values/app_colors.dart';

class _CalEvent {
  final int day;
  final IconData icon;
  final Color color;
  const _CalEvent(this.day, this.icon, this.color);
}

class _Upcoming {
  final IconData icon;
  final Color color;
  final String name;
  final String date;
  final String amount;
  final bool positive;
  const _Upcoming(this.icon, this.color, this.name, this.date, this.amount, this.positive);
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final events = const [
      _CalEvent(1, Icons.attach_money_rounded, AppColors.positive),
      _CalEvent(5, Icons.home_rounded, AppColors.housing),
      _CalEvent(10, Icons.lightbulb_rounded, AppColors.warning),
      _CalEvent(15, Icons.bolt_rounded, AppColors.warning),
      _CalEvent(20, Icons.favorite_rounded, AppColors.dating),
      _CalEvent(25, Icons.home_rounded, AppColors.housing),
      _CalEvent(30, Icons.attach_money_rounded, AppColors.positive),
    ];
    final upcoming = const [
      _Upcoming(Icons.attach_money_rounded, AppColors.positive, 'Payday', 'Tue, Apr 1', '+\$5,000', true),
      _Upcoming(Icons.home_rounded, AppColors.housing, 'Rent', 'Sat, Apr 5', '-\$1,500', false),
      _Upcoming(Icons.bolt_rounded, AppColors.warning, 'Electricity', 'Tue, Apr 15', '-\$120', false),
      _Upcoming(Icons.favorite_rounded, AppColors.dating, 'Goal Contribution', 'Sun, Apr 20', '-\$400', false),
      _Upcoming(Icons.wifi_rounded, AppColors.info, 'Internet', 'Fri, Apr 25', '-\$80', false),
      _Upcoming(Icons.track_changes_rounded, AppColors.primary, 'Investments / Goals', 'Wed, Apr 30', '-\$300', false),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Text('financial_calendar'.tr),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_rounded, color: AppColors.primary)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Center(
            child: Text('calendar_subtitle'.tr,
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppColors.softShadow,
            ),
            child: _MonthGrid(month: now, events: events),
          ),
          const SizedBox(height: 20),
          Text('upcoming_this_month'.tr,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.heading)),
          const SizedBox(height: 8),
          ...upcoming.map((u) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Icon(u.icon, color: u.color, size: 22),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(u.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.heading)),
                    ),
                    Text(u.date, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    const SizedBox(width: 16),
                    Text(u.amount,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: u.positive ? AppColors.positive : AppColors.negative)),
                  ],
                ),
              )),
          const SizedBox(height: 12),
          PrimaryButton(label: 'view_full_calendar'.tr, onPressed: () {}),
        ],
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final List<_CalEvent> events;
  const _MonthGrid({required this.month, required this.events});

  @override
  Widget build(BuildContext context) {
    const wd = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = first.weekday % 7; // Sun=0
    final cells = <Widget>[];
    for (var i = 0; i < leading; i++) {
      cells.add(const SizedBox());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final ev = events.where((e) => e.day == day).toList();
      cells.add(_DayCell(day: day, event: ev.isEmpty ? null : ev.first));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.chevron_left_rounded, color: AppColors.textSecondary),
            Text('${_monthName(month.month)} ${month.year}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: wd
              .map((d) => Expanded(
                    child: Center(
                      child: Text(d,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 6),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.82,
          children: cells,
        ),
      ],
    );
  }

  String _monthName(int m) => const [
        '', 'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ][m];
}

class _DayCell extends StatelessWidget {
  final int day;
  final _CalEvent? event;
  const _DayCell({required this.day, this.event});

  @override
  Widget build(BuildContext context) {
    final isToday = day == DateTime.now().day;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isToday ? AppColors.primary : Colors.transparent,
          ),
          child: Text('$day',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isToday ? Colors.white : AppColors.heading,
              )),
        ),
        const SizedBox(height: 2),
        if (event != null)
          Icon(event!.icon, size: 12, color: event!.color)
        else
          const SizedBox(height: 12),
      ],
    );
  }
}
