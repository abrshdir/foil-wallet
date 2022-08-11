import 'dart:convert';

import 'package:bip39/bip39.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:solana/solana.dart' as sol;
import 'package:voola/App.dart';
import 'package:voola/core/api/tbcc/TBCCApi.dart';
import 'package:voola/core/authentication/UserAccount.dart';
import 'package:voola/core/settings/AppSettings.dart';
import 'package:voola/core/settings/UserSettings.dart';
import 'package:voola/core/token/utils.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/wallet/WalletMainScreenModel.dart';

import 'core/api/binance_chain/BCApi.dart';
import 'core/api/bsc/BSCApi.dart';
import 'core/api/ethereum/ETHApi.dart';
import 'core/api/tbcc/models/Update.dart';
import 'core/authentication/AccountManager.dart';
import 'core/authentication/AuthService.dart';
import 'core/storage/SecureStorage.dart';
import 'core/tickers/TickersService.dart';
import 'global_env.dart';
import 'locator.dart';
import 'ui/views/settings/address_book/AddressBookModel.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  setupLocator();

  await init();

  runApp(WalletApp());
}

Future<void> init({bool retryInternet = false}) async {
  var storage = locator<Storage>();
  var settings = locator<UserSettings>();
  var tbccApi = locator<TBCCApi>();
  await storage.migrateStorage();

  locator<AddressBookModel>().readAddressBook();
  var load = <dynamic>[];
  try {
    var config = await tbccApi.loadConfigs();
    if (config.statusCode == -1) {
      settings.initNetworkFailed = true;
    } else {
      settings.update = InnerUpdate.fromJson(config.load.updateJson);
      locator<AppSettings>()
          .from(AppSettings.fromJson(config.load.appSettingsJson));
      setupEnv();

      /// add to locator remote config-dependent instances
      if (!retryInternet) {
        locator.registerLazySingleton(() => BinanceChainApi());
        locator.registerLazySingleton(() => BSCApi());
        locator.registerLazySingleton(() => ETHApi());
        locator.registerLazySingleton(() => TickersService());
        locator.registerLazySingleton(() => AccountManager());
        locator.registerLazySingleton(() => AuthService());
      }
      var authService = locator<AuthService>();
      var load = (await Future.wait<dynamic>(
        [
          if (!retryInternet) readWalletTokens(),
          if (!retryInternet) storage.readUserSettings(),
          if (!retryInternet) storage.readUserAccounts(),
        ],
      ));

      settings.fillfromJson(json.decode(load[1]));
      settings.canCheckBiometrics =
          await authService.localAuth.canCheckBiometrics;
      settings.versionName = '2.1.1';
      settings.versionCode = '83';
      if (settings.sentFirstRunVer != settings.versionCode) {
        tbccApi.sendFirstRun(settings.versionCode);
        settings
          ..sentFirstRunVer = settings.versionCode
          ..save();
      }

      authService.accManager.allAccounts = [];

      var needToSaveAccs = false;
      for (var acc in json.decode(load[2])) {
        var a = UserAccount.fromJson(acc);
        if (a.seed == null) {
          a.seed = mnemonicToSeed(a.mnemonic);
          needToSaveAccs = true;
        }

        /// init SOLANA wallet from seed
        a.solWallet = sol.Wallet(
            rpcClient: ENVS.SOL_ENV!,
            signer: await sol.Ed25519HDKeyPair.fromSeedWithHdPath(
                seed: a.seed!.toList(), hdPath: "m/44'/501'/0'"));
        authService.accManager.allAccounts.add(a);
      }
      if (needToSaveAccs == true) authService.accManager.saveAccounts();

      if (settings.loggedIn) {
        /// run preload balances
        locator<WalletMainScreenModel>().loadBalances();
        locator<TBCCApi>().getUsers(authService.accManager.allAccounts
            .map((e) => e.bcWallet.address!)
            .toList());
      }
      settings.initNetworkFailed = false;
    }
  } catch (e, st) {
    settings.initNetworkFailed = true;
    print('something wrong: $e, $st');
  }
}
