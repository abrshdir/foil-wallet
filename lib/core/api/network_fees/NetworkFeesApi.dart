import 'package:decimal/decimal.dart';
import 'package:voola/core/api/ApiBase.dart';
import 'package:voola/global_env.dart';
import 'package:web3dart/web3dart.dart';

import 'model/BSCGasPrices.dart';
import 'model/EthGasPrices.dart';

class NetworkFeesApi extends ApiBase {
  NetworkFeesApi() {
    endpoint = '';
  }
  Future<ApiResponse<EthGasPrices>> getEthGasPrices() async {
    var result = await get(
        'https://ethgasstation.info/api/ethgasAPI.json?api-key=50b677638292234805e9c2d0c1872cff93db9aad5e2bea06c35e59bc8b6a',
        customPath: true);
    if (result.statusCode == 200) {
      return ApiResponse(
          result.statusCode!, EthGasPrices.fromJson(result.json));
    } else {
      var gasPriceFromNetwork = await ENVS.ETH_ENV!.getGasPrice();

      var fast = gasPriceFromNetwork.getValueInUnit(EtherUnit.gwei).toDouble();
      var avg = (fast * 0.9).toInt();
      var fastest = (fast * 1.1).toInt();

      var result = EthGasPrices()
        ..average = Decimal.parse('$avg')
        ..fast = Decimal.parse('${fast.toInt()}')
        ..fastest = Decimal.parse('$fastest');
      return ApiResponse(200, result);
    }
  }

  Future<ApiResponse<BSCGasPrices>> getBSCGasPrices() async {
    //var result = await get('https://bscgas.info/gas', customPath: true);
    //return ApiResponse(result.statusCode!, BSCGasPrices.fromJson(result.json));
    return ApiResponse(
        200,
        BSCGasPrices.fromJson({
          '': '',
          'slow': Decimal.fromInt(4),
          'standard': Decimal.fromInt(5),
          'fast': Decimal.fromInt(6),
        }));
  }
}
