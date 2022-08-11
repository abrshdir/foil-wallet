import 'package:solana/solana.dart' as sol;
import 'package:voola/core/authentication/AccountManager.dart';

import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/QrCodeReader.dart';
import 'package:voola/ui/views/start/LoginScreen.dart';
import 'package:voola/ui/views/wallet/transactions/SuccessScreen.dart';
import 'package:voola/global_env.dart';
import 'package:flutter/services.dart';
import 'package:voola/core/authentication/UserAccount.dart';

class SOLTransferModel extends BaseViewModel {
  final accManager = locator<AccountManager>();
  final formKey1 = GlobalKey<FormState>();
  late WalletBalance balance;
  late WalletBalance solBalance;
  late UserAccount account;
  SOLTransferModel();

  Future<void> init() async {
    setState(ViewState.Busy);
    totalFee = Decimal.parse('0.000005');
    setState(ViewState.Idle);
  }

  bool get enoughSOLTotal {
    if (balance.token.standard == 'Native' && balance.token.symbol == 'SOL') {
      return (value! + totalFee! <= balance.balance);
    } else {
      return (totalFee! < solBalance.balance);
    }
  }

  void calcTotalFee() {
    //totalFee = (Decimal.fromInt(50000) * _gasPrice!) / Decimal.fromInt(1000000000);
    totalFeeInFiat = totalFee! * solBalance.fiatPrice;
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

  //final controllerMemo = TextEditingController();
  Decimal? valueInFiat;
  Decimal? totalFee;
  Decimal? totalFeeInFiat;

  Decimal? maxTotal;

  /// address actions
  bool get isAddrValid {
    if (sol.isValidAddress(controllerAddress.text)) {
      addressTo = controllerAddress.text;

      return true;
    } else
      return false;
  }

  Future<void> pasteAddress(BuildContext context) async {
    var text = (await Clipboard.getData('text/plain'))?.text;
    if (sol.isValidAddress(text!)) {
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

    if (sol.isValidAddress(text!)) {
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
    value = balance.token.symbol == 'SOL'
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
      var resultTxHash = await account.solWallet.transfer(
          destination: addressTo!,
          lamports: (value! * Decimal.fromInt(10).pow(9)).toInt());

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => TxSuccessScreen(resultTxHash.toString(),
              'https://solscan.io/tx/$resultTxHash', null)));
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
