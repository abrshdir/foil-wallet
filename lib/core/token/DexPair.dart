import 'package:decimal/decimal.dart';

import 'WalletToken.dart';

class DexMarketPair {
  WalletToken left;
  WalletToken right;
  Decimal lotSize;
  Decimal tickSize;

  DexMarketPair(this.left, this.right, this.lotSize, this.tickSize);

  String get symbol => '${left.symbol}_${right.symbol}';

  bool operator ==(dynamic other) {
    bool nameMatch = other?.left?.symbol == this.left.symbol;
    bool standardMatch = other?.left?.standard == this.left.standard;
    return nameMatch && standardMatch;
  }
}
