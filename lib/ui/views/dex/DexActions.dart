import 'package:binance_chain/binance_chain.dart';
import 'package:voola/core/api/binance_chain/BCApi.dart';

import 'package:voola/core/token/DexPair.dart';

import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/dex/DexMainScreen.dart';

enum ExchangeActionMode { Buy, Sell }

class DexActions extends StatelessWidget {
  ExchangeActionsModel model;
  DexActions(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ExchangeActionsModel>(
      onModelReady: (model) {},
      model: model,
      builder: (context, model, child) {
        return model.state == ViewState.Busy
            ? Column(
                children: [TBCCLoader()],
              )
            : Column(
                children: [
                  DexTextField(
                    title: S.of(context).priceToken(model.dexMainModel
                        .marketPairModel.selectedMarketPair.right.symbol
                        .split('-')
                        .first),
                    controls: true,
                    controller: model.priceController,
                    onMinusTap: model.minusPrice,
                    onPlusTap: model.plusPrice,
                    onChanged: model.onPriceChanged,
                  ),
                  if (model.priceFieldError)
                    Text('${model.priceFieldErrorText ?? ''}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: AppColors.red, height: 1.5)),
                  SizedBox(height: 6),
                  DexTextField(
                    title: S.of(context).amountToken(model.dexMainModel
                        .marketPairModel.selectedMarketPair.left.symbol
                        .split('-')
                        .first),
                    controls: true,
                    controller: model.amountController,
                    onMinusTap: model.minusAmount,
                    onPlusTap: model.plusAmount,
                    onChanged: model.onAmountChanged,
                  ),
                  if (model.amountFieldError)
                    Text('${model.amountFieldErrorText ?? ''}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: AppColors.red, height: 1.5)),
                  SizedBox(height: 6),
                  DexTextField(
                    title:
                        '${S.of(context).total} ${(model.mode == ExchangeActionMode.Buy ? model.dexMainModel.marketPairModel.selectedMarketPair.right : model.dexMainModel.marketPairModel.selectedMarketPair.left).symbol.split('-').first}',
                    controls: false,
                    controller: model.totalController,
                    onChanged: (_) {},
                  ),
                  if (!model.enoughBalance)
                    Text(S.of(context).notEnoughTokens,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: AppColors.red, height: 1.5)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      for (var percent in ['25', '50', '75', '100'])
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  model.percentage(Decimal.parse(
                                      percent.startsWith('1')
                                          ? '1'
                                          : '0.$percent'));
                                },
                                behavior: HitTestBehavior.opaque,
                                child: DexPercentBtn('$percent%'))),
                    ].separate<Widget>(SizedBox(width: 8)),
                  ),
                ],
              );
      },
    );
  }
}

class ExchangeActionsModel extends BaseViewModel {
  DexMainModel dexMainModel;
  late ExchangeActionMode mode;

  bool priceFieldError = false;
  String? priceFieldErrorText;
  bool amountFieldError = false;
  String? amountFieldErrorText;

  Decimal? _total;
  set total(Decimal? val) {
    _total = val;
    totalController.text = (val ?? 0).toString();
  }

  Decimal? get total => _total;

  TextEditingController totalController = TextEditingController();

  bool enoughBalance = true;
  late BuildContext context;
  ExchangeActionsModel(this.dexMainModel);
  Decimal? dPrice;
  TextEditingController priceController = TextEditingController();

  Decimal? dAmount;
  TextEditingController amountController = TextEditingController();

  void reset() {
    dPrice = null;
    dAmount = null;
    priceController.text = '';
    amountController.text = '';
  }

  void onPriceChanged(value, [bool parse = true]) {
    if (parse) dPrice = Decimal.tryParse(value) ?? Decimal.zero;
    if (dPrice != null) {
      if (mode == ExchangeActionMode.Buy) {
        if (dPrice != null) total = dPrice! * (dAmount ?? Decimal.zero);
      } else {
        total = dAmount;
      }
    }
    validateAll();
    setState();
    //dexMainModel.marketPairModel.selectedMarketPairTicker.lastPrice
  }

  void onAmountChanged(value, [bool parse = true]) {
    if (parse) dAmount = Decimal.tryParse(value) ?? Decimal.zero;
    if (dAmount != null) {
      if (mode == ExchangeActionMode.Buy) {
        if (dAmount != null) total = dAmount! * (dPrice ?? Decimal.zero);
      } else {
        total = dAmount;
      }
    }
    validateAll();

    setState();
  }

  void plusPrice() {
    var pair = dexMainModel.marketPairModel.selectedMarketPair;
    dPrice = (dPrice ?? Decimal.zero) + pair.tickSize;
    checkpriceCorr(pair);

    priceController.text = dPrice?.toStringWithFractionDigits(
            pair.tickSize.scale,
            shrinkZeros: true) ??
        '';
    onPriceChanged(null, false);
  }

  void minusPrice() {
    var pair = dexMainModel.marketPairModel.selectedMarketPair;

    dPrice = (dPrice ?? Decimal.zero) - pair.tickSize;
    checkpriceCorr(pair);
    priceController.text = dPrice?.toStringWithFractionDigits(
            pair.tickSize.scale,
            shrinkZeros: true) ??
        '';
    onPriceChanged(null, false);
  }

  void plusAmount() {
    var pair = dexMainModel.marketPairModel.selectedMarketPair;
    dAmount = (dAmount ?? Decimal.zero) + pair.lotSize;
    checkAmountCorr(pair);

    amountController.text = dAmount?.toStringWithFractionDigits(
            pair.lotSize.scale,
            shrinkZeros: true) ??
        '';
    onAmountChanged(null, false);
  }

  void minusAmount() {
    var pair = dexMainModel.marketPairModel.selectedMarketPair;

    dAmount = (dAmount ?? Decimal.zero) - pair.lotSize;
    checkAmountCorr(pair);
    amountController.text = dAmount?.toStringWithFractionDigits(
            pair.lotSize.scale,
            shrinkZeros: true) ??
        '';
    onAmountChanged(null, false);
  }

  void percentage(Decimal multipler) {
    var pair = dexMainModel.marketPairModel.selectedMarketPair;

    if (mode == ExchangeActionMode.Buy) {
      var bal = dexMainModel.rightBal;
      if (dPrice != null && dPrice != Decimal.zero) {
        dAmount = bal!.balance / dPrice! * multipler;
      } else {
        return;
        //List<double> askOrBid;
        //if (mode == ExchangeActionMode.Buy) {
        //  askOrBid = dexMainModel.chartsModel.depthModel.bookAsks.first;
        //} else {
        //  askOrBid = dexMainModel.chartsModel.depthModel.bookBids.first;
        //}
        //priceController.text = '${askOrBid[0]}';
        //onPriceChanged('${askOrBid[0]}');
        //dAmount = bal.balance / dPrice * multipler;
        //onAmountChanged(null, false);
      }
    } else {
      var bal = dexMainModel.leftBal;
      dAmount = bal!.balance * multipler;
    }

    this.amountController.text =
        dAmount?.toStringWithFractionDigits(pair.lotSize.scale) ?? '0';
    onAmountChanged(this.amountController.text);
  }

  void checkpriceCorr(DexMarketPair pair) {
    if (dPrice! < pair.tickSize) dPrice = pair.tickSize;
  }

  void checkAmountCorr(DexMarketPair pair) {
    if (pair.left.standard == 'BEP8') {
      if (dAmount! < Decimal.one) {
        dAmount = Decimal.one;
      }
    } else if (dAmount! < pair.lotSize) dAmount = pair.lotSize;
  }

  void changeMode(ExchangeActionMode mode) {
    this.mode = mode;
    setState();
  }

  bool validateAll() {
    var pair = dexMainModel.marketPairModel.selectedMarketPair;

    var price = Decimal.tryParse(priceController.text);

    if (price == null || price < pair.tickSize) {
      priceFieldError = true;
      priceFieldErrorText = S.of(context).typeCorrectPrice;
    } else {
      priceFieldError = false;
      priceFieldErrorText = null;
    }

    var am = Decimal.tryParse(amountController.text);
    if (am != null && pair.left.standard == 'BEP8' && am < Decimal.one) {
      amountFieldError = true;
      amountFieldErrorText = S.of(context).amountMoreThan('1');
    } else if (am == null || am < pair.lotSize) {
      amountFieldError = true;
      amountFieldErrorText = S.of(context).typeCorrectAmount;
    } else {
      amountFieldError = false;
      amountFieldErrorText = null;
    }

    WalletBalance? bal;
    if (mode == ExchangeActionMode.Buy) {
      bal = dexMainModel.rightBal;
    } else {
      bal = dexMainModel.leftBal;
    }
    enoughBalance = total! <= bal!.balance;
    setState();
    return !(amountFieldError || priceFieldError) && enoughBalance;
  }

  Future<void> placeOrder() async {
    setState(ViewState.Busy);
    try {
      if (validateAll()) {
        var orderMsg = NewOrderMsg(
            wallet: dexMainModel
                .accManager.allAccounts[dexMainModel.selectedAccIndex].bcWallet,
            price: dPrice,
            quantity: dAmount,
            side: mode == ExchangeActionMode.Buy
                ? OrderSide.BUY()
                : OrderSide.SELL(),
            order_type: OrderType.LIMIT(),
            time_in_force: TimeInForce.GOOD_TILL_EXPIRE(),
            symbol: dexMainModel.marketPairModel.selectedMarketPair.symbol);

        var resp = await locator<BinanceChainApi>().placeOrder(orderMsg);
        if (resp.ok)
          Flushbar.success(title: S.of(context).orderPlaced)
              .show(Duration(seconds: 4));
        //dexMainModel.statusModel.setSuccess(S.of(context).orderPlaced, Duration(seconds: 4));
        else
          Flushbar.error(title: S.of(context).error).show(Duration(seconds: 6));
      }
    } catch (e, st) {
      print('$e: $st');
    }
    setState(ViewState.Idle);
  }

  @override
  void dispose() {
    priceController.dispose();
    amountController.dispose();
    super.dispose();
  }
}

class DexTextField extends StatelessWidget {
  final String title;
  final bool controls;
  final TextEditingController controller;
  final void Function()? onMinusTap;
  final void Function()? onPlusTap;
  final void Function(String value) onChanged;

  const DexTextField(
      {required this.title,
      required this.onChanged,
      this.controls = true,
      required this.controller,
      this.onMinusTap,
      this.onPlusTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.generalShapesBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (controls)
            GestureDetector(
              onTap: onMinusTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 16),
                  child: AppIcons.minus(24)),
            ),
          Expanded(
            child: Column(
              children: [
                Text('$title',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: AppColors.inactiveText)),
                TextFormField(
                  controller: controller,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          if (controls)
            GestureDetector(
              onTap: onPlusTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 30),
                  child: AppIcons.plus(24)),
            ),
        ],
      ),
    );
  }
}
