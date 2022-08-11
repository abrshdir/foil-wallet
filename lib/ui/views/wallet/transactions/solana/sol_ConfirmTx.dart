import 'package:provider/provider.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'model.dart';

class ConfirmTx extends StatelessWidget {
  final SOLTransferModel model;
  const ConfirmTx(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SOLTransferModel>(
      model: model,
      onModelReady: (model) {
        model.calcTotalFee();
        model.maxTotal = model.totalFeeInFiat! + model.valueInFiat!;
      },
      builder: (context, model, child) {
        return ChangeNotifierProvider.value(
            value: locator<AccountManager>(),
            child: Consumer<AccountManager>(builder: (_, __, ___) {
              model.balance = model.account.allBalances.firstWhere(
                  (element) => element.token == model.balance.token);
              return CScaffold(
                appBar: CAppBar(
                  elevation: 0,
                  title: RichText(
                    text: TextSpan(
                        text: '${S.of(context).send} ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 20),
                        children: [
                          TextSpan(
                              text: model.balance.token.symbol,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      fontSize: 20,
                                      color: AppColors.inactiveText))
                        ]),
                  ),
                ),
                body: model.state == ViewState.Busy
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                      '${model.account.solWallet.address}  (${model.account.accountAlias})'),
                                  SizedBox(height: 8),
                                  InnerPageTile(S.of(context).to,
                                      model.addressTo.toString()),
                                  SizedBox(height: 8),
                                  InnerPageTile(S.of(context).networkFee,
                                      '${model.totalFee} SOL  ${model.totalFeeInFiat!.toStringWithFractionDigits(2)} $FIAT_CURRENCY_SYMBOL'),
                                  SizedBox(height: 8),
                                  InnerPageTile('Max total',
                                      '${model.maxTotal?.toStringWithFractionDigits(2)} $FIAT_CURRENCY_SYMBOL'),
                                  SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                          if (model.enoughSOLTotal != true) ...[
                            Text(S.of(context).notEnoughTokensFee('SOL'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: AppColors.red)),
                            SizedBox(height: 12),
                          ],
                          Button(
                            value: S.of(context).confirmTransfer,
                            onTap: () async {
                              if (model.enoughSOLTotal == true) {
                                model.sendTransaction(context);
                              }
                            },
                          )
                        ]),
                      ),
              );
            }));
      },
    );
  }
}
