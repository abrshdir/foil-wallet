import 'package:voola/ui/views/wallet/WalletMainScreenModel.dart';

import 'DexPair.dart';
import 'WalletToken.dart';

class WALLET_TOKENS_CONTAINER {
  List<WalletToken> COINS = [];
  List<WalletToken> ERC20 = [];
  List<WalletToken> BEP20 = [];
  List<WalletToken> BEP2 = [];
  List<WalletToken> BEP8 = [];
  //List<WalletToken> USER = [];

  List<WalletToken> COINS_show = [];
  List<WalletToken> ERC20_show = [];
  List<WalletToken> BEP20_show = [];
  List<WalletToken> BEP2_show = [];
  List<WalletToken> BEP8_show = [];

  List<DexMarketPair> DEX_MARKET_PAIRS = [];

  List<WalletToken>? listByType(TokenFilterType type) {
    switch (type) {
      case TokenFilterType.Native:
        return COINS;
      case TokenFilterType.BEP20:
        return BEP20;
      case TokenFilterType.ERC20:
        return ERC20;
      case TokenFilterType.BEP2:
        return BEP2;
      case TokenFilterType.BEP8:
        return BEP8;

      case TokenFilterType.All:
        // TODO: Handle this case.
        break;
    }
  }

  List<WalletToken>? listByTypeShow(TokenFilterType type) {
    switch (type) {
      case TokenFilterType.Native:
        return COINS_show;
      case TokenFilterType.BEP20:
        return BEP20_show;
      case TokenFilterType.ERC20:
        return ERC20_show;
      case TokenFilterType.BEP2:
        return BEP2_show;
      case TokenFilterType.BEP8:
        return BEP8_show;

      case TokenFilterType.All:
        // TODO: Handle this case.
        break;
    }
  }

  List<WalletToken> get all => [
        ...COINS,
        ...ERC20,
        ...BEP20,
        ...BEP2,
        ...BEP8,
        //...USER,
      ];

  Map<WalletToken, List<WalletToken>> crossChainSwapTokens = {};

  WALLET_TOKENS_CONTAINER();
}
