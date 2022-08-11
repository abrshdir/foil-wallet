import 'package:decimal/decimal.dart';

class SimplePrice {
  Decimal? inCurrency;
  Decimal? marketCap;
  Decimal? volume;
  Decimal? priceChange;
  int? lastUpdatedAt;
  SimplePrice();
  SimplePrice.zero() {
    inCurrency = Decimal.zero;
    marketCap = Decimal.zero;
    volume = Decimal.zero;
    priceChange = Decimal.zero;
    lastUpdatedAt = 0;
  }
  SimplePrice.fromJson(Map<String, dynamic> json, String curr) {
    inCurrency = Decimal.tryParse(json['$curr'].toString());
    marketCap = Decimal.tryParse(json['${curr}_market_cap'].toString());
    volume = Decimal.tryParse(json['${curr}_24h_vol'].toString());
    priceChange = Decimal.tryParse(json['${curr}_24h_change'].toString());
    lastUpdatedAt = json['last_updated_at'];
  }
}
