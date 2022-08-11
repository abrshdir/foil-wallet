import 'dart:isolate';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/global_env.dart';
import 'package:voola/shared.dart';
import 'package:voola/locator.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:http/http.dart' as http;
import './InteractionUI.dart';
import 'DAppBrowserScreen.dart';

class CrossIsolatesMessage<T> {
  final SendPort sender;
  final String method;
  final int? chainId;
  final String providerUrl;
  final List<dynamic>? params;

  CrossIsolatesMessage({
    required this.sender,
    required this.chainId,
    required this.method,
    required this.providerUrl,
    this.params,
  });
}

class Web3RequestHandler {
  Web3RequestHandler(this.model) {
    providerUrls = ENVS.chainId_urlProvider!;
  }

  late DAppBrowserScreenModel model;
  late Isolate rpcIsolate;
  late ReceivePort rpcIsolateReceivePort;
  late SendPort rpcIsolateSendPort;

  late Map<int, String> providerUrls;

  var accManager = locator<AccountManager>();
  GlobalKey? screenKey;

  Future<void> init() async {
    rpcIsolateReceivePort = ReceivePort();
    rpcIsolate =
        await Isolate.spawn(_callbackFunction, rpcIsolateReceivePort.sendPort);
    rpcIsolateSendPort = await rpcIsolateReceivePort.first;
  }

  Future<RPCResponse> sendReceive(String method, List<dynamic> params) async {
    //
    // We create a temporary port to receive the answer
    //
    ReceivePort port = ReceivePort();

    //
    // We send the message to the Isolate, and also
    // tell the isolate which port to use to provide
    // any answer
    //
    rpcIsolateSendPort.send(CrossIsolatesMessage<String>(
      sender: port.sendPort,
      method: method,
      params: params,
      providerUrl: providerUrls[model.chainId]!,
      chainId: model.chainId,
    ));

    //
    // Wait for the answer and return it
    //
    var result = (await port.first) as RPCResponse;

    return result;
  }

  static void _callbackFunction(SendPort callerSendPort) {
    ReceivePort newIsolateReceivePort = ReceivePort();

    callerSendPort.send(newIsolateReceivePort.sendPort);

    newIsolateReceivePort.listen((dynamic message) async {
      CrossIsolatesMessage incomingMessage = message as CrossIsolatesMessage;
      JsonRPC jsonrpc = JsonRPC(message.providerUrl, http.Client());
      try {
        var response =
            await jsonrpc.call(incomingMessage.method, incomingMessage.params);
        incomingMessage.sender.send(response);
      } catch (e, st) {
        print(e);
        print(st);
        incomingMessage.sender.send(null);
      }
    });
  }

  Future<Map<String, dynamic>?> handleRequest(
      Map<String, dynamic> request) async {
    var type = request['type'];
    switch (type) {
      case 'api-request':
        return eth_accounts(request, 56);
      case 'web3-send-async-read-only':
        return web3_send_async_read_only(request);
      case 'history-state-changed':
        model.pageTitle = request['navState']['title'];
        model.currUrl = request['navState']['url'];
      //return {};
    }
  }

  Map<String, dynamic> eth_accounts(Map<String, dynamic> request,
      [int chainId = 1]) {
    var resp = Web3Response.fromRequest(request).toJson();
    resp['type'] = 'api-response';
    resp['method'] = 'eth_accounts';
    resp['isAllowed'] = true;

    resp['data'] = [
      accManager
          .allAccounts[model.dappScreenModel.launchScreenModel.selectedAccIndex]
          .bscWallet
          .address
          .hexEip55
    ];
    return resp;
  }

  Future<Map<String, dynamic>> web3_send_async_read_only(
      Map<String, dynamic> request) async {
    var method = request['payload']['method'];
    switch (method) {
      case 'eth_accounts':
        return eth_accounts(request);

      case 'eth_requestAccounts':
        return eth_accounts(request);

      case 'eth_sendTransaction':
        return eth_sendTransaction(request);
      default:
        var resp = Web3Response.fromRequest(request).toJson();
        resp['type'] = 'web3-send-async-callback';
        resp['result'] = {
          'id': request['id'],
          'jsonrpc': '2.0',
          'result': await rawRPCRequest(request)
        };
        return resp;
    }
  }

  Future<Map<String, dynamic>> eth_sendTransaction(
      Map<String, dynamic> request) async {
    Widget Function(BuildContext) builder;
    var data = request['payload']['params'].first['data'] as String?;

    if (data != null && data.isNotEmpty == true) {
      var methodNameHash = data.substring(0, 10);
      if (methodNameHash == '0x095ea7b3') {
        builder = (c) =>
            DAppApproveScreen(request['payload']['params'][0], model.chainId!);
      } else {
        builder = (c) => DAppTransactionScreen(
            request['payload']['params'][0], model.chainId!);
      }
    } else {
      builder = (c) => DAppTransactionScreen(
          request['payload']['params'][0], model.chainId!);
    }

    var result = await showModalBottomSheet<String>(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        enableDrag: false,
        //isScrollControlled: true,
        context: model.context,
        builder: builder);

    var resp = Web3Response.fromRequest(request).toJson();
    resp['type'] = 'web3-send-async-callback';
    print('dialog result :$result');
    if (result?.isNotEmpty != true || result == 'canceled')
      resp['error'] = Web3ErrorResponse(code: 4001, data: 'Canceled');
    //else if (result.startsWith('0x')) resp['result'] = result;
    resp['result'] = {'id': request['id'], 'jsonrpc': '2.0', 'result': result};
    return resp;
  }

  Future<String> rawRPCRequest(Map<String, dynamic> request) async {
    return (await sendReceive(
            request['payload']['method'], request['payload']['params']))
        .result;
  }
}

class Web3Response {
  int? messageId;
  String? type;
  String? permission;
  String? method;
  String? data;
  Web3Response({
    this.messageId,
    this.type,
    this.permission,
    this.method,
    this.data,
  });

  Web3Response.fromRequest(Map<String, dynamic> request) {
    messageId = request['messageId'];
    permission = request['permission'];
    var payload = request['payload'];
    if (payload != null) {
      method = payload['method'];
    }
  }

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'type': type,
        'permission': permission,
        'method': method,
        'data': data,
      };
}

class Web3ErrorResponse {
  int code;
  String data;
  Web3ErrorResponse({required this.code, required this.data});
  Map<String, dynamic> toJson() => {'code': code, 'data': data};
}
