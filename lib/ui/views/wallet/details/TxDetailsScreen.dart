import 'package:flutter/services.dart';
import 'package:voola/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import 'HistoryModel.dart';

class TxDetailsScreen extends StatelessWidget {
  HistoryTransaction tx;
  WalletToken token;
  TxDetailsScreen(this.tx, this.token);
  @override
  Widget build(BuildContext context) {
    return CScaffold(
      appBar: CAppBar(
        title: Text(() {
          if (tx.type == TransactionType.ETH_ContractCall)
            return S.of(context).smartContractCall;
          else
            return tx.side! ? S.of(context).received : S.of(context).sent;
        }()),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: tx.side!
                      ? AppIcons.arrow_income(30, AppColors.green)
                      : AppIcons.arrow_outcome(30, AppColors.red),
                ),
                Text(
                  '${tx.value} ${tx.symbol}',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: tx.side! ? AppColors.green : AppColors.red),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      tx.side!
                          ? InnerPageTile(S.of(context).from, tx.from ?? '')
                          : InnerPageTile(S.of(context).to, tx.to ?? ''),
                      SizedBox(height: 8),
                      InnerPageTile(S.of(context).networkFee,
                          '${tx.fee} ${tx.feeSymbol} '),
                      SizedBox(height: 8),
                      ...() {
                        if ([Blockchain.Eth, Blockchain.BSC]
                            .contains(tx.blockchain)) {
                          return [
                            InnerPageTile(S.of(context).confirmations,
                                '${tx.eth_info?.confirmations}'),
                            SizedBox(height: 8),
                            InnerPageTile('Nonce', '${tx.eth_info?.nonce}'),
                            SizedBox(height: 8),
                          ];
                        } else
                          return [];
                      }(),
                      InnerPageTile(S.of(context).txTime,
                          tx.timestamp?.toStringDMY_hms() ?? ''),
                      SizedBox(height: 8),
                      InnerPageTile(
                        'TxHash',
                        tx.txHash ?? '',
                        actions: [
                          GestureDetector(
                              onTap: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: tx.txHash));
                                Flushbar.success(
                                        title: S
                                            .of(context)
                                            .copiedToClipboard('TxHash'))
                                    .show();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AppIcons.copy(24, AppColors.active),
                              ))
                        ],
                      ),
                      SizedBox(height: 8),
                      ...() {
                        if (tx.blockchain == Blockchain.BC) {
                          return [
                            InnerPageTile('Memo', '${tx.description}'),
                            SizedBox(height: 8),
                          ];
                        } else
                          return [];
                      }()
                    ],
                  ),
                ),
              ),
            ),
            Button(
              value: S.of(context).details,
              onTap: () {
                String url;
                if (tx.blockchain == Blockchain.BC) {
                  url = 'https://explorer.binance.org/tx/${tx.txHash}';
                } else if (tx.blockchain == Blockchain.Eth) {
                  url =
                      'https://blockchair.com/ethereum/transaction/${tx.txHash}';
                } else {
                  //BSC
                  url = 'https://bscscan.com/tx/${tx.txHash}';
                }
                launch(url);
              },
            ),
          ],
        ),
      ),
    );
  }
}
