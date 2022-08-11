import 'package:fl_chart/fl_chart.dart';
import 'package:voola/core/api/coingecko/CoingeckoAPI.dart';
import 'package:voola/core/api/coingecko/model/CoinMarkets.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:dartx/dartx.dart';

class SparklineChart extends StatelessWidget {
  TokenMarketsModel model;
  String coingeckoId;
  SparklineChart(this.model, this.coingeckoId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<TokenMarketsModel>(
      model: model,
      onModelReady: (model) {
        model.loadMarkets(coingeckoId);
      },
      builder: (context, model, child) {
        return Column(
          children: [
            Expanded(
              child: model.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : () {
                      var spots = [
                        for (var i in model.data!.sparkline.indexed())
                          FlSpot(i[0].toDouble(), i[1].value.toDouble())
                      ];
                      var showIndexes = [0, spots.length - 1];
                      var lineBarsData = [
                        LineChartBarData(
                          showingIndicators: showIndexes,
                          isCurved: true,
                          colors: [AppColors.active],
                          dotData: FlDotData(show: false),
                          isStrokeCapRound: true,
                          barWidth: 2,
                          spots: spots,
                        ),
                      ];
                      final tooltipsOnBar = lineBarsData[0];
                      var _gest = () {
                        model.tooltipEnabled = false;
                        model.setState();
                      };
                      var _gest_ = (_) {
                        model.tooltipEnabled = false;
                        model.setState();
                      };
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 60, 16, 12),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapUp: _gest_,
                          onLongPressUp: _gest,
                          child: GestureDetector(
                            //onTapDown: (_) {
                            //  model.tooltipEnabled = true;
                            //  model.setState();
                            //},
                            child: LineChart(
                              LineChartData(
                                showingTooltipIndicators:
                                    showIndexes.map((index) {
                                  return ShowingTooltipIndicators([
                                    LineBarSpot(
                                        tooltipsOnBar,
                                        lineBarsData.indexOf(tooltipsOnBar),
                                        tooltipsOnBar.spots[index]),
                                  ]);
                                }).toList(),
                                lineBarsData: lineBarsData,
                                lineTouchData: LineTouchData(
                                  enabled: model.tooltipEnabled,
                                  touchCallback: (resp) {
                                    if (model.tooltipEnabled !=
                                        resp.touchInput.down) {
                                      model.tooltipEnabled =
                                          resp.touchInput.down;
                                      model.setState();
                                    }
                                  },
                                  getTouchedSpotIndicator:
                                      (LineChartBarData barData,
                                          List<int> spotIndexes) {
                                    return spotIndexes.map((index) {
                                      return TouchedSpotIndicatorData(
                                        FlLine(
                                          color:
                                              AppColors.active.withOpacity(0.5),
                                        ),
                                        FlDotData(
                                            show: true,
                                            getDotPainter: (spot, percent,
                                                barData, index) {
                                              return FlDotCirclePainter(
                                                radius: 6,
                                                color: AppColors.active,
                                                strokeWidth: 2,
                                                strokeColor:
                                                    AppColors.generalShapesBg,
                                              );
                                            }),
                                      );
                                    }).toList();
                                  },
                                  //handleBuiltInTouches: true,
                                  //touchCallback: (LineTouchResponse touchResponse) {},
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipItems: (List<LineBarSpot> bars) {
                                      return bars.map((e) {
                                        var item =
                                            model.data!.sparkline[e.x.toInt()];
                                        String? dateText;
                                        switch (model.selectedRangeIndex) {
                                          case 0:
                                            dateText = item.date
                                                .toStringYMD_hm()
                                                .split(' ')
                                                .last;
                                            break;
                                          case 1:
                                            dateText =
                                                item.date.toStringYMD_hm();
                                            break;
                                          default:
                                            dateText = item.date.toStringDMY();
                                        }
                                        return LineTooltipItem(
                                          '$FIAT_CURRENCY_LITERAL${e.y.toStringWithFractionDigits(2)}',
                                          Theme.of(context)
                                              .textTheme
                                              .bodyText1!,
                                          children: [
                                            // TextSpan(
                                            //     text: '\n$dateText',
                                            //     style: Theme.of(context)
                                            //         .textTheme
                                            //         .caption),
                                          ],
                                        );
                                      }).toList();
                                    },
                                    tooltipBgColor:
                                        AppColors.primaryBg.withOpacity(0.1),
                                    fitInsideHorizontally: true,
                                    fitInsideVertically: false,
                                    showOnTopOfTheChartBoxArea:
                                        model.tooltipEnabled,
                                    maxContentWidth: 300,
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  leftTitles: SideTitles(
                                    getTextStyles: (_, __) =>
                                        Theme.of(context).textTheme.caption!,
                                    showTitles: false,
                                    interval: model.maxElement(
                                      model.data?.sparkline ?? [],
                                    ),
                                  ),
                                  bottomTitles: SideTitles(
                                    interval: model.chartInterval,
                                    showTitles: true,
                                    getTextStyles: (_, __) =>
                                        Theme.of(context).textTheme.caption!,
                                    getTitles: model.getTitlesForChart,
                                  ),
                                ),
                                gridData: FlGridData(
                                  verticalInterval: 5,
                                  drawVerticalLine: true,
                                  drawHorizontalLine: false,
                                ),
                              ),
                              swapAnimationDuration:
                                  Duration(milliseconds: 150), // Optional
                              swapAnimationCurve: Curves.linear, // Optional
                            ),
                          ),
                        ),
                      );
                    }(),
            ),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.primaryBg
                    : AppColors.secondaryBG_gray,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: () {
                  var items = <Widget>[];
                  var vals = ['1D', '1W', '1M', '6M', '12M'].indexed();
                  for (var btn in vals) {
                    items.add(GestureDetector(
                      onTap: () {
                        if (model.isLoading == false &&
                            model.selectedRangeIndex != btn[0]) {
                          model.selectedRangeIndex = btn[0];
                          model.loadMarkets(coingeckoId);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 18),
                        decoration: BoxDecoration(
                          color: model.selectedRangeIndex == btn[0]
                              ? AppColors.generalShapesBg
                              : Colors.transparent,
                          //=color: AppColors.generalShapesBg,
                          borderRadius: BorderRadius.circular(20),
                          // border: Border.all(color: AppColors.primaryBg, width: 1),
                        ),
                        child: Text('${btn[1]}',
                            style: btn[0] == model.selectedRangeIndex
                                ? Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(fontSize: 14)
                                : Theme.of(context).textTheme.subtitle2),
                      ),
                    ));
                    if (btn[0] != vals.length - 1 &&
                        model.selectedRangeIndex != btn[0] + 1 &&
                        model.selectedRangeIndex != btn[0]) {
                      items.add(Container(
                        width: 1.5,
                        color: AppColors.secondaryBG,
                        height: 20,
                      ));
                    }
                  }
                  return items;
                }(),
              ),
            )
          ],
        );
      },
    );
  }
}

class TokenMarketsModel extends BaseViewModel {
  late Map<int, List<dynamic>> indexesRanges;
  TokenMarketsModel() {
    indexesRanges = {
      0: [1, 'hourly', _getTitles_1D, 6.0],
      1: [7, 'hourly', _getTitles_1W, 24.0],
      2: [30, 'daily', _getTitles_1M, 6.0],
      3: [180, 'monthly', _getTitles_6M, 30.0],
      4: [360, 'monthly', _getTitles_12M, 60.0],
    };
  }
  final _coingecko = locator<CoingeckoApi>();
  CoinMarkets? data;
  double? chartInterval = 6;

  double? maxHeight;
  bool tooltipEnabled = false;
  bool isLoading = false;
  int selectedRangeIndex = 0;
  loadMarkets(String id) async {
    isLoading = true;
    setState();
    var indexAndRange = indexesRanges[selectedRangeIndex]!;
    data = (await _coingecko.loadCoinMarkets(id, FIAT_CURRENCY_SYMBOL,
            indexAndRange[0] as int, indexAndRange[1] as String))
        .load;
    getTitlesForChart = indexAndRange[2];
    chartInterval = indexAndRange[3];
    isLoading = false;

    notifyListeners();
  }

  double? maxElement(List<SparklineEntity?> list) {
    if (list.length != 0) {
      var result = 0.0;
      list.forEach((element) {
        if (element!.value.toDouble() > result)
          result = element.value.toDouble();
      });
      return result / 50;
    }
    return null;
  }

  String Function(double)? getTitlesForChart;

  String _getTitles_1D(double value) {
    var item = data!.sparkline[value.toInt()];
    return item.date.toStringDMY_hm().split(' ').last;
  }

  String _getTitles_1W(double value) {
    var item = data!.sparkline[value.toInt()];
    return item.date.toStringDMY().split('.').sublist(0, 2).join('.');
  }

  String _getTitles_1M(double value) {
    var item = data!.sparkline[value.toInt()];
    return item.date.toStringDMY().split('.').sublist(0, 2).join('.');
  }

  String _getTitles_6M(double value) {
    var item = data!.sparkline[value.toInt()];
    return item.date.toStringDMY().split('.').sublist(1, 2).first;
  }

  String _getTitles_12M(double value) {
    var item = data!.sparkline[value.toInt()];
    return item.date.toStringDMY().split('.').sublist(1, 2).first;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
