import 'dart:convert';

import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:voola/core/api/foil/model/KeyApi.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/core/authentication/UserAccount.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'model.dart';

class ConfirmTx extends StatefulWidget {
  final FOILTransferModel model;
  const ConfirmTx(this.model, {Key? key}) : super(key: key);

  @override
  State<ConfirmTx> createState() => _ConfirmTxState();
}

class _ConfirmTxState extends State<ConfirmTx> {
  var balances;
  var seed;
  var pubAddress;
  bool isValid = false;
  var addressTo;
  Decimal? totalFee;
  List<UserAccount> allAccounts = <UserAccount>[];

  Future validateSeed() async {
    final url = 'http://185.63.191.197:9088/addresses/importaccountseed/${seed.toString()}';
    try {
      final response = await get(Uri.parse(url));
      // final responseData = json.decode(response.body);
      // print("responseData of validate seed $responseData");
      if(response.body == pubAddress || response.body.isEmpty){
        return isValid = true;
      } else {
        return isValid = false;
      }
    } catch (error) {
      throw error;
    }
  }

  Future getSeed(mnemonic) async {
    final url = 'http://185.63.191.197:9088/addresses/makepairbyphrase/';
    try {
      final response = await post(Uri.parse(url), body: mnemonic);
      final responseData = json.decode(response.body);
      print("responseData ${responseData.toString()}");
      seed = KeyApi.fromJson(responseData).seed;
      Future.delayed(Duration(milliseconds: 1000), () {
        validateSeed();
      });
    } catch (error) {
      throw error;
    }
  }

  prepareSeedAddress(model){
    var mnemonic = model.accManager.allAccounts[0].mnemonic;
    getSeed(mnemonic);
    addressTo = model.addressTo.toString();
    pubAddress = model.account.foilWallet.address;
  }


  @override
  Widget build(BuildContext context) {
    return BaseView<FOILTransferModel>(
      model: widget.model,
      onModelReady: (model) {
        prepareSeedAddress(model);
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
                                      '${model.account.foilWallet.address}  (${model.account.accountAlias})'),
                                  SizedBox(height: 8),
                                  InnerPageTile(S.of(context).to,
                                      model.addressTo.toString()),
                                  SizedBox(height: 8),
                                  InnerPageTile(S.of(context).amount,
                                      model.value.toString()),
                                  SizedBox(height: 8),
                                  InnerPageTile(S.of(context).networkFee,
                                      '${model.totalFee} FOIL  ${model.totalFeeInFiat!.toStringWithFractionDigits(2)} $FIAT_CURRENCY_SYMBOL'),
                                  SizedBox(height: 8),
                                  InnerPageTile('Max total',
                                      '${model.maxTotal?.toStringWithFractionDigits(2)} $FIAT_CURRENCY_SYMBOL'),
                                  SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                          if (model.enoughFOILTotal != true) ...[
                            Text(S.of(context).notEnoughTokensFee('FOIL'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: AppColors.red)),
                            SizedBox(height: 12),
                          ],
                          Button(
                            value: S.of(context).confirmTransfer,
                            onTap: () async {
                              if (model.enoughFOILTotal == true && isValid == true) {
                                model.sendTransactionToFoil(context);
                              } else {
                                print("-----------------");
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
