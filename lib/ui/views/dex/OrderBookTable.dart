import 'package:binance_chain/binance_chain.dart';
import 'package:voola/shared.dart';

import 'DexMainScreen.dart';

class OrderBookTable extends StatelessWidget {
  final OrderBookTableModel model;
  const OrderBookTable(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<OrderBookTableModel>(
      onModelReady: (model) {},
      model: model,
      builder: (context, model, child) {
        return model.state == ViewState.Busy
            ? TBCCLoader()
            : Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: AppColors.altGradient,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    ...() {
                      List<Widget> rows = [];
                      rows.add(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        S.of(context).tokenPrice(model
                                            .dexMainModel
                                            .marketPairModel
                                            .selectedMarketPair
                                            .right
                                            .symbol
                                            .split('-')
                                            .first),
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                                color: AppColors.inactiveText)),
                                    Text(S.of(context).amount,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                                color: AppColors.inactiveText)),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      S.of(context).tokenPrice(model
                                          .dexMainModel
                                          .marketPairModel
                                          .selectedMarketPair
                                          .right
                                          .symbol
                                          .split('-')
                                          .first),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                              color: AppColors.inactiveText)),
                                  Text(S.of(context).amount,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                              color: AppColors.inactiveText)),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                      if (model.bookAsks != null && model.bookBids != null)
                        for (int i in List<int>.generate(6, (index) => index)) {
                          var ask = model.bookAsks![i];
                          var bid = model.bookBids![i];

                          rows.add(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    splashColor: AppColors.red.withOpacity(0.1),
                                    highlightColor:
                                        AppColors.red.withOpacity(0.1),
                                    hoverColor: AppColors.red.withOpacity(0.1),
                                    onTap: () {
                                      model.dexMainModel.actionsModel
                                          .priceController.text = '${ask[0]}';
                                      model.dexMainModel.actionsModel
                                          .onPriceChanged('${ask[0]}');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${ask[0]}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                      color: AppColors.red)),
                                          Text('${ask[1]}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                      color: AppColors.red)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    splashColor:
                                        AppColors.green.withOpacity(0.1),
                                    highlightColor:
                                        AppColors.green.withOpacity(0.1),
                                    hoverColor:
                                        AppColors.green.withOpacity(0.1),
                                    onTap: () {
                                      model.dexMainModel.actionsModel
                                          .priceController.text = '${bid[0]}';
                                      model.dexMainModel.actionsModel
                                          .onPriceChanged('${bid[0]}');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${bid[0]}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                      color: AppColors.green)),
                                          Text('${bid[1]}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                      color: AppColors.green)),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }

                      return rows;
                    }()
                  ],
                ));
      },
    );
  }
}

class OrderBookTableModel extends BaseViewModel {
  DexMainModel dexMainModel;
  WebsocketBinanceListener? orderBookListener;
  WsBinanceMessage<MarketDepthData>? orderBookData;

  OrderBookTableModel(this.dexMainModel);

  void initListening([String? marketPairSymbol]) async {
    setState(ViewState.Busy);

    //try {
    //  await orderBookListener?.close();
    //} catch (e) {
    //  print(e);
    //}

    if (orderBookListener != null) {
      orderBookListener!.unsubscribeOrderBookSymbol(marketPairSymbol ??
          dexMainModel.marketPairModel.selectedMarketPair.symbol);
    }
    if (orderBookListener == null) {
      orderBookListener =
          WebsocketBinanceListener(BinanceEnvironment.getProductionEnv());
    }
    orderBookListener?.subscribeOrderBook(
      marketPairSymbol ??
          dexMainModel.marketPairModel.selectedMarketPair.symbol,
      onMessage: (message) {
        if (message.data?.symbol ==
            dexMainModel.marketPairModel.selectedMarketPair.symbol) {
          orderBookData = message;
          prepareOrderBookTableData(
              orderBookData?.data?.bids ?? [], orderBookData?.data?.asks ?? []);

          setState();
        }
      },
    );

    setState(ViewState.Idle);
  }

  ////////////// order book table

  List<List<double>>? bookAsks, bookBids;

  void prepareOrderBookTableData(
      List<List<double>> bidsIn, List<List<double>> asksIn) {
    bookAsks = asksIn.sublist(0, asksIn.length < 6 ? asksIn.length : 6);
    bookBids = bidsIn.sublist(0, bidsIn.length < 6 ? bidsIn.length : 6);
  }

  @override
  void dispose() {
    orderBookListener?.close();
    super.dispose();
  }
}
