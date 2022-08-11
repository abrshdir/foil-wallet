import 'dart:typed_data';

import 'package:voola/core/api/network_fees/NetworkFeesApi.dart';
import 'package:voola/core/api/network_fees/model/BSCGasPrices.dart';
import 'package:voola/core/authentication/AccountManager.dart';

import 'package:voola/core/blockchain/binance_smart_chain/contracts/BEP20_abi.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/QrCodeReader.dart';
import 'package:voola/ui/views/start/LoginScreen.dart';
import 'package:voola/ui/views/wallet/transactions/SuccessScreen.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:voola/global_env.dart';
import 'package:flutter/services.dart';
import 'package:voola/core/authentication/UserAccount.dart';

class BSCTransferModel extends BaseViewModel {
  bool? returnedInsufficientFunds;
  final accManager = locator<AccountManager>();
  final formKey1 = GlobalKey<FormState>();
  BSCGasPrices? gasPrices;
  late Transaction bscTransaction;
  late WalletBalance balance;
  late WalletBalance bnbBalance;
  late UserAccount account;
  BSCTransferModel();

  Future<void> init() async {
    setState(ViewState.Busy);
    _nonce = await ENVS.BSC_ENV!.getTransactionCount(account.bscWallet.address);
    controllerNonce.text = '$_nonce';
    if (balance.token.symbol == 'BNB' && balance.token.standard == 'Native') {
      _maxGas = Decimal.fromInt(21000);
      bscTransaction = Transaction(
        from: account.bscWallet.address,
        maxGas: _maxGas?.toInt(),
        nonce: _nonce,
      );
    } else {
      _value = Decimal.zero;
      bscTransaction = Transaction(
        from: account.bscWallet.address,
        to: balance.token.ethAddress,
        value: EtherAmount.zero(),
        nonce: _nonce,
      );
    }
    _data = '0x';
    controllerData.text = '0x';
    setState(ViewState.Idle);
  }

  Future<void> initAdvanced() async {
    setState(ViewState.Busy);
    gasPrices = (await locator<NetworkFeesApi>().getBSCGasPrices()).load;
    _gasPrice = gasPrices?.standard;
    controllerGasPrice.text = '$_gasPrice';
    bscTransaction = bscTransaction.copyWith(
      from: account.bscWallet.address,
      gasPrice: _gasPrice!.toEtherAmount(9),
    );
    if (balance.token.symbol != 'BNB' && balance.token.standard != 'Native') {
      var encodedCallData = bep20BasicContractAbi.functions
          .firstWhere((f) => f.name == 'transfer')
          .encodeCall([
        addressTo ?? EthereumAddress.fromHex(controllerAddress.text),
        value?.toEtherAmount(balance.token.decimals ?? 18).getInWei,
      ]);
      _data = bytesToHex(encodedCallData);
      controllerData.text = '0x${_data ?? ''}';
      bscTransaction = bscTransaction.copyWith(
          to: balance.token.ethAddress, data: encodedCallData);
      try {
        var estimatedGas = await ENVS.BSC_ENV!.estimateGas(
          sender: bscTransaction.from,
          to: bscTransaction.to,
          gasPrice: bscTransaction.gasPrice,
          value: bscTransaction.value,
          data: bscTransaction.data,
        );
        bscTransaction = bscTransaction.copyWith(maxGas: estimatedGas.toInt());

        _maxGas = Decimal.parse('$estimatedGas');
      } catch (e, st) {
        print('$e, $st');
        _maxGas = Decimal.fromInt(200000);
        returnedInsufficientFunds = true;
      }
    } else {
      bscTransaction = bscTransaction.copyWith(
        to: addressTo ?? EthereumAddress.fromHex(controllerAddress.text),
        value: value?.toEtherAmount(18),
        data: () {
          if (data != null)
            return hexToBytes(data!.startsWith('0x') ? data! : '0x$data');
          else
            return Uint8List(0);
        }(),
      );
    }

    controllerMaxGas.text = '$_maxGas';
    calcTotalFee();
    maxTotal = valueInFiat! + totalFeeInFiat!;

    setState(ViewState.Idle);
  }

  bool get enoughBNBTotal {
    if (balance.token.standard == 'Native' && balance.token.symbol == 'BNB') {
      return (value! + totalFee! <= balance.balance) ||
          returnedInsufficientFunds != true;
    } else {
      return (totalFee! < bnbBalance.balance) ||
          returnedInsufficientFunds != true;
    }
  }

  void calcTotalFee() {
    totalFee =
        (Decimal.fromInt(50000) * _gasPrice!) / Decimal.fromInt(1000000000);
    totalFeeInFiat = totalFee! * bnbBalance.fiatPrice;
  }

  Decimal getTotalFee(Decimal gasPrice_) {
    return (Decimal.fromInt(50000) * gasPrice_) / Decimal.fromInt(1000000000);
  }

  final controllerAddress = TextEditingController();
  EthereumAddress? addressTo;

  final controllerValue = TextEditingController();
  Decimal? _value;
  Decimal? get value => _value;
  set value(Decimal? val) {
    if (val != null) {
      _value = val;
      valueInFiat = val * balance.fiatPrice;
      return;
    }
    _value = null;
    valueInFiat = null;
  }

  final controllerGasPrice = TextEditingController();
  Decimal? _gasPrice;
  Decimal? get gasPrice => _gasPrice;
  set gasPrice(Decimal? value) {
    _gasPrice = value;
    controllerGasPrice.text = '$_gasPrice';
    calcTotalFee();

    maxTotal = valueInFiat! + totalFeeInFiat!;

    notifyListeners();
  }

  final controllerMaxGas = TextEditingController();
  Decimal? _maxGas;
  Decimal? get maxGas => _maxGas;
  set maxGas(Decimal? value) {
    _maxGas = value;
  }

  final controllerNonce = TextEditingController();
  int? _nonce;
  int? get nonce => _nonce;

  final controllerData = TextEditingController();
  String? _data;
  String? get data => _data;
  set data(String? value) {
    _data = value;
  }

  Decimal? valueInFiat;
  Decimal? totalFee;
  Decimal? totalFeeInFiat;

  Decimal? maxTotal;

  /// address actions
  bool get isAddrValid {
    try {
      addressTo = EthereumAddress.fromHex(controllerAddress.text);
      return true;
    } catch (e) {
      addressTo = null;
      return false;
    }
  }

  Future<void> pasteAddress(BuildContext context) async {
    var text = (await Clipboard.getData('text/plain'))?.text;
    try {
      addressTo = EthereumAddress.fromHex(text!);
      controllerAddress.text = text;
    } catch (e) {
      Flushbar.error(title: S.of(context).noValidAddrFound).show();
    }
  }

  Future<void> scanAddressQr(BuildContext context) async {
    var text = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => QRCodeReader()));

    try {
      addressTo = EthereumAddress.fromHex(text!);
      controllerAddress.text = text;
    } catch (e) {
      Flushbar.error(title: S.of(context).noValidAddrFound).show();
    }
  }

  /// value actions
  bool get balanceEnough {
    _value = Decimal.tryParse(controllerValue.text);
    if (value != null) {
      if (_value! < Decimal.zero) {
        _value = null;
        return false;
      }
      return value! <= balance.balance;
    }
    return false;
  }

  void setMax() async {
    value = balance.balance;
    controllerValue.text = value.toString();
    setState();
  }

  Future<void> sendTransaction(BuildContext context) async {
    setState(ViewState.Busy);

    if (maxTotal! > Decimal.fromInt(300)) {
      bool confirmation = await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => LoginScreen(confirmation: true),
          fullscreenDialog: true));
      if (confirmation != true) {
        return;
      }
    }
    try {
      var resultTxHash = await ENVS.BSC_ENV!.sendTransaction(
          account.bscWallet.privateKey, bscTransaction,
          chainId: 56);

      /// TODO add to tx listening pool
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => TxSuccessScreen(
              resultTxHash, 'https://bscscan.com/tx/$resultTxHash', null)));
      return;
    } catch (e) {
      Flushbar.error(title: 'Error: $e').show();
    }

    setState(ViewState.Idle);
  }

  @override
  void dispose() {
    controllerAddress.dispose();
    controllerValue.dispose();
    controllerGasPrice.dispose();
    controllerMaxGas.dispose();
    controllerNonce.dispose();
    controllerData.dispose();

    super.dispose();
  }
}
