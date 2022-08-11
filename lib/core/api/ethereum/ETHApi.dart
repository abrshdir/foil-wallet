import 'package:voola/core/api/APIBase.dart';

import 'model/TransactionInfo.dart';

class ETHApi extends ApiBase {
  final _bscscanApiToken = '6KZ43YDA8YT6EQ5UU8JARREKTVAFP4RE9F';

  ETHApi() {
    endpoint = 'https://api.etherscan.io/api';
  }

  Future<ApiResponse<List<EthTransactionInfo>>> getEthTransactions(
      String? contractAddr, String addr, int decimals) async {
    var path = contractAddr == null
        ? '$endpoint?module=account&action=txlist&address=$addr&startblock=0&endblock=99999999&sort=desc&apikey=$_bscscanApiToken'
        : '$endpoint?module=account&action=tokentx&contractaddress=$contractAddr&address=$addr&page=1&offset=100&sort=desc&apikey=$_bscscanApiToken';
    var result = await get(path, customPath: true);

    try {
      return ApiResponse(
        result.statusCode!,
        [
          for (var i in result.json['result'])
            EthTransactionInfo.fromJson(i, decimals)
        ],
      );
    } catch (e, st) {
      print('$e: $st');
      return ApiResponse(
        result.statusCode ?? -1,
        <EthTransactionInfo>[],
      );
    }
  }
}
