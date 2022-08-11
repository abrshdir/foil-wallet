import 'package:decimal/decimal.dart';

class BSCGasPrices {
  String? timestamp;
  Decimal? slow;
  Decimal? standard;
  Decimal? fast;
  Decimal? instant;
  Decimal? block_time;
  Decimal? last_block;

  BSCGasPrices.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    slow = json['slow'];
    standard = json['standard'];
    fast = json['fast'];
    instant = json['instant'];
    block_time = json['block_time'];
    last_block = json['last_block'];
  }
}
