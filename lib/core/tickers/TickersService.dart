import 'package:binance_chain/binance_chain.dart';
import 'package:voola/core/api/binance_chain/BCApi.dart';
import 'package:voola/locator.dart';

import '../api/coingecko/CoingeckoAPI.dart';
import '../api/coingecko/model/SimplePrice.dart';

class TickersService {
  //final _coingeckoApi = locator.isRegistered<CoingeckoApi>() ? locator<CoingeckoApi>() : CoingeckoApi();
  //final _bcApi = locator.isRegistered<BinanceChainApi>() ? locator<BinanceChainApi>() : BinanceChainApi();
  var _coingeckoApi = CoingeckoApi();
  var _bcApi = BinanceChainApi();

  Map<String, SimplePrice>? simpleTickers;

  Map<String, TickerStatistics>? bcDexTickers;

  Future<void> loadSimpleTickers(List<String> ids, String fiatCurr) async {
    simpleTickers = (await _coingeckoApi.loadTickers(
            ids: ids..removeWhere((element) => element == '-1'),
            include24hchange: true,
            include24hvol: true,
            vsCurrencies: [fiatCurr]))
        .load;
  }

  Future<void> loadBCDexTickers() async {
    var resp =
        await Future.wait([_bcApi.getTickers(), _bcApi.getMiniTickers()]);
    var result = <String, TickerStatistics>{};
    for (var i in resp[0].load) {
      result[i.symbol!] = i;
    }
    for (var i in resp[1].load) {
      result[i.symbol!] = i;
    }
    bcDexTickers = result;
  }
}
