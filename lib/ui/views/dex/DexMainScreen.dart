import 'package:binance_chain/binance_chain.dart';
import 'package:provider/provider.dart';
import 'package:voola/core/authentication/AccountManager.dart';

import 'package:voola/core/tickers/TickersService.dart';
import 'package:voola/core/token/TokenContainer.dart';

import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/dex/DexActions.dart';
import 'package:voola/ui/views/dex/OrderBookTable.dart';
import 'package:voola/ui/views/dex/SelectMarketPair.dart';

import 'DexOrderHistory.dart';

enum BottomSwitchBar { OrderBook, History }

class DexMainModel extends BaseViewModel {
  final accManager = locator<AccountManager>();
  final tickersService = locator<TickersService>();
  late SelectMarketPairModel marketPairModel;
  late OrderBookTableModel orderBookTableModel;
  late ExchangeActionsModel actionsModel;
  late DexOrderHistoryModel historyModel;

  WalletBalance? leftBal;
  WalletBalance? rightBal;

  int selectedAccIndex = 0;
  BottomSwitchBar bottomSwitchBar = BottomSwitchBar.OrderBook;
  DexMainModel() {
    marketPairModel = SelectMarketPairModel(this);
    orderBookTableModel = OrderBookTableModel(this);
    historyModel = DexOrderHistoryModel(this);
    actionsModel = ExchangeActionsModel(this);
    actionsModel.mode = ExchangeActionMode.Buy;
    setupBalances();
  }

  setupBalances() {
    leftBal = accManager.bcBalanceByToken(
        selectedAccIndex, marketPairModel.selectedMarketPair.left);
    rightBal = accManager.bcBalanceByToken(
        selectedAccIndex, marketPairModel.selectedMarketPair.right);
  }

  marketPairChanged() {
    setState();
    initOrderBookListening();
    setupBalances();
  }

  initOrderBookListening() {
    orderBookTableModel
        .initListening(marketPairModel.selectedMarketPair.symbol);
  }

  loadDexTickers([bool refresh = false]) async {
    if (!refresh) setState(ViewState.Busy);
    await tickersService.loadBCDexTickers();
    if (!refresh) setState(ViewState.Idle);
  }
}

class DexMainScreen extends StatelessWidget {
  DexMainScreen({Key? key}) : super(key: key);
  final tokenContainer = locator<WALLET_TOKENS_CONTAINER>();
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return BaseView<DexMainModel>(
      onModelReady: (model) {
        model.loadDexTickers();
        model.initOrderBookListening();
      },
      builder: (context, model, child) {
        model.actionsModel.context = context;

        return ChangeNotifierProvider.value(
          value: locator<AccountManager>(),
          child: Consumer<AccountManager>(
            builder: (_, mngr, __) => Scaffold(
                appBar: CAppBar(
                    elevation: 0,
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Binance DEX'),
                          AccountSelector((val) {
                            if (model.selectedAccIndex != val) {
                              model.selectedAccIndex = val;
                              model.setupBalances();
                              model.setState();
                              model.marketPairModel.setState();
                              model.actionsModel.setState();
                            }
                          }),
                        ])),
                body: Center(
                    child: model.state == ViewState.Busy
                        ? TBCCLoader()
                        : Stack(fit: StackFit.expand, children: [
                            Positioned.fill(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    DexMarketPairSelector(model),
                                    SizedBox(height: 20),
                                    Row(
                                      children: () {
                                        var ticker =
                                            model.tickersService.bcDexTickers?[
                                                model.marketPairModel
                                                    .selectedMarketPair.symbol];
                                        var price = Decimal.parse(
                                            ticker?.lastPrice ?? '0');
                                        var high24 = Decimal.parse(
                                            ticker?.highPrice ?? '0');
                                        var low24 = Decimal.parse(
                                            ticker?.lowPrice ?? '0');
                                        var rightSymbol = model.marketPairModel
                                            .selectedMarketPair.right.symbol
                                            .split("-")
                                            .first;
                                        return [
                                          for (var price in [
                                            [
                                              S.of(context).price,
                                              '$price $rightSymbol'
                                            ],
                                            [
                                              'High 24h',
                                              '$high24 $rightSymbol'
                                            ],
                                            ['Low 24h', '$low24 $rightSymbol'],
                                          ])
                                            Expanded(
                                                child: DexPriceTile(
                                                    price[0], price[1])),
                                        ].separate<Widget>(SizedBox(width: 6));
                                      }(),
                                    ),
                                    SizedBox(height: 20),
                                    AnimatedButtonBar([
                                      ButtonBarEntry(
                                        child: Text(S.of(context).buy),
                                        onTap: () {
                                          if (model.actionsModel.mode !=
                                              ExchangeActionMode.Buy) {
                                            model.actionsModel.mode =
                                                ExchangeActionMode.Buy;
                                            model.actionsModel.setState();
                                          }
                                        },
                                      ),
                                      ButtonBarEntry(
                                        child: Text(S.of(context).sell),
                                        onTap: () {
                                          if (model.actionsModel.mode !=
                                              ExchangeActionMode.Sell) {
                                            model.actionsModel.mode =
                                                ExchangeActionMode.Sell;
                                            model.actionsModel.setState();
                                          }
                                        },
                                      ),
                                    ]),
                                    SizedBox(height: 20),
                                    DexActions(model.actionsModel),
                                    SizedBox(height: 20),
                                    AnimatedButtonBar([
                                      ButtonBarEntry(
                                          child: Text(S.of(context).orderBook,
                                              style: tt.bodyText1!
                                                  .copyWith(fontSize: 14)),
                                          onTap: () {
                                            if (model.bottomSwitchBar !=
                                                BottomSwitchBar.OrderBook) {
                                              model.bottomSwitchBar =
                                                  BottomSwitchBar.OrderBook;
                                              model.setState();
                                            }
                                          },
                                          activeColor:
                                              AppColors.tokenCardPriceUp),
                                      ButtonBarEntry(
                                          child: Text(S.of(context).history,
                                              style: tt.bodyText1!
                                                  .copyWith(fontSize: 14)),
                                          onTap: () {
                                            if (model.bottomSwitchBar !=
                                                BottomSwitchBar.History) {
                                              model.bottomSwitchBar =
                                                  BottomSwitchBar.History;
                                              model.setState();
                                            }
                                          },
                                          activeColor:
                                              AppColors.tokenCardPriceDown),
                                    ]),
                                    model.bottomSwitchBar ==
                                            BottomSwitchBar.OrderBook
                                        ? OrderBookTable(
                                            model.orderBookTableModel)
                                        : DexHistoryPreview(
                                            model, model.historyModel),
                                    SizedBox(height: 80)
                                  ],
                                ),
                              ),
                            ),
                            ChangeNotifierProvider.value(
                              value: model.actionsModel,
                              child: Consumer<ExchangeActionsModel>(
                                builder: (_, actModel, __) {
                                  return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 20),
                                      child: Button(
                                        value: () {
                                          var symbol = model.marketPairModel
                                              .selectedMarketPair.left.symbol
                                              .split('-')
                                              .first;
                                          if (actModel.mode ==
                                              ExchangeActionMode.Buy)
                                            return S
                                                .of(context)
                                                .buyToken(symbol);
                                          else
                                            return S
                                                .of(context)
                                                .sellToken(symbol);
                                        }(),
                                        onTap: () {
                                          if (model.actionsModel.state ==
                                              ViewState.Idle)
                                            model.actionsModel.placeOrder();
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ]))),
          ),
        );
      },
    );
  }
}

class DexTokenCard extends StatelessWidget {
  final WalletToken token;
  Decimal? balance;
  DexTokenCard(this.token, this.balance, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 20, 16, 20),
      decoration: BoxDecoration(
        //color: AppColors.generalShapesBg,
        gradient: AppColors.altGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          token.icon(32),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(token.symbol.split('-').first),
                Text(token.standard,
                    style: Theme.of(context).textTheme.caption),
                Text(
                  '${balance ?? '?'}',
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.visible,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DexPercentBtn extends StatelessWidget {
  final String text;
  const DexPercentBtn(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: AppColors.mainGradient.createShader,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 1.5)),
        child: Text(text,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white),
            textAlign: TextAlign.center),
      ),
    );
  }
}

class DexPriceTile extends StatelessWidget {
  final String title;
  final String price;

  const DexPriceTile(this.title, this.price, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: AppColors.generalShapesBg.withOpacity(0.6),
            borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$title',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColors.inactiveText)),
            Text('$price', style: Theme.of(context).textTheme.bodyText1),
          ],
        ));
  }
}

class DexHistoryPreview extends StatelessWidget {
  DexOrderHistoryModel historyModel;
  DexMainModel dexMainModel;
  DexHistoryPreview(this.dexMainModel, this.historyModel, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<DexOrderHistoryModel>(
      onModelReady: (model) {
        if (model.openOrders == null) {
          model.loadOpenOrders();
        }
      },
      model: historyModel,
      builder: (context, model, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            gradient: AppColors.altGradient,
            borderRadius: BorderRadius.circular(32),
          ),
          child: model.state == ViewState.Busy
              ? TBCCLoader()
              : Column(children: () {
                  var list = <Widget>[];
                  if (model.openOrders?.isNotEmpty != true) {
                    list.add(GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          historyModel.loadOpenOrders();
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 22),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(S.of(context).noOpenOrders),
                                    Icon(Icons.refresh)
                                  ],
                                ),
                              ],
                            ))));
                  } else {
                    for (var order in model.openOrders!) {
                      list.add(OrderHistoryTile(order, true, historyModel));
                    }
                  }

                  //list.add(GestureDetector(
                  //  onTap: () {
                  //    //Navigator.of(context).push(MaterialPageRoute(builder:(_)=>view));
                  //  },
                  //  behavior: HitTestBehavior.opaque,
                  //  child: Padding(
                  //    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  //    child: Text(
                  //      '${S.of(context).show} ${S.of(context).all}',
                  //      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: AppColors.active),
                  //    ),
                  //  ),
                  //));
                  return list;
                }()),
        );
      },
    );
  }
}

class DexMarketPairSelector extends StatelessWidget {
  DexMainModel dexMainModel;
  DexMarketPairSelector(this.dexMainModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SelectMarketPairModel>(
        onModelReady: (model) {},
        model: dexMainModel.marketPairModel,
        builder: (context, model, child) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      SelectMarketPairScreen(dexMainModel.marketPairModel)));
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.03),
                    offset: Offset(0, 13),
                    blurRadius: 18)
              ]),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: DexTokenCard(model.selectedMarketPair.left,
                              dexMainModel.leftBal?.balance)),
                      SizedBox(width: 12),
                      Expanded(
                          child: DexTokenCard(model.selectedMarketPair.right,
                              dexMainModel.rightBal?.balance)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.generalShapesBg,
                      border: Border.all(color: AppColors.primaryBg, width: 4),
                    ),
                    //child: Icon(Icons.swap_horiz_rounded, color: AppColors.inactiveText),
                    child: Text(
                      '/',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: AppColors.inactiveText),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
