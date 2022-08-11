import 'package:decimal/decimal.dart';
import 'package:voola/core/token/WalletToken.dart';

class WalletBalance extends Comparable {
  late WalletToken token;
  late Decimal balance;
  late Decimal fiatBalance;
  late Decimal changePercent;
  late Decimal fiatPrice;
  WalletBalance();
  WalletBalance.empty(this.token) {
    balance = Decimal.zero;
    fiatBalance = Decimal.zero;
    changePercent = Decimal.zero;
    fiatPrice = Decimal.zero;
  }

  @override
  int compareTo(other) {
    return -balance.compareTo(other.balance);
  }

  @override
  String toString() {
    return '${token.symbol}: $balance';
  }
}
