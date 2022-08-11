import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:voola/locator.dart';

import '../../../../../core/api/tbcc/TBCCApi.dart';
import '../../../../../core/authentication/AuthService.dart';
import '../../../../../shared.dart';
import '../../../../BaseViewModel.dart';

class SmartCardAttachModel extends BaseViewModel {
  var accManager = locator<AuthService>().accManager;

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  ///1 = nfc disabled/unavailable
  ///0 = nfc ready
  ///2 = nfc done
  int nfcState = 1;
  bool cardOrdered = false;
  Future<Null> checkCardOrdered(BuildContext context) async {
    setState(ViewState.Busy);
    var resp = await locator<TBCCApi>().checkOrderedCard_multiaddr(
        [for (var acc in accManager.allAccounts) acc.bcWallet.address ?? ''],
        accManager.allAccounts.first.bcWallet.address ?? '');
    cardOrdered = false; //resp.load;
    setState(ViewState.Idle);
  }

  Future<Null> checkNFCReady(context) async {
    setState(ViewState.Busy);
    //if (Platform.isIOS) {
    //  nfcState = 0;
    //} else {
    var supported = await NFC.isNDEFSupported;
    nfcState = supported ? 0 : 1;
    //}
    setState(ViewState.Idle);

    if (nfcState == 0) startNFCWrite(context);
  }

  Future<Null> startNFCWrite(BuildContext context) async {
    bool wrote = false;
    String private = accManager.allAccounts.first.bcWallet.privateKey ?? '';
    var splitted = splitPrivateKey(private, controller2.text);
    String toWrite = splitted[0];

    NDEFMessage newMessage =
        NDEFMessage.withRecords([NDEFRecord.type("text/plain", toWrite)]);

    while (true) {
      if (!wrote) {
        try {
          var res = await NFC.writeNDEF(newMessage, once: true).first;

          if (res != null) {
            Flushbar.success(title: S.of(context).success)
                .show(Duration(seconds: 4));
            setState(state);
            wrote = true;
            nfcState = 2;
            accManager.allAccounts.first.cardAttached = true;
            accManager.allAccounts.first.privHalf = splitted[1];
            accManager.saveAccounts();
            return;
          }
        } catch (e, st) {
          print('$e: $st');

          Flushbar.error(title: S.of(context).tryAgain)
              .show(Duration(seconds: 4));
          Flushbar.error(title: 'Try again').show(Duration(seconds: 4));
        }
      } else {
        break;
      }
    }
  }

  String removeChar(String str, int index) {
    return str.substring(0, index) + str.substring(index + 1, str.length);
  }

  List<String> splitPrivateKey(String private, String pincode) {
    List pinInt = pincode.split('').map((e) => int.parse(e)).toList();
    var half1 = private;
    var half2 = '';

    int cnt = 0;
    while (cnt <= 4) {
      for (int i in pinInt) {
        half2 += half1[i];
        half1 = removeChar(half1, i);
      }
      cnt += 1;
    }

    return [half1, half2];
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }
}
