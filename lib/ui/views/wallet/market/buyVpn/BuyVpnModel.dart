import 'package:voola/core/api/binance_chain/BCApi.dart';
import 'package:voola/core/api/tbcc/TBCCApi.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/wallet/market/buyVpn/MyKeys.dart';

class BuyVpnModel extends BaseViewModel {
  String mode = '0';
  var _api = locator<BinanceChainApi>();
  var _tbccApi = locator<TBCCApi>();
  var accManager = locator<AccountManager>();
  int accIndex = 0;

  Future<Null> buyVpn(BuildContext context, Decimal amount) async {
    setState(ViewState.Busy);
    print('cock');
    try {
      var resp1 = await _api.sendToken(
          accManager.allAccounts[accIndex].bcWallet,
          'bnb149qr9c6r4yd4jjwfen85q50a5y06vzuf087cct',
          'BNB',
          amount,
          'Buy VPN key',
          sync: true);
      if (resp1.ok) {
        var resp2 = await _tbccApi.clientBoughtVPN(
            accManager.allAccounts[accIndex].bcWallet.address!,
            resp1.load.first.hash!);

        if (resp2.ok) {
          accManager.allAccounts[accIndex].tbccUser.vpnKeys?.add(resp2.load);
          accManager.notifyListeners();
        }
        Flushbar.success(title: S.of(context).success).show();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => MyVpnKeysScreen()));
      } else {
        Flushbar.error(title: resp1.errorMessage ?? S.of(context).error)
            .show(Duration(seconds: 5));
      }
    } catch (e) {
      Flushbar.error(title: '${S.of(context).error} $e')
          .show(Duration(seconds: 5));
    }

    setState(ViewState.Idle);
  }
}
