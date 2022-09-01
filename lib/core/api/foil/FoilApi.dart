import 'package:voola/core/api/ApiBase.dart';
import 'package:voola/core/api/foil/model/KeyApi.dart';

class FoilApi extends ApiBase {

  FoilApi() {
    endpoint = 'https://dobalancer.foil.network:9087/api/tx/listbyaddress';
  }

  Future getFoilTransactions(String address) async {

    var path = '$endpoint/$address?noforge';
    var result = await get(path, customPath: true);

    try {
      return ApiResponse(
        result.statusCode!,
        [
          for (var i in result.json)
            FoilTransactionResponse.fromJson(i)
        ],
      );
      // print(result.json[0].runtimeType);
      // return FoilTransactionResponse.fromJson(result.json[0]);
    } catch (e, st) {
      print("$e, $st");
    }
  }

}