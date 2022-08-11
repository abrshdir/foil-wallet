import 'package:binance_chain/binance_chain.dart';
import 'package:decimal/decimal.dart';
import 'package:voola/core/api/APIBase.dart';
import 'package:voola/core/authentication/wallets/BinanceChainWallet.dart';
import 'package:voola/global_env.dart';

class BinanceChainApi {
  late HttpApiClient _bclient;

  BinanceChainApi() : _bclient = ENVS.BC_ENV!;

  Future<ApiResponse<MarketDepth>> getOrderBook(String symbol) async {
    return ApiResponse.fromBC(await _bclient.getOrderBook(symbol));
  }

  Future<ApiResponse<List<Candlestick>>> getCandlestickBarsMini(String symbol,
      {CandlestickInterval interval = CandlestickInterval.INTERVAL_1h}) async {
    return ApiResponse.fromBC(await _bclient.getCandlestickBarsMini(
        symbol: symbol, interval: interval));
  }

  Future<ApiResponse<List<Candlestick>>> getCandlestickBars(String symbol,
      {CandlestickInterval interval = CandlestickInterval.INTERVAL_1h}) async {
    return ApiResponse.fromBC(
        await _bclient.getCandlestickBars(symbol: symbol, interval: interval));
  }

  Future<ApiResponse<Account>> getAccount(String address) async {
    var resp;

    try {
      resp = await _bclient.getAccount(address);
    } catch (e) {
      resp = ApiResponse(200, null);

      return resp;
    }

    return ApiResponse.fromBC(resp);
  }

  Future<ApiResponse<TxPage>> getTransactions(
      String address, String symbol) async {
    var resp = await _bclient.getTransactions(
        address: address,
        startTime:
            DateTime.now().subtract(Duration(days: 85)).millisecondsSinceEpoch,
        txAsset: symbol);
    return ApiResponse.fromBC(resp);
  }

  Future<ApiResponse<Transaction>> getSingleTransaction(String txHash) async {
    var resp = await _bclient.getSingleTransaction(txHash);
    return ApiResponse.fromBC(resp);
  }

  Future<ApiResponse<List<Transaction>>> sendToken(BCWallet wallet,
      String toAddress, String symbol, Decimal amount, String memo,
      {bool sync = false}) async {
    var transfer = TransferMsg(
      wallet: wallet,
      symbol: symbol,
      to_address: toAddress,
      amount: amount,
      memo: memo,
    );

    return broadcastMsg(transfer, sync: sync);
  }

  Future<ApiResponse<List<Transaction>>> broadcastMsg(Msg msg,
      {bool sync = false}) async {
    var resp = await _bclient.broadcastMsg(msg, sync: sync);
    if (resp.error?.message?.contains('sequence') == true) {
      await msg.wallet!.reload_account_sequence();
      resp = await _bclient.broadcastMsg(msg, sync: sync);
      return ApiResponse.fromBC(resp);
    } else {
      return ApiResponse.fromBC(resp);
    }
  }

  Future<ApiResponse<OrderList>> getOpenOrdersMini(String address) async {
    var resp = await _bclient.getOpenOrdersMini(address: address);
    return ApiResponse.fromBC(resp);
  }

  Future<ApiResponse<OrderList>> getOpenOrders(String address) async {
    var resp = await _bclient.getOpenOrders(address: address);
    return ApiResponse.fromBC(resp);
  }

  Future<ApiResponse<OrderList>> getClosedOrdersMini(String address) async {
    var resp = await _bclient.getClosedOrdersMini(address: address);
    return ApiResponse.fromBC(resp);
  }

  Future<ApiResponse<OrderList>> getClosedOrders(String address) async {
    var resp = await _bclient.getClosedOrders(address: address);
    return ApiResponse.fromBC(resp);
  }

  Future<ApiResponse<List<Transaction>>> placeOrder(NewOrderMsg order) async {
    await order.wallet!.reload_account_sequence();

    return broadcastMsg(order, sync: true);
  }

  Future<ApiResponse<List<Transaction>>> cancelOrder(
      CancelOrderMsg order) async {
    await order.wallet!.reload_account_sequence();

    var resp = await _bclient.broadcastMsg(order, sync: true);
    return ApiResponse.fromBC(resp);
  }

  Future<ApiResponse<List<TickerStatistics>>> getTickers(
      {String? symbol}) async {
    var resp = await _bclient.getTickerStats24hr(symbol: symbol);

    return ApiResponse.fromBC(resp);
  }

  Future<ApiResponse<List<TickerStatistics>>> getMiniTickers(
      {String? symbol}) async {
    var resp = await _bclient.getMiniTickerStats24hr(symbol: symbol);

    return ApiResponse.fromBC(resp);
  }
}
