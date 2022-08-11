import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/core/token/utils.dart';

import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/settings/address_book/AddressBookPicker.dart';
import 'package:voola/ui/views/wallet/WalletMainScreen.dart';

import 'package:voola/ui/widgets/SharedWidgets.dart';

import '../../../premium/Pro_Premium.dart';
import 'eth_Advanced.dart';
import 'model.dart';
import 'eth_ConfirmTx.dart';

class ETHTransferScreen extends StatelessWidget {
  WalletBalance balance;
  int accountFrom;
  ETHTransferScreen(this.balance, this.accountFrom, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ETHTransferModel>(
      onModelReady: (model) async {
        model.balance = balance;
        model.account = model.accManager.allAccounts[accountFrom];
        model.ethBalance = model.account.coinBalances
            .firstWhere((b) => b.token.symbol == 'ETH');
        model.init();
      },
      builder: (context, model, child) {
        return ChangeNotifierProvider.value(
            value: locator<AccountManager>(),
            child: Consumer<AccountManager>(builder: (_, __, ___) {
              balance = model.account.allBalances
                  .firstWhere((element) => element.token == balance.token);
              model.balance = balance;
              model.ethBalance = model.account.coinBalances
                  .firstWhere((b) => b.token.symbol == 'ETH');

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
                              text:
                                  '${balance.token.symbol}${balance.token.standard != 'Native' ? ' - ${balance.token.standard}' : ''}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      fontSize: 20,
                                      color: AppColors.inactiveText)),
                        ]),
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
                        child: Form(
                          key: model.formKey1,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text('${S.of(context).balance}:'),
                                      //     Text(
                                      //         '${model.balance.balance} ${model.balance.token.symbol.split('-').first}'),
                                      //   ],
                                      // ),
                                      // SizedBox(height: 12),
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () async {
                                          var addressBookPick =
                                              await Navigator.of(context)
                                                  .push<String?>(
                                            PageTransition(
                                              child: AddressBookPickerScreen(
                                                  TokenNetwork.Ethereum),
                                              type: PageTransitionType
                                                  .rightToLeft,
                                            ),
                                          );
                                          if (addressBookPick != null) {
                                            model.controllerAddress.text =
                                                addressBookPick;
                                            model.addressTo =
                                                EthereumAddress.fromHex(
                                                    addressBookPick);
                                          }
                                        },
                                        child: InnerPageTile(
                                          null,
                                          'Open address book',
                                          actions: [AppIcons.chevron(22)],
                                          bradius: 16,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Stack(children: [
                                        TextFormField(
                                          controller: model.controllerAddress,
                                          validator: (val) => model.isAddrValid
                                              ? null
                                              : S.of(context).wrongAddr,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: generalTextFieldDecor(
                                              context,
                                              hintText: S
                                                  .of(context)
                                                  .addressOfRecipient,
                                              paddingRight: 86),
                                        ),
                                        Positioned(
                                          right: 46,
                                          top: 10,
                                          child: textFieldActionsButton(
                                              child: gradientIcon(
                                                  AppIcons.book_open(22)),
                                              onTap: () =>
                                                  model.pasteAddress(context)),
                                        ),
                                        Positioned(
                                          right: 10,
                                          top: 10,
                                          child: textFieldActionsButton(
                                              child: gradientIcon(
                                                  AppIcons.qr_code_scan(22)),
                                              onTap: () =>
                                                  model.scanAddressQr(context)),
                                        ),
                                      ]),
                                      SizedBox(height: 8),
                                      Stack(children: [
                                        TextFormField(
                                          controller: model.controllerValue,
                                          keyboardType: TextInputType.number,
                                          validator: (val) =>
                                              model.balanceEnough
                                                  ? null
                                                  : model.value == null
                                                      ? S
                                                          .of(context)
                                                          .typeCorrectAmount
                                                      : S
                                                          .of(context)
                                                          .notEnoughTokens,
                                          onChanged: (val) {
                                            var parsedVal =
                                                Decimal.tryParse(val);
                                            model.value = parsedVal;

                                            model.valueInFiat =
                                                parsedVal != null
                                                    ? model.value! *
                                                        model.balance.fiatPrice
                                                    : model.valueInFiat = null;

                                            model.setState();
                                          },
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: generalTextFieldDecor(
                                              context,
                                              hintText: S
                                                  .of(context)
                                                  .amountToken(
                                                      balance.token.symbol),
                                              paddingRight: 86),
                                        ),
                                        Positioned(
                                          right: 10,
                                          top: 10,
                                          child: textFieldActionsButton(
                                              child: gradientIcon(Text('Max')),
                                              onTap: () => model.setMax()),
                                        ),
                                      ]),
                                      SizedBox(height: 8),
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () async {
                                          if (model.formKey1.currentState
                                                  ?.validate() ==
                                              true)
                                            Navigator.of(context).push(
                                              PageTransition(
                                                  child:
                                                      ETHAdvancedScreen(model),
                                                  type: PageTransitionType
                                                      .rightToLeft),
                                            );
                                        },
                                        child: InnerPageTile(
                                          null,
                                          'Advenced',
                                          actions: [AppIcons.chevron(22)],
                                          bradius: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Button(
                                value: S.of(context).send +
                                    ' ${balance.token.symbol}${balance.token.standard != 'Native' ? ' - ${balance.token.standard}' : ''}',
                                onTap: () {
                                  if (model.formKey1.currentState?.validate() ==
                                      true)
                                    Navigator.of(context).push(
                                      PageTransition(
                                          child: ConfirmTx(model),
                                          type: PageTransitionType.rightToLeft),
                                    );
                                },
                              )
                            ]),
                          ),
                        ),
                      ),
              );
            }));
      },
    );
  }
}

class PremiumSmallWidget extends StatelessWidget {
  const PremiumSmallWidget({
    Key? key,
    required this.acc,
    required this.state,
  }) : super(key: key);

  final AccountManager acc;
  final ViewState state;

  @override
  Widget build(BuildContext context) {
    var active = false;
    var type = 'Premium';
    if (acc.accountType == AccType.Free) {
      active = false;
    } else {
      active = true;
      switch (acc.accountType) {
        case AccType.Pro:
          type = 'PRO';
          break;
        case AccType.Premium:
          type = 'Premium';
          break;
        case AccType.Free:
          // TODO: Handle this case.
          break;
      }
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (state != ViewState.Busy) {
          if (active) {
            Flushbar.success(title: S.of(context).youProNow(type)).show();
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => Pro_PremiumView()));
          }
        }
      },
      child: Stack(
        children: [
          Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(8),
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: active ? null : AppColors.altGradient,
                color: active ? AppColors.primary : null,
                border: Border.all(
                    width: 1, color: AppColors.inactiveText.withOpacity(0.1))),
            child: AppIcons.crown(26, active ? Colors.white : AppColors.text),
          ),
        ],
      ),
    );
  }
}
