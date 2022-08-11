import 'package:binance_chain/binance_chain.dart';
import 'package:voola/core/api/binance_chain/BCApi.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/dex/DexMainScreen.dart';

class DexOrderHistoryModel extends BaseViewModel {
  DexMainModel dexMainModel;
  DexOrderHistoryModel(this.dexMainModel);
  final accManager = locator<AccountManager>();
  final _api = locator<BinanceChainApi>();
  List<Order>? openOrders;
  List<Order>? closedOrders;

  Future<void> loadClosedOrders() async {
    setState(ViewState.Busy);

    var address =
        accManager.allAccounts[dexMainModel.selectedAccIndex].bcWallet.address;

    var resp = await Future.wait(
        [_api.getClosedOrdersMini(address!), _api.getClosedOrders(address)]);

    closedOrders = resp[0].load.order! + resp[1].load.order!;

    closedOrders?.sort((left, right) {
      var compare = DateTime.parse(left.transactionTime!)
          .compareTo(DateTime.parse(right.transactionTime!));
      return compare == 0 ? 0 : -compare;
    });
    setState(ViewState.Idle);
  }

  Future<void> loadOpenOrders() async {
    setState(ViewState.Busy);
    var address =
        accManager.allAccounts[dexMainModel.selectedAccIndex].bcWallet.address;

    var resp = await Future.wait(
        [_api.getOpenOrdersMini(address!), _api.getOpenOrders(address)]);

    openOrders = resp[0].load.order! + resp[1].load.order!;

    openOrders?.sort((left, right) {
      var compare = DateTime.parse(left.transactionTime!)
          .compareTo(DateTime.parse(right.transactionTime!));
      return compare == 0 ? 0 : -compare;
    });

    setState(ViewState.Idle);
  }

  Future<void> cancelOrder(
      BuildContext context, String orderId, String symbol) async {
    setState(ViewState.Busy);
    var cancelOrderMsg = CancelOrderMsg(
      wallet: dexMainModel
          .accManager.allAccounts[dexMainModel.selectedAccIndex].bcWallet,
      order_id: orderId,
      symbol: symbol,
    );
    var resp = await _api.cancelOrder(cancelOrderMsg);
    if (resp.ok) {
      Flushbar.success(title: S.current.success).show();
    } else
      Flushbar.error(title: resp.errorMessage ?? S.current.error).show();
    setState(ViewState.Idle);
  }
}

class OrderHistoryTile extends StatelessWidget {
  Order order;
  bool open;
  DexOrderHistoryModel model;
  OrderHistoryTile(this.order, this.open, this.model, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tt = Theme.of(context).textTheme;
    var spl = order.symbol!.split('_');

    var pairSymbol =
        '${spl.first.split('-').first}/${spl.last.split('-').first}';
    var targetSymbol = spl.first.split('-').first;
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          //Navigator.of(context).push(MaterialPageRoute(builder: (_) => TxDetailsScreen(tx, token)));
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 76,
          decoration: BoxDecoration(
              color: order.side == 1
                  ? AppColors.tokenCardPriceUp
                  : AppColors.tokenCardPriceDown,
              borderRadius: BorderRadius.circular(24)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppColors.secondaryBG,
                      borderRadius: BorderRadius.circular(16)),
                  child: order.side == 1
                      ? AppIcons.arrow_income(30, AppColors.text)
                      : AppIcons.arrow_outcome(30, AppColors.text),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          order.side == 1
                              ? S.of(context).buy
                              : S.of(context).sell,
                          style: tt.bodyText2,
                          overflow: TextOverflow.fade,
                          softWrap: true,
                          maxLines: 1,
                        )),
                        Text(
                            '${Decimal.parse(order.cumulateQuantity!).toStringWithFractionDigits(2)} ${order.symbol?.split('_')[order.side == 1 ? 0 : 1]}')
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      DateTime.tryParse(order.orderCreateTime ?? '')
                              ?.toStringDMY() ??
                          '',
                      style: tt.subtitle2,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      maxLines: 1,
                    )
                  ],
                ),
              ),
              if (open)
                GestureDetector(
                  onTap: () {
                    model.cancelOrder(context, order.orderId!, order.symbol!);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    decoration:
                        BoxDecoration(color: AppColors.tokenCardPriceUp),
                    child: Icon(Icons.delete_outline,
                        size: 22, color: AppColors.text),
                  ),
                )
            ],
          ),
        ));
  }
}
