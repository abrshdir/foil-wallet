import 'package:voola/global_env.dart';
import 'package:voola/shared.dart';

import 'package:flutter_svg/svg.dart';
import 'package:voola/ui/styles/AppTheme.dart';
import 'package:voola/ui/views/wallet/WalletMainScreenModel.dart';
import 'package:voola/ui/widgets/SharedWidgets.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../WalletMainScreen.dart';
import '../transactions/ethereum/eth_Transfer.dart';
import 'HistoryModel.dart';
import 'TxDetailsScreen.dart';

class WalletDetails extends StatelessWidget {
  WalletBalance balance;
  int accIndex;
  WalletMainScreenModel model;

  WalletDetails(this.balance, this.accIndex, this.model);

  @override
  Widget build(BuildContext context) {
    var tt = Theme.of(context).textTheme;
    return CScaffold(
      appBar: CAppBar(
        title: Row(
          children: [
            Text('${balance.token.symbol} '),
            Text(
              '${balance.token.standard}',
              style: tt.bodyText2?.copyWith(color: AppColors.inactiveText),
            ),
          ],
        ),
        actions: [
          Center(
            child: PremiumSmallWidget(
              acc: model.accManager,
              state: model.state,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: NotificationWidget(
                onTap: () {},
                isNewNotification: true,
              ),
            ),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: ((context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 265,
              toolbarHeight: 265,
              floating: true,
              pinned: false,
              snap: false,
              leading: const SizedBox(),
              flexibleSpace: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: balance.token.icon(80)),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: AutoSizeText(
                            '${balance.balance} ${balance.token.symbol}',
                            maxLines: 1,
                            minFontSize: 22,
                            maxFontSize: 26,
                          ),
                        ),
                        Text(
                          '${FIAT_CURRENCY_LITERAL} ${balance.fiatBalance.toStringWithFractionDigits(2)}',
                          style: tt.headline6!
                              .copyWith(color: AppColors.inactiveText),
                        ),
                        //Padding(
                        //  padding: const const EdgeInsets.all(5.0),
                        //  child: AccountPNL('2.34', '5'),
                        //),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var t in [
                              [
                                AppIcons.arrow_outcome(24, AppColors.text),
                                () {}
                              ],
                              [
                                AppIcons.arrow_income(24, AppColors.text),
                                () {}
                              ],
                              [
                                Icon(Icons.more_horiz,
                                    size: 24, color: AppColors.text),
                                () {}
                              ]
                            ])
                              ControlButtons(
                                icon: t[0] as Widget?,
                                onTap: t[1] as Function,
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ];
        }),
        body: HistoryListView(balance.token, accIndex),
      ),
    );
  }
}

class HistoryListView extends StatelessWidget {
  WalletToken token;
  int accIndex;
  HistoryListView(this.token, this.accIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<TxHistoryModel>(
      onModelReady: (model) {
        model.loadHistory(token, context, accIndex);
      },
      builder: (context, model, child) {
        if (model.state == ViewState.Busy)
          return TBCCLoader();
        else if (model.transactionsListWidgets?.isEmpty == true)
          return Center(
            child: Text(S.of(context).noTransactions),
          );
        else
          return RefreshIndicator(
            onRefresh: () async {
              await model.loadHistory(token, context, accIndex);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: model.transactionsListWidgets?.length ?? 0,
              itemBuilder: (context, index) {
                return model.transactionsListWidgets![index];
              },
            ),
          );
      },
    );
  }
}

class ControlButtons extends StatelessWidget {
  Widget? icon;
  Function? onTap;
  ControlButtons({Key? key, this.icon, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap as void Function()?,
      child: Container(
        margin: const EdgeInsets.all(14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 13),
                color: AppColors.shadowColor,
                blurRadius: 18),
          ],
          gradient: AppColors.altGradient,
        ),
        child: icon,
      ),
    );
  }
}

class HistoryTile extends StatelessWidget {
  HistoryTransaction tx;
  WalletToken token;
  HistoryTile(this.tx, this.token);
  @override
  Widget build(BuildContext context) {
    var tt = Theme.of(context).textTheme;
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => TxDetailsScreen(tx, token)));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 76,
          padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
          decoration: BoxDecoration(
              color: tx.type == TransactionType.ETH_ContractCall
                  ? AppColors.secondaryBG_gray
                  : tx.side!
                      ? AppColors.tokenCardPriceUp
                      : AppColors.tokenCardPriceDown,
              borderRadius: BorderRadius.circular(24)),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.secondaryBG,
                    borderRadius: BorderRadius.circular(16)),
                child: (tx.type == TransactionType.ETH_ContractCall &&
                        (token.symbol == 'ETH' || token.symbol == 'BNB'))
                    ? AppIcons.smart_contract(30, AppColors.text)
                    : tx.side!
                        ? AppIcons.arrow_income(30, AppColors.text)
                        : AppIcons.arrow_outcome(30, AppColors.text),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          () {
                            if (tx.type == TransactionType.ETH_ContractCall &&
                                (token.symbol == 'ETH' ||
                                    token.symbol == 'BNB')) {
                              return S.of(context).smartContractCall;
                            } else {
                              return tx.side!
                                  ? S.of(context).received
                                  : S.of(context).sent;
                            }
                          }(),
                          style: tt.bodyText2,
                          overflow: TextOverflow.fade,
                          softWrap: true,
                          maxLines: 1,
                        )),
                        // Spacer(),
                        Text(
                            '${tx.value!.toStringWithFractionDigits(6, shrinkZeros: true)} ${tx.symbol}',
                            style: tt.bodyText2!.copyWith(
                                color: tx.side!
                                    ? AppColors.green
                                    : AppColors.red)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      () {
                        if (tx.type == TransactionType.ETH_ContractCall &&
                            (token.symbol == 'ETH' || token.symbol == 'BNB')) {
                          return 'Contract ${shortFmtAddr(tx.to!)}';
                        } else if (tx.side!) {
                          return '${S.of(context).from}: ${shortFmtAddr(tx.from!)}';
                        } else {
                          return '${S.of(context).to}: ${shortFmtAddr(tx.to!)}';
                        }
                      }(),
                      style: Theme.of(context).textTheme.caption,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
