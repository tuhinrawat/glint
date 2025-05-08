import 'package:shared_preferences/shared_preferences.dart';

enum Currency {
  INR,
  USD,
  EUR,
  GBP,
  AUD
}

class CurrencyService {
  static const String _currencyKey = 'selected_currency';
  static Currency _currentCurrency = Currency.INR;
  
  // Exchange rates against INR (to be updated from an API in production)
  static final Map<Currency, double> _exchangeRates = {
    Currency.INR: 1.0,
    Currency.USD: 0.012, // 1 INR = 0.012 USD
    Currency.EUR: 0.011,
    Currency.GBP: 0.0095,
    Currency.AUD: 0.018,
  };

  static final Map<Currency, String> currencySymbols = {
    Currency.INR: '₹',
    Currency.USD: '\$',
    Currency.EUR: '€',
    Currency.GBP: '£',
    Currency.AUD: 'A\$',
  };

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCurrency = prefs.getString(_currencyKey);
    if (savedCurrency != null) {
      _currentCurrency = Currency.values.firstWhere(
        (c) => c.toString() == savedCurrency,
        orElse: () => Currency.INR,
      );
    }
  }

  static Future<void> setCurrency(Currency currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency.toString());
    _currentCurrency = currency;
  }

  static Currency get currentCurrency => _currentCurrency;
  
  static String get currencySymbol => currencySymbols[_currentCurrency] ?? '₹';

  static double convert(double amount, {Currency? from, Currency? to}) {
    from ??= Currency.INR;
    to ??= _currentCurrency;
    
    if (from == to) return amount;
    
    // Convert to INR first if needed
    double amountInINR = from == Currency.INR 
        ? amount 
        : amount / _exchangeRates[from]!;
    
    // Convert from INR to target currency
    return amountInINR * _exchangeRates[to]!;
  }

  static String formatAmount(num amount, {Currency? from}) {
    double convertedAmount;
    if (from != null) {
      convertedAmount = convert(amount.toDouble(), from: from);
    } else {
      convertedAmount = amount * _exchangeRates[_currentCurrency]!;
    }
    return '${currencySymbols[_currentCurrency]}${convertedAmount.toStringAsFixed(2)}';
  }
} 