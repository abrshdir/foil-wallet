import 'package:voola/core/token/TokenContainer.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';

import 'BuyProModel.dart';

class BuyProScreen extends StatelessWidget {
  Decimal price = Decimal.fromInt(30);
  String mode;
  bool discount;
  BuyProScreen({this.mode = '0', this.discount = false, Key? key})
      : super(key: key) {
    if (discount) price = price * Decimal.parse('0.85');
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<BuyProModel>(
      onModelReady: (model) async {
        model.usdPrice = price;
        model.mode = mode;
        model.init();
      },
      builder: (context, model, child) {
        return CScaffold(
            //backgroundColor: locator<AppGlobalModel>().isDarkTheme(context) ? AppColors.primaryBg : Color(0xFFF1F1F5),
            body: model.state == ViewState.Busy
                ? TBCCLoader()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
                                child: Icon(
                                  Icons.close,
                                  size: 35,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${S.of(context).goPro('PRO')} ⚡",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
                        child: Text(
                          S.of(context).proDesc0('PRO'),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ...() {
                        if (model.mode == '0')
                          return [
                            Expanded(
                              child: SingleChildScrollView(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryBg,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: DarkColors.primaryBg,
                                              ),
                                              child: Text(
                                                'PRO',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(
                                                        color: AppColors.yellow,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        height: 1),
                                              ),
                                            ),
                                            Text(
                                              S
                                                  .of(context)
                                                  .proDesc1('\$$price'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(fontSize: 18),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: TileWithBtn(
                                        S.of(context).proDesc2h,
                                        S.of(context).proDesc2,
                                        '${S.of(context).getAccessWithPro('PRO')} ⚡',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: TileWithBtn(
                                        'TBCC VPN',
                                        S.of(context).vpnDescription,
                                        '${S.of(context).getAccessWithPro('PRO')} ⚡',
                                      ),
                                    ),
                                    //Padding(
                                    //  padding: const EdgeInsets.symmetric(vertical: 8),
                                    //  child: TileWithBtn(
                                    //    S.of(context).proDesc3h,
                                    //    S.of(context).proDesc3,
                                    //    '${S.of(context).getOTCWithPro('PRO')} ⚡',
                                    //  ),
                                    //),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: TileWithBtn(
                                        S.of(context).proDesc4h,
                                        S.of(context).proDesc4,
                                        '${S.of(context).becomePro('PRO')} ⚡',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: TileWithBtn(
                                        S.of(context).proDesc5h,
                                        S.of(context).proDesc5,
                                        '${S.of(context).becomePro('PRO')} ⚡',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: TileWithBtn(
                                        S.of(context).proDesc6h,
                                        S.of(context).proDesc6,
                                        '${S.of(context).becomePro('PRO')} ⚡',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Button(
                                  value: S.of(context).purchasePro('PRO'),
                                  onTap: () {
                                    model.mode = '1';
                                    model.setState();
                                  }),
                            )
                          ];
                        else {
                          return [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 25, right: 16, left: 16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: DarkColors.primaryBg,
                                      ),
                                      child: Text(
                                        'PRO',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                                color: AppColors.yellow,
                                                fontWeight: FontWeight.w600,
                                                height: 1),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(S.of(context).oneTimePayment,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500)),
                                    ),
                                    Text(
                                      S.of(context).proDesc1('\$$price'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: model.state == ViewState.Busy
                                  ? TBCCLoader()
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryBg,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(40),
                                            topRight: Radius.circular(40),
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                padding: const EdgeInsets.only(
                                                    top: 20, bottom: 20),
                                                child: Column(
                                                  children: [
                                                    AccountSelector((index) {
                                                      model.accIndex = index;
                                                      model.findBNBBal();
                                                      model.setState();
                                                    }),
                                                    SizedBox(height: 10),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              '${S.of(context).amount}: '),
                                                          Text(
                                                              '${model.bnbPrice} BNB',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              '${S.of(context).fee}: '),
                                                          Text('0.000075 BNB',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1),
                                                        ],
                                                      ),
                                                    ),
                                                    ...() {
                                                      return [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                '${S.of(context).yourBalance}: ',
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                              ),
                                                              Text(
                                                                  ' ${model.bnbBal!.balance} BNB',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText1),
                                                            ],
                                                          ),
                                                        ),
                                                        if (model.bnbBal!
                                                                .balance <
                                                            (model.bnbPrice! +
                                                                model.fee))
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10),
                                                              child: Text(
                                                                  S
                                                                      .of(
                                                                          context)
                                                                      .notEnoughTokens,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText2!
                                                                      .copyWith(
                                                                          color:
                                                                              AppColors.red))),
                                                      ];
                                                    }(),
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
                                                      .purchasePro('PRO'),
                                                  onTap: () {
                                                    if (model.accManager
                                                            .bcBalanceByToken(
                                                                model.accIndex,
                                                                locator<WALLET_TOKENS_CONTAINER>()
                                                                    .BEP2
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .symbol ==
                                                                        'BNB'))!
                                                            .balance >=
                                                        (model.bnbPrice! +
                                                            model.fee)) {
                                                      model.buyPro(context);
                                                    }
                                                  },
                                                ),
                                                Button(
                                                  value: S.of(context).cancel,
                                                  color: Colors.transparent,
                                                  isActive: false,
                                                  onTap: () {
                                                    model.mode = '0';
                                                    model.setState();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            )
                          ];
                        }
                      }()
                    ],
                  ));
      },
    );
  }
}

class TileWithBtn extends StatefulWidget {
  String header, description, buttonText;

  TileWithBtn(this.header, this.description, this.buttonText, {Key? key})
      : super(key: key);

  @override
  _TileWithBtnState createState() => _TileWithBtnState();
}

class _TileWithBtnState extends State<TileWithBtn>
    with TickerProviderStateMixin {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.generalShapesBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(
                    Icons.check,
                    size: 45,
                    color: AppColors.active,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.header,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.w600)),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              expanded = !expanded;
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    S.of(context).details,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: AppColors.green),
                                  ),
                                  Icon(
                                    expanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: AppColors.green,
                                  )
                                ],
                              ),
                              AnimatedSize(
                                duration: Duration(milliseconds: 300),
                                alignment: Alignment.topCenter,
                                curve: Curves.easeIn,
                                vsync: this,
                                child: Container(
                                    constraints: BoxConstraints(
                                        minHeight: 0,
                                        maxHeight: expanded ? 400 : 0),
                                    child: Text('${widget.description}\n',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2)),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: AppColors.mainGradient,
            ),
            child: Text(
              widget.buttonText,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontSize: 12, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
