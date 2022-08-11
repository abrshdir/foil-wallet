import 'dart:math' show pi;

import 'package:voola/core/token/DexPair.dart';
import 'package:voola/core/token/TokenContainer.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';

import 'DexMainScreen.dart';

class SelectMarketPairModel extends BaseViewModel {
  //var tickers = locator<Tickers>();
  late DexMainModel dexMainModel;

  late List<DexMarketPair> availableMarketPairs;
  late DexMarketPair selectedMarketPair;
  // ExchTickerStats selectedMarketPairTicker;

  SelectMarketPairModel(this.dexMainModel) {
    availableMarketPairs = locator<WALLET_TOKENS_CONTAINER>().DEX_MARKET_PAIRS;
    selectedMarketPair = availableMarketPairs.first;
  }

  void setMarketPair(DexMarketPair pair) {
    //if (selectedMarketPair != pair) {
    //  selectedMarketPair = pair;
    //  selectedMarketPairTicker = tickers.exchange(selectedMarketPair.symbol);
    //  dexMainModel.chartsModel.candleStickChartModel.loadCandlesticks();
    //  dexMainModel.chartsModel.depthModel.initListening(pair.symbol);

    //  dexMainModel.actionsModel.reset();
    //  dexMainModel.actionsModel.setState();
    //  setState();
    //}
  }
}

class SelectMarketPairScreen extends StatelessWidget {
  SelectMarketPairModel model;
  SelectMarketPairScreen(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SelectMarketPairModel>(
      model: model,
      onModelReady: (model) {},
      builder: (context, model, child) {
        return CScaffold(
          appBar: CAppBar(
            elevation: 0,
            title: Text(S.of(context).marketPairs),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: model.availableMarketPairs.length,
            itemBuilder: (context, index) {
              var pair = model.availableMarketPairs[index];
              return marketPairTile(pair, context);
            },
          ),
        );
      },
    );
  }

  Widget marketPairTile(DexMarketPair pair, BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final ticker = model.dexMainModel.tickersService.bcDexTickers![pair.symbol];
    var price = Decimal.parse(ticker!.lastPrice!);
    var changePercent = Decimal.parse(ticker.priceChangePercent!);
    return GestureDetector(
      onTap: () {
        model.selectedMarketPair = pair;
        model.dexMainModel.marketPairChanged();
        Navigator.of(context).pop();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.generalShapesBg,
          borderRadius: BorderRadius.circular(24),
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              pair.left.icon(32),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pair.left.symbol.split('-').first,
                      style: tt.bodyText2!.copyWith(fontSize: 14)),
                  Text(pair.left.standard, style: tt.subtitle2),
                ],
              )
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Text('${price}', style: tt.subtitle2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.rotate(
                      angle: changePercent.isNegative ? pi : 0,
                      child: AppIcons.arrow(
                          10,
                          changePercent.isNegative
                              ? AppColors.red
                              : AppColors.green),
                    ),
                    Text(
                      '${changePercent.abs()}%',
                      style: tt.subtitle2!.copyWith(
                          color: changePercent.isNegative
                              ? AppColors.red
                              : AppColors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(pair.right.symbol.split('-').first,
                      style: tt.bodyText2!.copyWith(fontSize: 14)),
                  Text(pair.right.standard, style: tt.subtitle2),
                ],
              ),
              SizedBox(width: 10),
              pair.right.icon(32),
            ],
          ),
        ]),
      ),
    );
  }
}
