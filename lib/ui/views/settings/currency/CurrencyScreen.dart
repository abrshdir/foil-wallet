import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/settings/SettingsMainModel.dart';
import 'package:voola/ui/views/wallet/WalletMainScreenModel.dart';

class CurrencyScreen extends StatelessWidget {
  final SettingsMainModel model;
  CurrencyScreen(this.model, {Key? key}) : super(key: key);
  bool needToReload = false;
  @override
  Widget build(BuildContext context) {
    return BaseView<SettingsMainModel>(
      model: model,
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            if (needToReload) {
              () async {
                locator<WalletMainScreenModel>().manualRefresh = true;

                await locator<AccountManager>().reloadTickers();
                locator<WalletMainScreenModel>().manualRefresh = false;
              }();
            }
            return true;
          },
          child: Scaffold(
              appBar: CAppBar(
                elevation: 0,
                title: Text(S.of(context).currency),
              ),
              body: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: FIAT_CURRENCIES.length,
                  itemBuilder: (context, index) {
                    var symbol = FIAT_CURRENCIES[index];

                    return GestureDetector(
                      onTap: () {
                        needToReload = true;
                        model.currencyChanged(symbol);
                      },
                      child: currencyCard(symbol),
                    );
                  })),
        );
      },
    );
  }

  Widget currencyCard(String symbol) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.secondaryBG,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 13),
              blurRadius: 18,
              color: AppColors.shadowColor,
            )
          ]),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 35,
              height: 25,
              child: SvgPicture.asset(
                'assets/images/flags/${symbol.toLowerCase()}.svg',
                fit: BoxFit.fill,
                clipBehavior: Clip.hardEdge,
              ),
            ),
          ),
          SizedBox(width: 25),
          Text('${symbol.toUpperCase()}'),
          Spacer(),
          CupertinoSwitch(
            value: symbol == FIAT_CURRENCY_SYMBOL,
            onChanged: (b) {
              needToReload = true;
              model.currencyChanged(symbol);
            },
            activeColor: AppColors.active,
          ),
        ],
      ),
    );
  }
}
