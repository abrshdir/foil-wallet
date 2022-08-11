import 'package:voola/shared.dart';

class EthTransactionInfo {
  String? blockNumber;
  String? timeStamp;
  String? hash;
  String? nonce;
  String? blockHash;
  String? from;
  String? contractAddress;
  String? to;
  Decimal? value;
  String? tokenName;
  String? tokenSymbol;
  String? tokenDecimal;
  String? transactionIndex;
  Decimal? gas;
  Decimal? gasPrice;
  Decimal? gasUsed;
  String? cumulativeGasUsed;
  String? input;
  String? confirmations;

  bool get done => blockNumber != null;

  EthTransactionInfo(
      {this.blockNumber,
      this.timeStamp,
      this.hash,
      this.nonce,
      this.blockHash,
      this.from,
      this.contractAddress,
      this.to,
      this.value,
      this.tokenName,
      this.tokenSymbol,
      this.tokenDecimal,
      this.transactionIndex,
      this.gas,
      this.gasPrice,
      this.gasUsed,
      this.cumulativeGasUsed,
      this.input,
      this.confirmations});

  EthTransactionInfo.fromJson(Map<String, dynamic> json, int decimals) {
    blockNumber = json['blockNumber'];
    timeStamp = json['timeStamp'];
    hash = json['hash'];
    nonce = json['nonce'];
    blockHash = json['blockHash'];
    from = json['from'];
    contractAddress = json['contractAddress'];
    to = json['to'];
    value = DecimalExt.parseFromEtherAmount(json['value'], decimals);
    tokenName = json['tokenName'];
    tokenSymbol = json['tokenSymbol'];
    tokenDecimal = json['tokenDecimal'];
    transactionIndex = json['transactionIndex'];
    gas = Decimal.parse(json['gas']);
    gasPrice = DecimalExt.parseFromEtherAmount(json['gasPrice'], 18);
    gasUsed = Decimal.parse(json['gasUsed']);
    cumulativeGasUsed = json['cumulativeGasUsed'];
    input = json['input'];
    confirmations = json['confirmations'];
  }
}
