import 'package:decimal/decimal.dart';

class EthGasPrices {
  Decimal? fast;
  Decimal? fastest;
  Decimal? safeLow;
  Decimal? average;
  Decimal? blockTime;
  Decimal? blockNum;
  Decimal? speed;
  Decimal? safeLowWait;
  Decimal? avgWait;
  Decimal? fastWait;
  Decimal? fastestWait;

  EthGasPrices({this.fast, this.fastest, this.safeLow, this.average, this.blockTime, this.blockNum, this.speed, this.safeLowWait, this.avgWait, this.fastWait, this.fastestWait});

  EthGasPrices.fromJson(Map<String, dynamic> json) {
    fast = Decimal.parse('${json['fast']}') ~/ Decimal.fromInt(10);
    fastest = Decimal.parse('${json['fastest']}') ~/ Decimal.fromInt(10);
    safeLow = Decimal.parse('${json['safeLow']}') ~/ Decimal.fromInt(10);
    average = Decimal.parse('${json['average']}') ~/ Decimal.fromInt(10);
    blockTime = Decimal.parse('${json['block_time']}') ~/ Decimal.fromInt(10);
    blockNum = Decimal.parse('${json['blockNum']}') ~/ Decimal.fromInt(10);
    speed = Decimal.parse('${json['speed']}') ~/ Decimal.fromInt(10);
    safeLowWait = Decimal.parse('${json['safeLowWait']}') ~/ Decimal.fromInt(10);
    avgWait = Decimal.parse('${json['avgWait']}') ~/ Decimal.fromInt(10);
    fastWait = Decimal.parse('${json['fastWait']}') ~/ Decimal.fromInt(10);
    fastestWait = Decimal.parse('${json['fastestWait']}') ~/ Decimal.fromInt(10);
  }
}
