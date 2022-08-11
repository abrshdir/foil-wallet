import 'dart:convert';
import 'dart:developer';

import 'package:binance_chain/binance_chain.dart';
import 'package:http/http.dart' as http;

class ApiResponse<T> {
  late T load;
  late bool ok;
  late int statusCode;
  String? errorMessage;

  ApiResponse(this.statusCode, this.load, [bool? isOk]) {
    this.ok = isOk ?? statusCode == 200;
  }

  ApiResponse.fromBC(APIResponse<T> bcresp) {
    if (bcresp.load != null) {
      load = bcresp.load!;
    } else {
      errorMessage = bcresp.error?.message;
    }
    statusCode = bcresp.statusCode!;
    ok = bcresp.ok ?? statusCode == 200;
  }
}

class RequestResult {
  dynamic json;
  int? statusCode;
  RequestResult(this.json, this.statusCode);
}

abstract class ApiBase {
  late String endpoint;

  final httpClient = http.Client();

  Future<RequestResult> request({
    required String method,
    required String path,
    required Map<String, String> headers,
    dynamic body,
    bool customPath = false,
  }) async {
    //APIStatus connStatus = await checkConnection();
    //if (connStatus == APIStatus.ConnectionReady) {
    var url = customPath ? Uri.parse(path) : createFullPath(path);
    http.Response? resp;
    Map<String, dynamic> decodedJson;
    try {
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

      decodedJson = Map.from(<String, dynamic>{});
    }
    return RequestResult(decodedJson, resp?.statusCode);
  }

  Uri createFullPath(String path) {
    return Uri.parse('$endpoint$path');
  }

  Future<RequestResult> post(String path,
      {Map<String, String> headers = const {},
      dynamic body = '',
      bool customPath = false}) async {
    headers = Map<String, String>.from(headers);
    headers['Content-Type'] = 'Application/json; charset=utf-8';
    return request(
        method: 'post',
        path: path,
        headers: headers,
        body: body,
        customPath: customPath);
  }

  Future<RequestResult> get(String path,
      {Map<String, String> headers = const {}, bool customPath = false}) async {
    return request(
        method: 'get', path: path, headers: headers, customPath: customPath);
  }
}

enum APIStatus {
  Success,
  ConnectionReady,
  TransferError,
  AuthError,
  ServerError,
  ConnectionError,
  ServerConnectionError,
  UnexpectedError,
  EmptyAccount
}

Map<int, APIStatus> statusCodes = {
  200: APIStatus.Success,
  401: APIStatus.AuthError,
  500: APIStatus.ServerError,
  0: APIStatus.UnexpectedError
};

class ApiNfcResponse<DataModel_T> extends APIResponse<DataModel_T> {
  late APIStatus? status;
  ApiNfcResponse(int statusCode, DataModel_T load, {required APIStatus? status})
      : super(statusCode, load) {
    status = (status ?? statusCodes[statusCode])!;
  }

  @override
  ApiNfcResponse.fromOther(ApiNfcResponse other)
      : super(other.statusCode, other.load) {
    status = (other.status ?? statusCodes[other.statusCode])!;
  }

  ApiNfcResponse.fromOther_(APIResponse other) : super.fromOther(other) {
    status = statusCodes[statusCode] ?? statusCodes[0];
  }
}
