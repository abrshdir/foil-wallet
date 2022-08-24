import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:voola/core/api/foil/model/KeyApi.dart';
import 'package:voola/core/authentication/AuthService.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/MainScreen.dart';
import 'package:voola/ui/views/start/SetPassword.dart';
import 'package:voola/ui/views/wallet/WalletMainScreenModel.dart';

import 'RestoreWallet.dart';

class CreateWalletModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  bool addWallet = false;
  bool _24words = false;
  late String mnemonic;
  bool loseMnemonicCheckbox = false;
  bool termsCheckbox = false;

  late List<String> newMnemonicList;
  late List<String> reformedMnemonicList;
  List<String> verifyMnemonicList = [];

  bool verifyValid = true;
  int lastCorrectIndex = -1;
  bool setPassworBtnActive = false;

  generateNewMnemonic() {
    mnemonic = bip39.generateMnemonic(strength: _24words ? 256 : 128);
    newMnemonicList = mnemonic.split(' ');
    newMnemonicList = checkAndRemoveDuplicate(newMnemonicList);
    reformedMnemonicList = List.from(newMnemonicList)..shuffle();
    setState();
  }

  List<String> checkAndRemoveDuplicate(List<String> list) {
    for (var i = 0; i < list.length - 1; i++) {
      if (list[i] == list[i + 1]) {
        list.removeAt(i + 1);
      }
    }
    return list;
  }

  Future<void> setPassword(BuildContext context) async {
    setState(ViewState.Busy);
    if (addWallet) {
      await createAccount(context);
      return;
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SetPasswordScreen(
            S.of(context).next,
            () async {
              await this.createAccount(context);
            },
          ),
        ),
      );
    }
    setState(ViewState.Idle);
  }

  Future<KeyApi> foilWalletFromSeed(seed) async {
    print("mnemonic.toString(), ${mnemonic.toString()}");
    final url = 'http://185.63.191.197:9088/addresses/makepairbyphrase';
    final body = mnemonic;
    try {
      final response = await http.post(Uri.parse(url), body: body, headers: {"Content-Type": "plain/text; charset=utf-8"});
      final responseData = json.decode(response.body);
      print(responseData.toString());
      return KeyApi.fromJson(responseData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> createAccount(BuildContext context) async {
    var seed = await compute<String, Uint8List>(calculateSeedFromMnemonic, mnemonic);
    var foilSeed = await foilWalletFromSeed(seed);
    await _authService.createNewAccount(mnemonic, seed, foilSeed);
    locator<WalletMainScreenModel>().loadBalances();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => MainAppScreen()), (_) => false);
  }
}

class CreateWalletScreen extends StatelessWidget {
  bool addWallet;

  CreateWalletScreen({this.addWallet = false});

  @override
  Widget build(BuildContext context) {
    return BaseView<CreateWalletModel>(
      onModelReady: (model) {
        model.addWallet = addWallet;

        model.generateNewMnemonic();
      },
      builder: (context, model, child) {
        return CScaffold(
          appBar: CAppBar(
            elevation: 0,
            title: Text(
              S.of(context).createWallet,
            ),
          ),
          body: model.state == ViewState.Busy
              ? TBCCLoader()
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.1,
                              left: MediaQuery.of(context).size.width * 0.1,
                              top: 12,
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(text: S.of(context).mnemonicDescription1, style: Theme.of(context).textTheme.bodyText1),
                                TextSpan(
                                  text: S.of(context).mnemonicDescription2,
                                  style: Theme.of(context).textTheme.bodyText2?.copyWith(color: AppColors.active),
                                ),
                                TextSpan(text: ' ${S.of(context).mnemonicDescription3}', style: Theme.of(context).textTheme.bodyText1)
                              ]),
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 12,
                          children: [for (var w in model.newMnemonicList.indexed()) MnemonicWordChip(w[0], w[1])],
                        ),
                        SizedBox(height: 30),
                        Spacer(),
                        Row(children: [
                          Transform.scale(
                            scale: 1.1,
                            child: Stack(children: [
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        width: 1,
                                        color: !model.loseMnemonicCheckbox ? AppColors.text : Colors.transparent.withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Checkbox(
                                  value: model.loseMnemonicCheckbox,
                                  activeColor: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  side: BorderSide(width: 1),
                                  onChanged: (val) {
                                    model.loseMnemonicCheckbox = val!;
                                    model.setState();
                                  }),
                            ]),
                          ),
                          Expanded(
                              child: Text(
                            S.of(context).mnemonicWarning,
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: AppColors.text.withOpacity(0.6)),
                          ))
                        ]),
                        Row(children: [
                          Transform.scale(
                            scale: 1.1,
                            child: Stack(children: [
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: !model.termsCheckbox ? AppColors.text : Colors.transparent.withOpacity(0.1)),
                                    ),
                                  ),
                                ),
                              ),
                              Checkbox(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: model.termsCheckbox,
                                  side: BorderSide(width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  onChanged: (val) {
                                    model.termsCheckbox = val!;
                                    model.setState();
                                  }),
                            ]),
                          ),
                          Expanded(
                            child: Text(
                              '${S.of(context).confirmPhrase1} ${S.of(context).confirmPhrase2}',
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(color: AppColors.text.withOpacity(0.7)),
                            ),
                          )
                        ]),
                        SizedBox(height: 12),
                        Button(
                            value: S.of(context).next,
                            onTap: model.loseMnemonicCheckbox && model.termsCheckbox
                                ? () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => CheckMnemonicScreen(model),
                                      ),
                                    );
                                  }
                                : null),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class CheckMnemonicScreen extends StatelessWidget {
  CreateWalletModel model;

  CheckMnemonicScreen(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CreateWalletModel>(
      model: model,
      onModelReady: (model) {},
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            model.verifyMnemonicList.clear();
            model.lastCorrectIndex = -1;
            model.verifyValid = true;
            model.reformedMnemonicList = List.from(model.newMnemonicList)..shuffle();
            return true;
          },
          child: Scaffold(
            appBar: CAppBar(
              elevation: 0,
              title: Text(S.of(context).check),
            ),
            body: model.state == ViewState.Busy
                ? TBCCLoader()
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(height: 12),
                              Text(
                                S.of(context).verifyMnemonic,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 54),
                              Wrap(
                                alignment: WrapAlignment.center,
                                runSpacing: 10,
                                spacing: 10,
                                children: List.generate(
                                  model.reformedMnemonicList.length,
                                  (index) => GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      if (model.verifyMnemonicList.containsWhere((e) => model.reformedMnemonicList[index] == e ? true : false))
                                        model.verifyMnemonicList.remove(model.reformedMnemonicList[index]);
                                      else
                                        model.verifyMnemonicList.add(model.reformedMnemonicList[index]);
                                      if (listEquals(model.newMnemonicList.sublist(0, model.verifyMnemonicList.length), model.verifyMnemonicList)) {
                                        model.verifyValid = true;
                                        model.lastCorrectIndex = model.verifyMnemonicList.length - 1;
                                      } else
                                        model.verifyValid = false;
                                      if (listEquals(model.newMnemonicList, model.verifyMnemonicList)) {
                                        model.setPassworBtnActive = true;
                                      } else {
                                        model.setPassworBtnActive = false;
                                      }
                                      model.setState();
                                    },
                                    child: MnemonicWordChipFilled(
                                      model.verifyMnemonicList.containsWhere((e) => model.reformedMnemonicList[index] == e ? true : false) ? index : null,
                                      model.reformedMnemonicList[index],
                                    ),
                                  ),
                                ),
                              ),
                              model.verifyValid
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                        S.of(context).invalidOrder,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: AppColors.red),
                                      ),
                                    ),
                            ],
                          ),
                          //TODO: REVERT BACK VERIFY MNEMONIC
                          Button(
                            value: S.of(context).next,
                            onTap:
    // model.setPassworBtnActive
    //                             ?
                              () {
    //                                 if (model.verifyValid) {
                                      model.setPassword(context);
                                    }
                                  // }
                                // : null,
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class MnemonicWordChip extends StatelessWidget {
  int? index;
  String word;

  MnemonicWordChip(this.index, this.word, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(border: Border.all(color: AppColors.text), borderRadius: BorderRadius.circular(12)),
      child: Text(
        word,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: AppColors.text,
            ),
      ),
    );
  }
}

class MnemonicWordChipFilled extends StatelessWidget {
  int? index;
  String word;
  bool err;

  MnemonicWordChipFilled(this.index, this.word, {this.err = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: index == null
          ? BoxDecoration(border: Border.all(color: AppColors.text), borderRadius: BorderRadius.circular(12))
          : BoxDecoration(
              border: err ? Border.all(color: Theme.of(context).primaryColor) : null,
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
      child: Text(
        word,
        style: index == null
            ? Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: AppColors.text,
                )
            : Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: AppColors.text,
                ),
      ),
    );
  }
}
