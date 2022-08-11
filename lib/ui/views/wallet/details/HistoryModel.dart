import 'dart:convert';

import 'package:voola/core/api/binance_chain/BCApi.dart';
import 'package:voola/core/api/bsc/BSCApi.dart';
import 'package:voola/core/api/ethereum/ETHApi.dart';
import 'package:voola/core/authentication/AuthService.dart';

import 'package:voola/core/token/utils.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:solana/src/rpc_client/transaction_signature.dart';
import 'WalletDetails.dart';

class TxHistoryModel extends BaseViewModel {
  List<Widget>? transactionsListWidgets;
  final authService = locator<AuthService>();
  late List<HistoryTransaction> txs;

  Future<void> loadHistory(
      WalletToken token, BuildContext context, int accIndex) async {
    setState(ViewState.Busy);
    var acc = authService.accManager.allAccounts[accIndex];
    txs = [];
    if (token.network == TokenNetwork.BinanceChain) {
      var address = acc.bcWallet.address;
      var apiResp = await locator<BinanceChainApi>().getTransactions(
        address!,
        token.symbol,
        //startTime: (DateTime.now().subtract(Duration(days: 60)).millisecondsSinceEpoch),
      );
      for (var tx in apiResp.load.tx!) {
        if (tx.txType == 'TRANSFER') {
          var txInfo = HistoryTransaction()
            ..blockchain = Blockchain.BC
            ..type = TransactionType.BinanceTransfer
            ..side = address == tx.toAddr
            ..txHash = tx.txHash
            ..from = tx.fromAddr
            ..to = tx.toAddr
            ..value = Decimal.parse(tx.value!)
            ..symbol = token.symbol
            ..fee = Decimal.parse(tx.txFee!)
            ..feeSymbol = 'BNB'
            ..timestamp = DateTime.parse(tx.timeStamp!).toLocal()
            ..description = tx.memo;

          txs.add(txInfo);
        }
      }
    } else if (token.network == TokenNetwork.Ethereum) {
      var address = acc.ethWallet.address.hex;
      var apiResp = await locator<ETHApi>().getEthTransactions(
          token.standard == 'ERC20' ? token.ethAddress?.hex : null,
          address,
          token.decimals ?? 18);
      for (var tx in apiResp.load) {
        var txInfo = HistoryTransaction()
          ..blockchain = Blockchain.Eth
          ..type = token.standard == 'Native'
              ? tx.gasUsed == Decimal.fromInt(21000)
                  ? TransactionType.ETH_Transfer
                  : TransactionType.ETH_ContractCall
              : TransactionType.ETH_Transfer
          ..side = address == tx.to
          ..txHash = tx.hash
          ..from = tx.from
          ..to = tx.to
          ..value = tx.value
          ..symbol = token.symbol
          ..eth_info = (EthTransactionInfo()
            ..confirmations = int.tryParse(tx.confirmations ?? '')
            ..gasPrice = tx.gasPrice
            ..maxGas = tx.gas
            ..gasUsed = tx.gasUsed
            ..nonce = tx.nonce)
          ..fee = tx.gasPrice! * tx.gasUsed!
          ..feeSymbol = 'ETH'
          ..timestamp = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(tx.timeStamp!) * 1000)
              .toLocal();

        txs.add(txInfo);
      }
    } else if (token.network == TokenNetwork.BinanceSmartChain) {
      var address = acc.bscWallet.address.hex;
      var apiResp = await locator<BSCApi>().getBSCTransactions(
          token.standard == 'BEP20' ? token.ethAddress?.hex : null,
          address,
          token.decimals ?? 18);
      for (var tx in apiResp.load) {
        var txInfo = HistoryTransaction()
          ..blockchain = Blockchain.BSC
          ..type = token.standard == 'Native'
              ? tx.gasUsed == Decimal.fromInt(21000)
                  ? TransactionType.ETH_Transfer
                  : TransactionType.ETH_ContractCall
              : TransactionType.ETH_Transfer
          ..side = address == tx.to
          ..txHash = tx.hash
          ..from = tx.from
          ..to = tx.to
          ..value = tx.value
          ..symbol = token.symbol
          ..eth_info = (EthTransactionInfo()
            ..confirmations = int.tryParse(tx.confirmations ?? '')
            ..gasPrice = tx.gasPrice
            ..maxGas = tx.gas
            ..gasUsed = tx.gasUsed
            ..nonce = tx.nonce)
          ..fee = tx.gasPrice! * tx.gasUsed!
          ..feeSymbol = 'BNB'
          ..timestamp = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(tx.timeStamp!) * 1000)
              .toLocal();

        txs.add(txInfo);
      }
    } else if (token.network == TokenNetwork.Solana) {
      //var address = acc.solWallet.address;
      //var signatures = await ENVS.SOL_ENV!.client.request('getSignaturesForAddress', params: [address]);
      //var ts = [for (var s in signatures['result']) TransactionSignature(s['signature'])];
      //print(ts);
      //var apiResp = await ENVS.SOL_ENV!.getSignatureStatuses(ts, searchTransactionHistory: true);
      //print(apiResp);
    }
    prepareWidgets(context, token);
    setState(ViewState.Idle);
  }

  void prepareWidgets(BuildContext context, WalletToken token) {
    transactionsListWidgets = [];
    int lastYear = -1;
    int lastMonth = -1;
    int lastDay = -1;

    for (var t in txs) {
      var dt = t.timestamp!;
      if (dt.day == lastDay && dt.month == lastMonth && dt.year == lastYear) {
        transactionsListWidgets?.add(HistoryTile(t, token));
      } else {
        lastDay = dt.day;
        lastMonth = dt.month;
        lastYear = dt.year;
        transactionsListWidgets?.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 5),
              child: Text(
                dt.toStringDMY(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            HistoryTile(t, token)
          ],
        ));
      }
    }
  }
}

class HistoryTransaction {
  Blockchain? blockchain;
  String? from;
  String? to;
  String? symbol;
  String? txHash;
  DateTime? timestamp;
  bool? side;
  EthTransactionInfo? eth_info;
  TransactionType? type;
  Decimal? value;
  Decimal? fee;
  String? feeSymbol;
  String? description;
}

enum TransactionType {
  BinanceOrder,
  BinanceTransfer,
  ETH_Transfer,
  ETH_ContractCall,
  BinanceOther
}
enum Blockchain { BC, Eth, BSC }

class EthTransactionInfo {
  int? confirmations;
  Decimal? maxGas;
  Decimal? gasUsed;
  Decimal? gasPrice;
  String? nonce;
}

class BCOrderData {
  String? orderId;
  String? orderType;
  String? price;
  String? quantity;
  String? side;
  String? symbol;
  String? timeInForce;

  BCOrderData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderType = json['orderType'];
    price = json['price'];
    quantity = json['quantity'];
    side = json['side'];
    symbol = json['symbol'];
    timeInForce = json['timeInForce'];
  }
}
