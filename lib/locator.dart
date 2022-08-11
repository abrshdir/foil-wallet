import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:voola/App.dart';
import 'package:voola/core/settings/AppSettings.dart';
import 'package:voola/ui/views/dapp_browser/MoreInformation.dart';
import 'package:voola/ui/views/settings/address_book/AddCurrency.dart';
import 'package:voola/ui/views/settings/address_book/Gorh.dart';
import 'package:voola/ui/views/settings/address_book/Sarm.dart';
import 'package:voola/ui/views/settings/security/smartCard/SmartCardAttachModel.dart';
import 'package:voola/ui/views/wallet/News.dart';
import 'package:voola/ui/views/wallet/ReceiveScreen.dart';

import 'core/api/coingecko/CoingeckoAPI.dart';
import 'core/api/network_fees/NetworkFeesApi.dart';
import 'core/api/tbcc/TBCCApi.dart';
import 'core/settings/UserSettings.dart';
import 'core/storage/SecureStorage.dart';
import 'core/token/TokenContainer.dart';
import 'ui/MainScreen.dart';
import 'ui/update/UpdateModel.dart';
import 'ui/views/dapp_browser/DAppBrowserScreen.dart';
import 'ui/views/dapp_browser/DAppLaunchScreen.dart';
import 'ui/views/dapp_browser/DAppScreen.dart';
import 'ui/views/dapp_browser/InteractionUI.dart';
import 'ui/views/dex/DexMainScreen.dart';
import 'ui/views/premium/buyPremium/BuyPremiumModel.dart';
import 'ui/views/premium/buyPro/BuyProModel.dart';
import 'ui/views/settings/SettingsMainModel.dart';
import 'ui/views/settings/address_book/AddContact.dart';
import 'ui/views/settings/address_book/AddressBookModel.dart';
import 'ui/views/start/CreateWallet.dart';
import 'ui/views/start/LoginScreen.dart';
import 'ui/views/start/RestoreWallet.dart';
import 'ui/views/start/SetPassword.dart';
import 'ui/views/wallet/AccountsSettings.dart';
import 'ui/views/wallet/Swaps.dart';
import 'ui/views/wallet/WalletMainScreenModel.dart';
import 'ui/views/wallet/details/HistoryModel.dart';
import 'ui/views/wallet/market/buyVpn/BuyVpnModel.dart';
import 'ui/views/wallet/transactions/binance_chain/model.dart';
import 'ui/views/wallet/transactions/binance_smart_chain/model.dart';
import 'ui/views/wallet/transactions/ethereum/model.dart';
import 'ui/views/wallet/transactions/solana/model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //core
  locator.registerLazySingleton(() => WALLET_TOKENS_CONTAINER());
  locator.registerLazySingleton(() => Storage());
  locator.registerLazySingleton(() => AppSettings());
  locator.registerLazySingleton(() => UserSettings());
  locator.registerLazySingleton(() => CoingeckoApi());
  locator.registerLazySingleton(() => NavigationService());

  locator.registerLazySingleton(() => NetworkFeesApi());
  locator.registerLazySingleton(() => DialogService());

  locator.registerLazySingleton(() => TBCCApi());

  //viewmodels
  locator.registerLazySingleton(() => AppMainModel());
  locator.registerLazySingleton(() => MainScreenModel());
  locator.registerLazySingleton(() => WalletMainScreenModel());

  locator.registerFactory(() => LoginScreenModel());
  locator.registerFactory(() => CreateWalletModel());
  locator.registerFactory(() => RestoreWalletModel());
  locator.registerFactory(() => SetPasswordModel());

  locator.registerFactory(() => AccountsSettingsModel());
  locator.registerFactory(() => ReceiveScreenModel());

  locator.registerFactory(() => DAppTransactionViewModel());
  locator.registerFactory(() => DAppBrowserScreenModel());
  locator.registerFactory(() => DAppLaunchScreenModel());
  locator.registerLazySingleton(() => DAppScreenModel());

  locator.registerFactory(() => ETHTransferModel());
  locator.registerFactory(() => BSCTransferModel());
  locator.registerFactory(() => BCTransferModel());
  locator.registerFactory(() => SOLTransferModel());

  locator.registerFactory(() => SettingsMainModel());
  locator.registerFactory(() => TxHistoryModel());
  locator.registerFactory(() => DexMainModel());
  locator.registerFactory(() => BuyPremiumModel());
  locator.registerFactory(() => BuyProModel());
  locator.registerFactory(() => CrossChainSwapModel());
  locator.registerFactory(() => UpdateViewModel());
  locator.registerLazySingleton(() => AddressBookModel());
  locator.registerLazySingleton(() => BLOCKCHAIN_CONNECTION_STATE());
  locator.registerFactory(() => LotteryScreenModel());
  locator.registerFactory(() => AddContactModel());
  locator.registerFactory(() => AddCurrencyModel());
  locator.registerFactory(() => BuyVpnModel());
  locator.registerFactory(() => SmartCardAttachModel());
  locator.registerFactory(() => SarmModel());
  locator.registerFactory(() => GorhModel());
  locator.registerFactory(() => MoreInformationModel());

  //locator.registerFactory(() => DexOrderHistoryModel());
}
