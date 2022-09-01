import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:solana/solana.dart';
import 'package:voola/core/api/foil/model/KeyApi.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/core/authentication/wallets/FoilWallet.dart';

import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/QrCodeReader.dart';
import 'package:voola/ui/views/start/LoginScreen.dart';
import 'package:voola/ui/views/wallet/transactions/SuccessScreen.dart';
import 'package:flutter/services.dart';
import 'package:voola/core/authentication/UserAccount.dart';

class FOILTransferModel extends BaseViewModel {
  final accManager = locator<AccountManager>();
  final formKey1 = GlobalKey<FormState>();
  late WalletBalance balance;
  late WalletBalance foilBalance;
  late FoilWallet foilWallet;
  late UserAccount account;
  bool isValid = false;
  FOILTransferModel();
  var address;

  Future<void> init() async {
    setState(ViewState.Busy);
    totalFee = Decimal.parse('0.000005');
    setState(ViewState.Idle);
  }

  bool get enoughFOILTotal {
    if (balance.token.standard == 'Native' && balance.token.symbol == 'FOIL') {
      return (value! + totalFee! <= balance.balance);
    } else {
      return (totalFee! < foilBalance.balance);
    }
  }

  void calcTotalFee() {
    //totalFee = (Decimal.fromInt(50000) * _gasPrice!) / Decimal.fromInt(1000000000);
    totalFeeInFiat = totalFee! * foilBalance.fiatPrice;
  }

  final controllerAddress = TextEditingController();
  String? addressTo;

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

  Future<bool> isValidAddress(address) async {
    final url = 'http://185.63.191.197:9088/addresses/validate/$address';
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      isValid = responseData;
      return isValid;
    } catch (error) {
      throw false;
    }
  }

  //final controllerMemo = TextEditingController();
  Decimal? valueInFiat;
  Decimal? totalFee;
  Decimal? totalFeeInFiat;

  Decimal? maxTotal;

  /// address actions
  bool get isAddrValid {
    isValidAddress(controllerAddress.text);
    if (isValid) {
      addressTo = controllerAddress.text;

      return true;
    } else
      return false;
  }

  Future<void> pasteAddress(BuildContext context) async {
    var text = (await Clipboard.getData('text/plain'))?.text;
    isValidAddress(text!);
    if (isValid) {
      controllerAddress.text = text;
      addressTo = text;
    } else
      Flushbar.error(title: S.of(context).noValidAddrFound).show();
  }

  //Future<void> pasteMemo(BuildContext context) async {
  //  var text = (await Clipboard.getData('text/plain'))?.text;
  //  controllerMemo.text = text ?? '';
  //}

  Future<void> scanAddressQr(BuildContext context) async {
    var text = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => QRCodeReader()));
    isValidAddress(text!);
    if (isValid) {
      controllerAddress.text = text;
      addressTo = text;
    } else
      Flushbar.error(title: S.of(context).noValidAddrFound).show();
  }

  //void scanMemoQr(BuildContext context) async {
  //  var text = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => QRCodeReader()));
  //  controllerMemo.text = text;
  //}

  void setMax() async {
    value = balance.token.symbol == 'FOIL'
        ? balance.balance - totalFee!
        : balance.balance;
    controllerValue.text = value.toString();
    setState();
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
  Future<void> sendTransactionToFoil(BuildContext context) async {
    address = accManager.allAccounts[0].foilWallet.address;

    setState(ViewState.Busy);
    final url = 'http://185.63.191.197:9088/r_send/$address/'
        '$addressTo'
        '?feePow=1&assetKey=1&amount=$value'
        '&title=test&message=test&nottext=true&'
        'encrypt=false&password=1';
    if (maxTotal! > Decimal.fromInt(300)) {
      bool confirmation = await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => LoginScreen(confirmation: true),
          fullscreenDialog: true));
      if (confirmation != true) {
        return;
      }
    }
    try {

      final response = await get(Uri.parse(url));
      final responseData = json.decode(response.body);
      var signature = FoilTransactionResponse.fromJson(responseData).signature;
      // var resultTxHash = await account.foilWallet.transfer(
      //     destination: addressTo!,
      //     lamports: (value! * Decimal.fromInt(10).pow(9)).toInt());

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => TxSuccessScreen(signature.toString(),
              'http://185.63.191.197:9088/transactions/signature/$signature', null)));
    } catch (e, st) {
      print(e);
      print(st);
      Flushbar.error(title: 'Error: $e').show();
    }

    setState(ViewState.Idle);
  }

  @override
  void dispose() {
    controllerAddress.dispose();
    controllerValue.dispose();

    super.dispose();
  }
}
