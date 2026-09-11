class CurrencyInfo {
  final String code;
  final String symbol;
  final String name;
  final String flag;

  const CurrencyInfo(this.code, this.symbol, this.name, this.flag);

  static const List<CurrencyInfo> all = [
    CurrencyInfo('USD', '\$', 'US Dollar', '🇺🇸'),
    CurrencyInfo('EUR', '€', 'Euro', '🇪🇺'),
    CurrencyInfo('GBP', '£', 'British Pound', '🇬🇧'),
    CurrencyInfo('CAD', '\$', 'Canadian Dollar', '🇨🇦'),
    CurrencyInfo('AUD', '\$', 'Australian Dollar', '🇦🇺'),
    CurrencyInfo('SGD', '\$', 'Singapore Dollar', '🇸🇬'),
    CurrencyInfo('INR', '₹', 'Indian Rupee', '🇮🇳'),
    CurrencyInfo('JPY', '¥', 'Japanese Yen', '🇯🇵'),
    CurrencyInfo('VND', '₫', 'Vietnamese Dong', '🇻🇳'),
    CurrencyInfo('CNY', '¥', 'Chinese Yuan', '🇨🇳'),
  ];

  static CurrencyInfo byCode(String code) {
    return all.firstWhere(
      (c) => c.code == code,
      orElse: () => all.first,
    );
  }
}

class CountryInfo {
  final String code;
  final String name;
  final String flag;

  const CountryInfo(this.code, this.name, this.flag);

  static const List<CountryInfo> all = [
    CountryInfo('US', 'United States', '🇺🇸'),
    CountryInfo('GB', 'United Kingdom', '🇬🇧'),
    CountryInfo('CA', 'Canada', '🇨🇦'),
    CountryInfo('AU', 'Australia', '🇦🇺'),
    CountryInfo('SG', 'Singapore', '🇸🇬'),
    CountryInfo('IN', 'India', '🇮🇳'),
    CountryInfo('VN', 'Vietnam', '🇻🇳'),
    CountryInfo('JP', 'Japan', '🇯🇵'),
  ];
}
