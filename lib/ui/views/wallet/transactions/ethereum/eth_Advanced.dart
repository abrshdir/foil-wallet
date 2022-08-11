import 'package:voola/global_env.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/wallet/transactions/ethereum/model.dart';

import '../../WalletMainScreen.dart';
import 'eth_Transfer.dart';

class ETHAdvancedScreen extends StatelessWidget {
  final ETHTransferModel model;
  const ETHAdvancedScreen(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ETHTransferModel>(
      onModelReady: (model) {},
      model: model,
      builder: (context, model, child) {
        return Scaffold(
            appBar: CAppBar(
              elevation: 0,
              title: Text(S.of(context).advanced),
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
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Do not change these settings if you don`t know what they mean',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: AppColors.yellow),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
                          child: Text('Gas price')),
                      TextFormField(
                        controller: model.controllerGasPrice,
                        keyboardType: TextInputType.number,
                        //validator: (val) => model.isAddrValid ? null : 'Wrong address',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration:
                            generalTextFieldDecor(context, suffixText: 'gwei'),
                      ),
                      SizedBox(height: 8),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          gasPriceSelector(context, model.gasPrices!.average!,
                              'Slow', model),
                          SizedBox(height: 8),
                          gasPriceSelector(context, model.gasPrices!.fast!,
                              'Average', model),
                          SizedBox(height: 8),
                          gasPriceSelector(context, model.gasPrices!.fastest!,
                              'Fast', model),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(12, 20, 0, 10),
                          child: Text('Gas limit')),
                      TextFormField(
                        controller: model.controllerMaxGas,
                        keyboardType: TextInputType.number,
                        //validator: (val) => model.isAddrValid ? null : 'Wrong address',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: generalTextFieldDecor(context),
                      ),
                      SizedBox(height: 8),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(12, 20, 0, 10),
                          child: Text('Nonce')),
                      TextFormField(
                        controller: model.controllerNonce,
                        keyboardType: TextInputType.number,
                        //validator: (val) => model.isAddrValid ? null : 'Wrong address',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: generalTextFieldDecor(context),
                      ),
                      SizedBox(height: 8),
                      if (model.balance.token.standard == 'Native' &&
                          model.balance.token.symbol == 'ETH') ...[
                        Padding(
                            padding: const EdgeInsets.fromLTRB(12, 20, 0, 10),
                            child: Text('Tx Data')),
                        TextFormField(
                          controller: model.controllerData,
                          //validator: (val) => model.isAddrValid ? null : 'Wrong address',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: generalTextFieldDecor(context),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  Widget gasPriceSelector(
          c, Decimal gasPrice, String type, ETHTransferModel model) =>
      GestureDetector(
        onTap: () {
          model.gasPrice = gasPrice;
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.generalShapesBg,
            borderRadius: BorderRadius.circular(20),
            border: model.gasPrice == gasPrice
                ? Border.all(color: AppColors.active)
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('$type'),
                        Text('  $gasPrice gwei',
                            style: Theme.of(c).textTheme.bodyText1),
                      ],
                    ),
                    () {
                      var fee = model.getTotalFee(gasPrice);

                      return Row(children: [
                        Text('Fee: $fee ETH',
                            style: Theme.of(c).textTheme.bodyText1),
                        Text(
                            '    ${(fee * model.ethBalance.fiatPrice).toStringWithFractionDigits(2)} $FIAT_CURRENCY_SYMBOL',
                            style: Theme.of(c).textTheme.bodyText1),
                      ]);
                    }()
                  ],
                ),
              ),
              RadioSelectorCircle(active: model.gasPrice == gasPrice)
            ],
          ),
        ),
      );
}
