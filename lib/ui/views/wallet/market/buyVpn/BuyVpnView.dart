import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voola/core/authentication/AccountManager.dart';

import 'package:voola/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import 'BuyVpnModel.dart';

class BuyVpnScreen extends StatelessWidget {
  BuyVpnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<BuyVpnModel>(
      onModelReady: (model) {},
      builder: (context, model, child) {
        return CScaffold(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.active
                : Color(0xFFF1F1F5),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 70,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "TBCC VPN 🔥",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 20, 5),
                          child: Icon(
                            Icons.close,
                            size: 35,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(40, 30, 40, 30),
                  child: Text(
                    S.of(context).vpnDescription,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 25, right: 16, left: 16),
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 26),
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
                ...() {
                  var fee = Decimal.parse('0.000075');
                  return [
                    ChangeNotifierProvider.value(
                        value: model.accManager,
                        builder: (context, _) =>
                            Consumer<AccountManager>(builder: (_, val, __) {
                              var bnbBal = model.accManager
                                  .allAccounts[model.accIndex].bc_bep2_Balances
                                  .firstWhere((element) =>
                                      element.token.symbol == 'BNB');
                              var amount = Decimal.parse(
                                  (Decimal.parse('25.99') / bnbBal.fiatPrice)
                                      .toStringWithFractionDigits(6));
                              return Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryBg,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        topRight: Radius.circular(40),
                                      )),
                                  child: model.state == ViewState.Busy
                                      ? TBCCLoader()
                                      : Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  padding: EdgeInsets.only(
                                                      top: 30, bottom: 20),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          //crossAxisAlignment: CrossAxisAlignment.baseline,
                                                          children: [
                                                            Text(
                                                                '${S.of(context).price}: '),
                                                            Text(
                                                                '\$25.99 ($amount BNB (BEP2))',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          //crossAxisAlignment: CrossAxisAlignment.baseline,
                                                          children: [
                                                            Text(
                                                                '${S.of(context).fee}: '),
                                                            Text(
                                                                '0.000075 BNB (BEP2)',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          //crossAxisAlignment: CrossAxisAlignment.baseline,
                                                          children: [
                                                            Text(
                                                              '${S.of(context).yourBalance}: ',
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                            Text(
                                                                ' ${bnbBal.balance} BNB (BEP2)',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 12),
                                                      AccountSelector((index) {
                                                        model
                                                          ..accIndex = index
                                                          ..setState();
                                                      })
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Button(
                                                    value: S
                                                        .of(context)
                                                        .purchaseVpn,
                                                    onTap: () {
                                                      if (bnbBal.balance >=
                                                          amount + fee) {
                                                        model.buyVpn(
                                                            context, amount);
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(height: 12),
                                                  Button(
                                                    value: S.of(context).cancel,
                                                    color: AppColors
                                                        .tokenCardPriceDown,
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              );
                            }))
                  ];
                }()
              ],
            ));
      },
    );
  }
}
