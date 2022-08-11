import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/settings/SettingsMainModel.dart';
import 'package:voola/ui/views/wallet/WalletMainScreenModel.dart';

class SupportCenter extends StatelessWidget {
  SupportCenter({Key? key}) : super(key: key);
  bool needToReload = false;
  @override
  Widget build(BuildContext context) {
    return BaseView<SettingsMainModel>(
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            if (needToReload) {
              () async {
                locator<WalletMainScreenModel>().manualRefresh = true;

                await locator<AccountManager>().reloadTickers();
                locator<WalletMainScreenModel>().manualRefresh = false;
              }();
            }
            return true;
          },
          child: Scaffold(
            appBar: CAppBar(
              elevation: 0,
              title: Text(S.of(context).currency),
            ),
            body: Center(
              child: Text('In develop...'),
            ),
          ),
        );
      },
    );
  }
}
