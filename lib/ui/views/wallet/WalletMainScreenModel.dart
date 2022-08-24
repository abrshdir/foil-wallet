import 'package:stacked_services/stacked_services.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/core/token/utils.dart';

import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/BaseViewModel.dart';
import 'package:voola/ui/views/premium/Pro_Premium.dart';

import 'News.dart';
import 'SparklineChart.dart';

enum TokenFilterType {
  All,
  Native,
  BEP20,
  ERC20,
  BEP2,
  BEP8,
}

class WalletMainScreenModel extends BaseViewModel {
  final newsModel = NewsListViewModel();
  int barValue = 0;
  bool _manualRefresh = false;
  bool get manualRefresh => _manualRefresh;
  set manualRefresh(bool val) {
    _manualRefresh = val;
    notifyListeners();
  }

  var accManager = locator<AccountManager>();
  TokenMarketsModel? currentTokenMarketsModel;
  int _currAccIndex = 0;
  int get currAccIndex => _currAccIndex;
  set currAccIndex(int val) {
    _currAccIndex = val;
    balListModel.notifyListeners();
  }

  final sc = ScrollController();

  TokenFilterType _tokenFilterType = TokenFilterType.Native;
  TokenFilterType get tokenFilterType => _tokenFilterType;
  set tokenFilterType(TokenFilterType val) {
    _tokenFilterType = val;
    balListModel.notifyListeners();
  }

  late BalListModel balListModel;

  WalletMainScreenModel() {
    balListModel = BalListModel(this);
  }

  Future<void> loadBalances({bool refresh = false}) async {
    if (!refresh) setState(ViewState.Busy);
    await accManager.loadAccounts();
    if (!refresh) setState(ViewState.Idle);
    await Future.delayed(Duration(seconds: 2));
    checkSubscription();
  }

  void checkSubscription() {
    //await Future.delayed(Duration(seconds: 1));
    print(accManager.subscriptionExpireDate);
    if (accManager.subscriptionExpireDate != null) {
      if (accManager.subscriptionExpireDate!.compareTo(DateTime.now().toUtc()) <
          0) {
        showSubEnded();
      } else {
        var daysRemaining = accManager.subscriptionExpireDate!
            .difference(DateTime.now().toUtc())
            .inDays;
        if (daysRemaining < 5) {
          showSubExpiresInDays(daysRemaining);
        }
      }
    }
  }

  void showSubEnded() {
    Flushbar.error(
      title: 'Subscription ended',
      subtitle: 'Renew subsctiption',
      action: () {
        StackedService.navigatorKey?.currentState
            ?.push(MaterialPageRoute(builder: (_) => Pro_PremiumView()));
      },
    ).show(Duration(seconds: 15));
  }

  void showSubExpiresInDays(daysRemaining) {
    Flushbar.warning(
      title: 'Subscription ends in $daysRemaining days',
      subtitle: 'Renew subsctiption',
      action: () {
        StackedService.navigatorKey?.currentState
            ?.push(MaterialPageRoute(builder: (_) => Pro_PremiumView()));
      },
    ).show(Duration(seconds: 15));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class BalListModel extends ChangeNotifier {
  WalletMainScreenModel walletMainModel;
  BalListModel(this.walletMainModel);
}

class BLOCKCHAIN_CONNECTION_STATE extends BaseViewModel {
  Map<TokenNetwork, bool> states = {
    TokenNetwork.BinanceChain: true,
    TokenNetwork.Ethereum: true,
    TokenNetwork.BinanceSmartChain: true,
    TokenNetwork.Solana: true,
    TokenNetwork.Foil: true,
  };
}
