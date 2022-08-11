import 'package:voola/core/settings/AppSettings.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import 'buyVpn/BuyVpnView.dart';
import 'buyVpn/MyKeys.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CScaffold(
      appBar: CAppBar(
        elevation: 0,
        title: Text(S.of(context).market),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 18),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: AppColors.altGradient),
                    padding: EdgeInsets.zero,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/images/market/vpn_card_image.png',
                          fit: BoxFit.fitWidth,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 20, 16, 30),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: AppIcons.vpn(30),
                                      ),
                                      Text(
                                        'TBCC VPN',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.text),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '\$25.99',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.text),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15, bottom: 10),
                                child: Text(
                                  S.of(context).vpnDescription,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                          color: AppColors.text, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 20,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      if (locator<AppSettings>().buy_vpn) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => BuyVpnScreen(),
                            fullscreenDialog: true));
                      } else {
                        Flushbar.error(title: S.of(context).serviceUnavailable)
                            .show();
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => MyVpnKeysScreen()));
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: AppColors.mainGradient,
                            ),
                            child: Text(
                              'Show my keys',
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        color: AppColors.text,
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              launch('https://tbccvpn.com/');
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.active),
                              child: Text(
                                S.of(context).details,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: AppColors.text,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (locator<AppSettings>().buy_vpn) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => BuyVpnScreen(),
                                  fullscreenDialog: true));
                            } else {
                              Flushbar.error(
                                      title: S.of(context).serviceUnavailable)
                                  .show();
                            }
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: AppColors.mainGradient,
                            ),
                            child: Text(
                              '${S.of(context).purchaseVpn} 🔥',
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        color: AppColors.text,
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
