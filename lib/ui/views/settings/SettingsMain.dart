import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:voola/global_env.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/settings/SettingsMainModel.dart';
import 'package:voola/ui/views/settings/address_book/AddressBook.dart';
import 'package:voola/ui/views/settings/support/SupportCenter.dart';
import 'package:voola/ui/views/start/LoginScreen.dart';
import 'package:voola/ui/widgets/SharedWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'About.dart';
import 'currency/CurrencyScreen.dart';
import 'language/LanguageScreen.dart';
import 'security/SercurityMain.dart';

class SettingsMainScreen extends StatefulWidget {
  const SettingsMainScreen({Key? key}) : super(key: key);

  @override
  _SettingsMainScreenState createState() => _SettingsMainScreenState();
}

class _SettingsMainScreenState extends State<SettingsMainScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BaseView<SettingsMainModel>(
      onModelReady: (model) {},
      builder: (context, model, child) {
        return CScaffold(
          appBar: CAppBar(
            elevation: 0,
            title: Text(S.of(context).settings),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              AspectRatio(
                aspectRatio: 16 / 8,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.primary,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIcons.crown(
                        38,
                        Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Go PRO',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.08,
                        ),
                        child: Text(
                          'get access to more features and more savings with VOOLA Wallet PRO ',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.white,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              SettingsTile(
                index: 1,
                icon: AppIcons.walletconnect(20, AppColors.primary),
                value: 'Wallet Connection',
                onTap: () {},
              ),
              SettingsTile(
                index: 1,
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 25,
                    height: 25,
                    child: SvgPicture.asset(
                        'assets/images/flags/${FIAT_CURRENCY_SYMBOL.toLowerCase()}.svg',
                        fit: BoxFit.fill,
                        clipBehavior: Clip.hardEdge),
                  ),
                ),
                value: S.of(context).currency,
                onTap: () => Navigator.of(context).push(PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    child: CurrencyScreen(model))),
                trailing: Text(
                  '$FIAT_CURRENCY_SYMBOL  ',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: AppColors.inactiveText),
                ),
              ),
              SettingsTile(
                index: 1,
                icon: gradientIcon(AppIcons.verified(20)),
                value: S.of(context).securityCenter,
                onTap: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SecurityMainScreen(),
                    ),
                  );
                },
              ),
              SettingsTile(
                index: 1,
                icon: AppIcons.notification_bell(18, AppColors.primary),
                value: 'Push Notifications',
                onTap: () {},
              ),
              SettingsTile(
                index: 1,
                bottomSpace: true,
                icon: AppIcons.book_open(20, AppColors.primary),
                value: S.of(context).addressBook,
                onTap: () => Navigator.of(context).push(
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    child: AddressBookMain(),
                  ),
                ),
              ),
              ThemeSwitcher(builder: (context) {
                return SwitchSettingsTile(
                  index: 3,
                  icon: AppIcons.idea(20, AppColors.primary),
                  value: S.of(context).darkMode,
                  onTap: () {},
                  isSwitched:
                      ThemeProvider.of(context)!.brightness == Brightness.dark,
                  onSwitchChanged: (bool val) {
                    model.changeTheme(context, val);
                  },
                );
              }),
              SettingsTile(
                index: 4,
                bottomSpace: true,
                icon: AppIcons.crown(20, AppColors.inactiveText),
                value: 'Multi - wallet',
                // onTap: () {},
              ),
              SettingsTile(
                index: 4,
                icon: gradientIcon(AppIcons.support(20)),
                value: S.of(context).supportCenter,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SupportCenter(),
                  ),
                ),
              ),
              SettingsTile(
                index: 5,
                icon: gradientIcon(AppIcons.info(20)),
                value: S.of(context).aboutTbcc,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AboutScreen(),
                  ),
                ),
                bottomSpace: true,
              ),
              SettingsTile(
                index: 4,
                icon: AppIcons.twitter(20, AppColors.primary),
                value: 'Twitter',
                onTap: () {
                  // launch('https://t.me/tbcc_china');
                },
                endIcon: false,
                trailing: Text(
                  '@tbcclabs',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              SettingsTile(
                index: 4,
                icon: AppIcons.telegram(20, AppColors.primary),
                value: 'Telegram',
                onTap: () {
                  // launch('https://t.me/tbcc_china');
                },
                endIcon: true,
                endIconWidget:
                    AppIcons.arrowOutCorner(18, AppColors.inactiveText),
                trailing: Text(
                  '@tbcclabs',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              SettingsTile(
                index: 4,
                icon: AppIcons.telegram(20, AppColors.primary),
                value: 'Telegram bot',
                onTap: () {
                  // launch('https://t.me/tbcc_china');
                },
                endIcon: true,
                endIconWidget:
                    AppIcons.arrowOutCorner(18, AppColors.inactiveText),
                trailing: Text(
                  '@tbcclabs',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              SettingsTile(
                index: 4,
                bottomSpace: true,
                icon: AppIcons.crown(20, AppColors.primary),
                value: 'Suggestions',
                onTap: () {},
              ),
              SettingsTile(
                index: 6,
                icon: Icon(Icons.logout_outlined, color: AppColors.red),
                value: S.of(context).logOut,
                onTap: () => model.logout(context),
                endIcon: false,
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingsTile extends StatelessWidget {
  final Widget icon;
  final void Function()? onTap;
  final String value;
  final Widget? trailing;
  final bool bottomSpace;
  final int index;
  final bool endIcon;
  final Widget? endIconWidget;

  @override
  SettingsTile({
    required this.index,
    required this.icon,
    required this.value,
    this.onTap,
    this.bottomSpace = false,
    this.trailing,
    this.endIcon = true,
    this.endIconWidget,
  });

  Widget build(BuildContext context) {
    return AnimatedOpacityWrapper(
      index: index,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 4, 0, bottomSpace ? 16 : 4),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.secondaryBG,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 13),
                  blurRadius: 18,
                  color: AppColors.shadowColor,
                )
              ]),
          child: Row(
            children: [
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 14), child: icon),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: onTap == null
                              ? AppColors.inactiveText
                              : AppColors.text),
                    ),
                  ),
                ],
              ),
              Spacer(),
              if (trailing != null) trailing!,
              if (endIcon)
                Row(
                  children: [
                    SizedBox(width: 8),
                    endIconWidget ??
                        Icon(Icons.chevron_right, color: AppColors.text),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SwitchSettingsTile extends StatelessWidget {
  final int index;
  final Widget icon;
  final void Function() onTap;
  final String value;
  final bool bottomSpace;
  final bool isSwitched;
  final Function(bool) onSwitchChanged;
  @override
  SwitchSettingsTile({
    required this.index,
    required this.icon,
    required this.value,
    required this.onTap,
    this.isSwitched = false,
    this.bottomSpace = false,
    required this.onSwitchChanged,
  });

  Widget build(BuildContext context) {
    return AnimatedOpacityWrapper(
      index: index,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 4, 0, bottomSpace ? 16 : 4),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.secondaryBG,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 13),
                  blurRadius: 18,
                  color: AppColors.shadowColor,
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: icon,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  )
                ],
              ),
              CupertinoSwitch(
                value: isSwitched,
                onChanged: onSwitchChanged,
                activeColor: AppColors.active,
              )
            ],
          ),
        ),
      ),
    );
  }
}
