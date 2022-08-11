import 'package:decimal/decimal.dart';

class CoinMarkets {
  late Decimal marketCap;
  late Decimal totalVolume;
  late List<SparklineEntity> sparkline;
  CoinMarkets(this.marketCap, this.totalVolume, this.sparkline);
  CoinMarkets.fromJson(Map<String, dynamic> json) {
    marketCap = Decimal.parse("${json['market_caps'].last.last}");
    totalVolume = Decimal.parse("${json['total_volumes'].last.last}");
    sparkline = [for (var price in json['prices']) SparklineEntity(DateTime.fromMillisecondsSinceEpoch(price.first), Decimal.parse('${price.last}'))];
  }
}

class SparklineEntity {
  DateTime date;
  Decimal value;
  SparklineEntity(this.date, this.value);
}
