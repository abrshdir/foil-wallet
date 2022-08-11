import 'package:voola/core/api/ApiBase.dart';

import 'package:voola/core/api/coingecko/model/CoinMarkets.dart';
import 'package:voola/core/api/coingecko/model/SimplePrice.dart';

class CoingeckoApi extends ApiBase {
  CoingeckoApi() {
    //endpoint = 'https://api.coingecko.com/api/';
    endpoint = 'https://asia.tbcc.com/api/tickers/api/';
  }

  Future<ApiResponse<Map<String, SimplePrice>>> loadTickers({
    required List<String> ids,
    required List<String> vsCurrencies,
    bool includeMarketCap = false,
    bool include24hvol = false,
    bool include24hchange = false,
    bool includeLastUpdatedAt = false,
  }) async {
    vsCurrencies = vsCurrencies.map((e) => e.toLowerCase()).toList();
    var result = await get(
        "https://asia.tbcc.com/api/tickers/api/v3/simple/price?ids=${ids.join(',')}"
        "&vs_currencies=${vsCurrencies.join(',')}"
        "&include_market_cap=$includeMarketCap"
        "&include_24hr_vol=$include24hvol"
        "&include_24hr_change=$include24hchange"
        "&include_last_updated_at=$includeLastUpdatedAt",
        customPath: true);
    var load = <String, SimplePrice>{
      for (var id in ids)
        id: SimplePrice.fromJson(result.json[id] ?? {}, vsCurrencies.first)
    };

    return ApiResponse(result.statusCode ?? -1, load);
  }

  Future<ApiResponse<CoinMarkets>> loadCoinMarkets(
      String id, String vsCurrency, int days, String interval) async {
    var load;
    var result;
    try {
      result = await get(
          "https://api.coingecko.com/api/"
          "v3/coins/$id/market_chart"
          "?vs_currency=${vsCurrency.toLowerCase()}"
          "&days=$days"
          "&interval=$interval",
          customPath: true);
      load = CoinMarkets.fromJson(result.json);
    } catch (e) {
      result = await get(
          "https://coingecko.tbcc.com/api/"
          "v3/coins/$id/market_chart"
          "?vs_currency=${vsCurrency.toLowerCase()}"
          "&days=$days"
          "&interval=$interval",
          customPath: true);
      load = CoinMarkets.fromJson(result.json);
    }
    return ApiResponse(result.statusCode ?? -1, load);
  }
}
