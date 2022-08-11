import 'package:provider/provider.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/global_env.dart';

import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import '../../WalletMainScreen.dart';
import 'eth_Advanced.dart';
import 'eth_Transfer.dart';
import 'model.dart';

class ConfirmTx extends StatelessWidget {
  final ETHTransferModel model;
  const ConfirmTx(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ETHTransferModel>(
      onModelReady: (model) async {
        model.initAdvanced();
      },
      model: model,
      builder: (context, model, child) {
        return ChangeNotifierProvider.value(
            value: locator<AccountManager>(),
            child: Consumer<AccountManager>(builder: (_, __, ___) {
              model.balance = model.account.allBalances.firstWhere(
                  (element) => element.token == model.balance.token);
              return CScaffold(
                appBar: CAppBar(
                  elevation: 0,
                  title: Text(
                    '${S.of(context).confirm}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 20),
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
                body: model.state == ViewState.Busy
                    ? Center(child: CircularProgressIndicator())
                    : SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      '- ${model.value.toString()} ${model.balance.token.symbol}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(fontSize: 36),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '~ ${model.valueInFiat?.toStringWithFractionDigits(2)} $FIAT_CURRENCY_SYMBOL',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              color: AppColors.inactiveText,
                                              fontSize: 20),
                                    ),
                                    SizedBox(height: 16),
                                    InnerPageTile(S.of(context).from,
                                        '${model.account.ethWallet.address.hex}  (${model.account.accountAlias})'),
                                    SizedBox(height: 8),
                                    InnerPageTile(S.of(context).to,
                                        model.addressTo.toString()),
                                    SizedBox(height: 8),
                                    InnerPageTile(S.of(context).networkFee,
                                        '${model.totalFee} ETH  ${model.totalFeeInFiat!.toStringWithFractionDigits(2)} $FIAT_CURRENCY_SYMBOL'),
                                    SizedBox(height: 8),
                                    InnerPageTile('Max total',
                                        '${model.maxTotal?.toStringWithFractionDigits(2)} $FIAT_CURRENCY_SYMBOL'),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ),
                            if (model.enoughETHTotal != true) ...[
                              Text(S.of(context).notEnoughTokensFee('ETH'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: AppColors.red)),
                              SizedBox(height: 12),
                            ],
                            Button(
                              value: S.of(context).confirmTransfer,
                              onTap: () async {
                                if (model.enoughETHTotal == true) {
                                  model.sendTransaction(context);
                                }
                              },
                            ),
                            SizedBox(height: 8),
                            Button(
                              isOutLine: true,
                              value: S.of(context).edit,
                              onTap: () async {
                                Navigator.pop(context);
                              },
                            )
                          ]),
                        ),
                      ),
              );
            }));
      },
    );
  }
}
