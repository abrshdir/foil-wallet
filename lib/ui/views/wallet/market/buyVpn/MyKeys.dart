import 'package:flutter/services.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/core/authentication/UserAccount.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:url_launcher/url_launcher.dart';

class MyVpnKeysScreen extends StatelessWidget {
  const MyVpnKeysScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CScaffold(
      appBar: CAppBar(
        title: Text(S.of(context).myVpnKeys),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 25, right: 16, left: 16),
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 26),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        AppIcons.vpn(65),
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    launch(
                                        'http://182.92.107.179/vpn/TBCCVPN-armv7-latest/');
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: AppColors.mainGradient,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 11, horizontal: 20),
                                      child: Text(
                                        S.of(context).download,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                color: AppColors.text,
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await Clipboard.setData(ClipboardData(
                                        text:
                                            'http://182.92.107.179/vpn/TBCCVPN-armv7-latest/'));
                                    Flushbar.success(
                                            title: S
                                                .of(context)
                                                .copiedToClipboard(''))
                                        .show();
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.copy_rounded),
                                        Text(S.of(context).copy)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
              ),
              for (var acc in locator<AccountManager>().allAccounts)
                if (acc.tbccUser.vpnKeys?.isNotEmpty == true) MyVPNKeyCard(acc)
            ],
          )),
    );
  }
}

class MyVPNKeyCard extends StatelessWidget {
  UserAccount acc;
  MyVPNKeyCard(this.acc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: AppColors.altGradient,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            AppIcons.wallet(24),
            SizedBox(width: 12),
            Text('${acc.accountAlias}')
          ]),
          for (var k in acc.tbccUser.vpnKeys!)
            Container(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(k.key),
                      Text(
                        '${S.of(context).purchaseDate}: ${k.timestamp?.toStringDMY()}',
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppIcons.copy(22),
                      ),
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: k.key));
                        Flushbar.success(
                                title:
                                    S.of(context).copiedToClipboard('VPN Key'))
                            .show();
                      })
                ],
              ),
            )
        ],
      ),
    );
  }
}
