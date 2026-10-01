class AppCurrency {
  final String code;
  final String name;
  final String symbol;
  final String flag;

  // How many units of this currency equal 1 INR.
  final double rateFromINR;

  const AppCurrency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
    required this.rateFromINR,
  });
}
