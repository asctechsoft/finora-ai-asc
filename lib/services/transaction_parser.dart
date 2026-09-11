import '../models/ui_models/category_catalog.dart';
import '../models/ui_models/currency_info.dart';

/// Result of parsing free text / speech into a draft transaction.
class ParsedTransaction {
  final double amount;
  final String currency;
  final String categoryKey;
  final String merchant;
  final double confidence;

  ParsedTransaction({
    required this.amount,
    required this.currency,
    required this.categoryKey,
    required this.merchant,
    required this.confidence,
  });
}

/// Lightweight on-device heuristic parser standing in for the AI Gateway.
/// Extracts amount, currency, a best-guess category, and merchant from a
/// natural-language sentence like "Lunch with Sarah at Blue Bottle for 23 dollars".
class TransactionParser {
  static ParsedTransaction parse(String text, {required String defaultCurrency}) {
    final lower = text.toLowerCase();

    // --- amount ---
    double amount = 0;
    // "80k" style
    final kMatch = RegExp(r'(\d+(?:\.\d+)?)\s*k\b').firstMatch(lower);
    final numMatch = RegExp(r'(\d+(?:[.,]\d+)?)').firstMatch(lower);
    if (kMatch != null) {
      amount = double.parse(kMatch.group(1)!) * 1000;
    } else if (numMatch != null) {
      amount = double.parse(numMatch.group(1)!.replaceAll(',', '.'));
    }
    // spelled numbers (common small values)
    const words = {
      'twenty three': 23, 'twenty': 20, 'thirty': 30, 'forty': 40,
      'fifty': 50, 'hundred': 100, 'ten': 10, 'fifteen': 15,
    };
    for (final e in words.entries) {
      if (lower.contains(e.key) && amount == 0) amount = e.value.toDouble();
    }

    // --- currency ---
    String currency = defaultCurrency;
    const cues = {
      'dollar': 'USD', '\$': 'USD', 'euro': 'EUR', '€': 'EUR',
      'pound': 'GBP', '£': 'GBP', 'yen': 'JPY', 'rupee': 'INR',
      'dong': 'VND', 'vnd': 'VND', 'đ': 'VND',
    };
    for (final e in cues.entries) {
      if (lower.contains(e.key)) {
        currency = e.value;
        break;
      }
    }

    // --- category (keyword match) ---
    const catCues = {
      'food': ['lunch', 'dinner', 'breakfast', 'coffee', 'restaurant', 'phở', 'pho', 'eat', 'grocery', 'groceries', 'cafe'],
      'transport': ['uber', 'taxi', 'grab', 'bus', 'train', 'gas', 'fuel', 'parking'],
      'shopping': ['zara', 'amazon', 'shop', 'store', 'clothes', 'apple'],
      'entertainment': ['movie', 'cinema', 'netflix', 'game', 'spotify', 'concert'],
      'housing': ['rent', 'electric', 'water bill', 'internet', 'utilities'],
      'health': ['pharmacy', 'doctor', 'gym', 'medicine'],
    };
    String categoryKey = 'other';
    for (final e in catCues.entries) {
      if (e.value.any(lower.contains)) {
        categoryKey = e.key;
        break;
      }
    }

    // --- merchant (after "at"/"from") ---
    String merchant = '';
    final atMatch = RegExp(r'\b(?:at|from|in)\s+([a-z0-9&\s]+?)(?:\s+for\b|\s+\d|$)')
        .firstMatch(lower);
    if (atMatch != null) {
      merchant = _titleCase(atMatch.group(1)!.trim());
    }
    if (merchant.isEmpty) {
      merchant = CategoryCatalog.meta(categoryKey).label;
    }

    // --- confidence ---
    double confidence = 0.6;
    if (amount > 0) confidence += 0.2;
    if (categoryKey != 'other') confidence += 0.12;
    if (cues.keys.any(lower.contains)) confidence += 0.08;
    confidence = confidence.clamp(0.0, 0.98);

    // validate currency is known
    final known = CurrencyInfo.all.any((c) => c.code == currency);
    if (!known) currency = defaultCurrency;

    return ParsedTransaction(
      amount: amount,
      currency: currency,
      categoryKey: categoryKey,
      merchant: merchant,
      confidence: confidence,
    );
  }

  static String _titleCase(String s) => s
      .split(' ')
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');
}
