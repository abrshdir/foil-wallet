import 'dart:async';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/styles/AppTheme.dart';
import 'package:voola/ui/views/wallet/market/MarketScreen.dart';

import 'views/dapp_browser/DAppScreen.dart';
import 'views/dex/DexMainScreen.dart';
import 'views/settings/SettingsMain.dart';
import 'views/wallet/WalletMainScreen.dart';
import 'widgets/PlatformWidgets.dart';

class MainAppScreen extends StatelessWidget {
  MainAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var items = [
      [AppIcons.wallet(24), ''],
      [AppIcons.chart(24), ''],
      [AppIcons.dapp(24), ''],
      [AppIcons.purchase(24), ''],
      [AppIcons.settings(24), ''],
    ];

    return BaseView<MainScreenModel>(
      onModelReady: (model) {
        Future.delayed(Duration(seconds: 1), () {
          ShowCaseWidget.of(model.mainScreenContext)!
              .startShowCase(model.showcaseKeys.values.toList());
          //ShowCaseWidget.of(model.mainScreenContext)!.startShowCase(model.showcaseKeys);
        });
      },
      builder: (_, model, __) {
        return WillPopScope(
          onWillPop: () async {
            if (model.popTapedOnce) {
              return true;
            } else {
              model.popTapedOnce = true;
              ScaffoldMessenger.of(model.tabScaffoldKey.currentContext!)
                  .showSnackBar(SnackBar(
                content: Text('Press again to exit app'),
              ));
              Timer(Duration(seconds: 4), () {
                model.popTapedOnce = false;
              });

              return false;
            }
          },
          child: ThemeSwitchingArea(
            child: Builder(
              builder: (_) {
                return ShowCaseWidget(
                  builder: Builder(
                    builder: (context) {
                      model.mainScreenContext = context;
                      return PlatformTabScaffold(
                        key: model.tabScaffoldKey,
                        bodyItems: [
                          SafeArea(
                              bottom: true,
                              right: false,
                              top: false,
                              left: false,
                              child: WalletMainScreen()),
                          SafeArea(
                              bottom: true,
                              right: false,
                              top: false,
                              left: false,
                              child: DexMainScreen()),
                          SafeArea(
                              bottom: true,
                              right: false,
                              top: false,
                              left: false,
                              child: DAppScreen()),
                          SafeArea(
                              bottom: true,
                              right: false,
                              top: false,
                              left: false,
                              child: MarketScreen()),
                          //SafeArea(bottom: true, right: false, top: false, left: false, child: Scaffold()),
                          SafeArea(
                              bottom: true,
                              right: false,
                              top: false,
                              left: false,
                              child: SettingsMainScreen()),
                        ],
                        bottomItems: [
                          for (var item in items)
                            BottomNavigationBarItem(
                              icon: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                                child: SvgPicture(
                                  (item[0] as SvgPicture).pictureProvider,
                                  colorFilter: ColorFilter.mode(
                                      AppColors.inactiveText, BlendMode.srcIn),
                                ),
                              ),
                              activeIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                                child: SvgPicture(
                                  (item[0] as SvgPicture).pictureProvider,
                                  colorFilter: ColorFilter.mode(
                                      AppColors.active, BlendMode.srcIn),
                                ),
                              ),
                              label: item[1] as String,
                            ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class MainScreenModel extends BaseViewModel {
  GlobalKey<PlatformTabScaffoldState> tabScaffoldKey = GlobalKey();
  late BuildContext mainScreenContext;
  bool popTapedOnce = false;
  //List<GlobalKey> showcaseKeys = [
  //  GlobalKey(),
  //  GlobalKey(),
  //];

  Map<String, GlobalKey> showcaseKeys = {
    'wallet_top_button_bar': GlobalKey(),
    'account_carousel': GlobalKey(),
    'token_filter_switch_bar': GlobalKey(),
    'token_filter_button': GlobalKey(),
    'token_filter_screen1': GlobalKey(),
    'token_card': GlobalKey(),
    //'token_card_chart': GlobalKey(),
    //'token_card_actions': GlobalKey(),
    //'receive_tokens_qr': GlobalKey(),
    //'receive_tokens_address': GlobalKey(),
    //'bottom_bar': GlobalKey(),
    //  'dex_pair': GlobalKey(),
    //  'dex_pair_last_values': GlobalKey(),
    //  'dex_mode': GlobalKey(),
    //  'dex_actions': GlobalKey(),
    //  'dapps_wallet_switch': GlobalKey(),
    //  'dapps_groups': GlobalKey(),
    //  'dapps_tools': GlobalKey(),
  };
}
