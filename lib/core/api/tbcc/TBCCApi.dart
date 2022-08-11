import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;

import 'package:pointycastle/digests/sha1.dart';

import 'package:voola/core/api/ApiBase.dart';
import 'package:voola/core/settings/AppSettings.dart';
import 'package:voola/core/settings/UserSettings.dart';
import 'package:voola/locator.dart';

import 'models/Config.dart';
import 'models/News.dart';
import 'models/TBCCUser.dart';
import 'models/Update.dart';
import 'models/VPNKey.dart';
import 'models/WhatsNew.dart';

class TBCCApi extends ApiBase {
  final _authDigest = SHA1Digest();
  final _authSalt = '6gMmTP6HyRDZT7qnegAu';

  TBCCApi() {
    this.endpoint = 'https://asia.tbcc.com/api/v2/';
    //this.endpoint = 'https://asia.tbcc.com/testbackend/';
  }

  Future<ApiNfcResponse<bool>> checkOrderedCard_multiaddr(
      List<String> addresses, String address) async {
    var resp = await get("user/$address/check/ordered_card_multiaddr",
        headers: {'x-addresses': json.encode(addresses)}, address: address);
    return ApiNfcResponse.fromOther(resp.json);
  }

  Future<ApiResponse<InnerUpdate>> getInnerUpdateInfo(
      {bool debug = false}) async {
    var result = await get('inner_update',
        headers: {'x-package-name': 'com.wirelessenergy.voola'}, sign: false);
    var load = InnerUpdate.fromJson(result.json);
    return ApiResponse(result.statusCode ?? -1, load);
  }

  Future<ApiResponse<TBCCUserModel>> getUser(String address) async {
    var result = await get('user/$address', address: address);
    if (result.statusCode == 200) {
      var load = TBCCUserModel.fromJson(result.json);

      return ApiResponse(200, load);
    } else {
      newClient(address);
      return ApiResponse(200, TBCCUserModel(address: address));
    }
  }

  Future<RequestResult> _request(String method, String path,
      {required Map<String, String> headers,
      dynamic body,
      String? address,
      bool sign = true,
      bool customPath = false}) async {
    //APIStatus connStatus = await checkConnection();
    //if (connStatus == APIStatus.ConnectionReady) {
    var url = customPath ? Uri.parse(path) : createFullPath(path);
    http.Response? resp;
    dynamic decodedJson;
    try {
      if (sign) {
        var hash = hex.encode(_authDigest
            .process(Uint8List.fromList(utf8.encode(address! + _authSalt))));
        headers = Map<String, String>.from(headers);
        headers['x-authorization'] = hash;
      }
      switch (method) {
        case 'post':
          resp = await httpClient.post(url,
              headers: headers, body: json.encode(body));
          break;
        case 'get':
          resp = await httpClient.get(url, headers: headers);
          break;
      }

      decodedJson = json.decode(resp!.body);
    } catch (e, st) {
      log("""HTTP Request error: 
            statusCode: ${resp?.statusCode}
            body: ${resp?.body}
            exception: $e
            stackTrace: $st
            """);

      decodedJson = <String, dynamic>{};
    }
    return RequestResult(decodedJson, resp?.statusCode);
  }

  // Future<ApiResponse<bool>> checkOrderedCard_multiaddr(
  //     List<String> addresses, String address) async {
  //   var resp = await get("user/$address/check/ordered_card_multiaddr",
  //       headers: {'x-addresses': json.encode(addresses)}, address: address);
  //   resp.load = resp.load == true;
  //   return ApiResponse.fromBC(resp);
  // }

  Future<RequestResult> post(String path,
      {Map<String, String> headers = const {},
      dynamic body = '',
      bool customPath = false,
      bool sign = true,
      String? address}) async {
    headers = Map<String, String>.from(headers);
    headers['Content-Type'] = 'Application/json; charset=utf-8';
    return _request('post', path,
        headers: headers,
        body: body,
        sign: sign,
        address: address,
        customPath: customPath);
  }

  Future<RequestResult> get(String path,
      {Map<String, String> headers = const {},
      dynamic body = '',
      bool customPath = false,
      bool sign = true,
      String? address}) async {
    return _request('get', path,
        headers: headers, sign: sign, address: address, customPath: customPath);
  }

  Future<ApiResponse<WhatsNew>> whatsNewLastVer(String lang) async {
    var result = await get('whats_new',
        headers: {
          'x-lang': 'ru',
          'x-version': '${locator<UserSettings>().update.actualVersion}'
        },
        sign: false);
    var load = WhatsNew.fromJson(result.json);
    return ApiResponse(result.statusCode ?? -1, load);
  }

  Future<ApiResponse<List<TBCCUserModel>>> getUsers(
      List<String> addresses) async {
    var result = await get('get_users',
        headers: {'x-addresses': addresses.join('_')}, sign: false);
    var json_;
    try {
      json_ = result.json as List<dynamic>;
    } catch (e) {
      json_ = [];
    }
    var load = [for (var user in json_) TBCCUserModel.fromJson(user)];

    return ApiResponse(200, load);
  }

  Future<ApiResponse<dynamic>> newClient(String address) async {
    var resp = await post('user/$address', address: address);

    return ApiResponse(resp.statusCode ?? -1, resp.json);
  }

  Future<ApiResponse<AppSettings>> loadAppSettings() async {
    var result = await get('app_settings', sign: false);
    var load;
    try {
      load = AppSettings.fromJson(result.json);
    } catch (e) {
      load = AppSettings.fromJson({});
    }
    return ApiResponse(result.statusCode ?? -1, load);
  }

  Future<ApiResponse<Config>> loadConfigs() async {
    var result = await get('config', sign: false);
    var load;
    try {
      load = Config.fromJson(result.json);
    } catch (e) {
      load = Config.fromJson({});
    }
    return ApiResponse(result.statusCode ?? -1, load);
  }

  Future<void> sendFirstRun(String version) async {
    await post('first_run', body: {'version': version}, sign: false);
  }

  Future<ApiResponse<List<NewsModel>>> loadNews(String locale) async {
    var result = await get('get_news/$locale', sign: false);
    var load;
    try {
      load = [for (var n in result.json['news']) NewsModel.fromJson(n)];
    } catch (e) {
      load = NewsModel.fromJson({});
    }
    return ApiResponse(result.statusCode ?? -1, load);
  }

  Future<ApiResponse<LotterySettings>> loadLotterySettings(
      String address) async {
    var result = await get('lottery/$address', sign: false);
    var load;
    try {
      load = LotterySettings.fromJson(result.json);
    } catch (e) {
      load = LotterySettings.fromJson({});
    }
    return ApiResponse(result.statusCode ?? -1, load);
  }

  Future<ApiResponse<VPNKey>> clientBoughtVPN(
      String address, String txHash) async {
    var result = await post("user/$address/vpn",
        body: {'txHash': txHash}, address: address);

    var load;
    try {
      load = VPNKey.fromJson(result.json);
    } catch (e) {
      load = VPNKey.fromJson({});
    }
    return ApiResponse(result.statusCode ?? -1, load);
  }
}
