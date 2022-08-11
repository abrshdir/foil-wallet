import 'package:stacked_services/stacked_services.dart';
import 'package:voola/core/api/binance_chain/BCApi.dart';
import 'package:voola/core/api/coingecko/CoingeckoAPI.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/core/authentication/AuthService.dart';

import 'package:voola/core/token/TokenContainer.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';

class BuyProModel extends BaseViewModel {
  String mode = '0';
  int accIndex = 0;
  var _api = locator<BinanceChainApi>();
  AccountManager accManager = locator<AuthService>().accManager;
  WalletBalance? bnbBal;
  Decimal usdPrice = Decimal.parse('30');
  Decimal fee = Decimal.parse('0.000075');
  Decimal? bnbPrice;
  Future<void> init() async {
    setState(ViewState.Busy);

    await findBNBBal();
    var bnbPriceUsd = (await locator<CoingeckoApi>()
            .loadTickers(ids: ['binancecoin'], vsCurrencies: ['usd']))
        .load['binancecoin']!
        .inCurrency;

    bnbPrice = Decimal.parse((usdPrice / bnbPriceUsd!)
        .toStringWithFractionDigits(3, shrinkZeros: true));
    //model.bnbPrice = Decimal.parse('0.0001');
    setState(ViewState.Idle);
  }

  Future<void> buyPro(BuildContext context) async {
    setState(ViewState.Busy);

    var resp = await _api.sendToken(
        accManager.allAccounts[accIndex].bcWallet,
        'bnb1axkzc707rl7nqlzxl3jftkm72vmdh7gvqyvy2j',
        'BNB',
        bnbPrice!,
        'TBCC PRO',
        sync: true);

    if (resp.ok) {
      accManager.allAccounts[accIndex].tbccUser.paidFee = 2;
      accManager.allAccounts[accIndex].tbccUser.subPurchaseDate =
          DateTime.now().toUtc();
      accManager.accountType = AccType.Pro;
      Navigator.of(context).popUntil((route) => route.isFirst);

      Flushbar.success(title: S.of(context).success).show();

      locator<DialogService>().showDialog(
          title: 'TBCC VPN', description: S.of(context).proVpnDialog);
      accManager.notifyListeners();

      //Future.delayed(Duration(seconds: 2), () {
      //  locator<MainScreenModel>().reloadTbccProfile();
      //});
    } else {
      Flushbar.error(title: resp.errorMessage ?? S.of(context).error).show();
    }

    setState(ViewState.Idle);
  }

  Future<void> findBNBBal() async {
    bnbBal = accManager.bcBalanceByToken(
        accIndex,
        locator<WALLET_TOKENS_CONTAINER>()
            .BEP2
            .firstWhere((element) => element.symbol == 'BNB'));

    if (bnbBal?.fiatPrice == Decimal.zero) {
      bnbBal?.fiatPrice = accManager
          .balanceByToken(
              accIndex,
              locator<WALLET_TOKENS_CONTAINER>()
                  .COINS
                  .firstWhere((element) => element.symbol == 'BNB'))!
          .fiatPrice;
    }
  }
}
