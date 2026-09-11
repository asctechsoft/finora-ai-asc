import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/data_models/transaction_record.dart';
import '../../models/ui_models/category_catalog.dart';
import '../../models/ui_models/transaction_enums.dart';
import '../../presentation/common_components/category_badge.dart';
import '../../repository/finance_repository.dart';
import '../../utils/date_helper.dart';
import '../../utils/money_format.dart';
import '../../values/app_colors.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _repo = FinanceRepository();
  late Future<List<TransactionRecord>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.transactions();
  }

  void _reload() => setState(() => _future = _repo.transactions());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('transactions'.tr),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded, color: AppColors.heading)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded, color: AppColors.heading)),
        ],
      ),
      body: FutureBuilder<List<TransactionRecord>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final txns = snap.data!;
          if (txns.isEmpty) return const _Empty();
          final groups = _groupByDay(txns);
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            color: AppColors.primary,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
              children: [
                for (final entry in groups.entries) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(entry.key,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.heading)),
                  ),
                  ...entry.value.map((t) => _TxnRow(t: t)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Map<String, List<TransactionRecord>> _groupByDay(List<TransactionRecord> txns) {
    final map = <String, List<TransactionRecord>>{};
    for (final t in txns) {
      map.putIfAbsent(DateHelper.dayHeader(t.date), () => []).add(t);
    }
    return map;
  }
}

class _TxnRow extends StatelessWidget {
  final TransactionRecord t;
  const _TxnRow({required this.t});

  @override
  Widget build(BuildContext context) {
    final meta = CategoryCatalog.meta(t.categoryKey);
    final isIncome = t.type == TxnType.income;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CategoryBadge(categoryKey: t.categoryKey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.merchant.isEmpty ? meta.label : t.merchant,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
                const SizedBox(height: 2),
                Text('${t.wallet} · ${meta.label}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'}${Money.format(t.amount, t.currency, decimals: t.amount % 1 != 0)}',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isIncome ? AppColors.positive : AppColors.heading),
              ),
              if (t.isPending)
                Text('pending'.tr, style: const TextStyle(fontSize: 11, color: AppColors.warning)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(color: AppColors.primaryTintSoft, shape: BoxShape.circle),
            child: const Icon(Icons.receipt_long_rounded, size: 42, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text('no_transactions'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.heading)),
          const SizedBox(height: 6),
          Text('add_first_expense'.tr,
              style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
