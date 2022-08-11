import 'package:voola/core/authentication/AuthService.dart';
import 'package:voola/core/settings/UserSettings.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/MainScreen.dart';
import 'package:voola/ui/views/settings/SettingsMainModel.dart';

class LoginScreen extends StatelessWidget {
  bool confirmation;
  //UserAccount acc;
  //LoginScreen({this.acc, this.confirmation = false, Key key}) : super(key: key);
  LoginScreen({this.confirmation = false, Key? key}) : super(key: key);
  var _settings = locator<SettingsMainModel>();
  @override
  Widget build(BuildContext context) {
    return BaseView<LoginScreenModel>(
      onModelReady: (model) {
        //model.acc = acc;
        _settings.checkingFaceOrFingerprint();
        model.confirmation = confirmation;
        if (_settings.isFace ||
            _settings
                .isFingerprint) if (locator<UserSettings>().biometricsEnabled) {
          model.biometricsAuth(context);
        }
      },
      builder: (context, model, child) {
        return CScaffold(
          appBar: CAppBar(
            elevation: 0,
            title: Text(model.confirmation
                ? S.of(context).confirmAction
                : S.of(context).logIn),
            //actions: acc == null
            //    ? <Widget>[
            //        Padding(
            //          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            //          child: GestureDetector(
            //            onTap: () async {
            //              var confirmed = (await showConfirmationDialog(S.of(context).logOutAllQuestion, S.of(context).checkSavedMnemonicAll)).confirmed;

            //              if (confirmed) {
            //                locator<AuthService>().logoutAll(context);
            //              }
            //            },
            //            child: Icon(Icons.exit_to_app),
            //          ),
            //        )
            //      ]
            //    : null,
          ),
          body: model.state == ViewState.Busy
              ? TBCCLoader()
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(child: AppIcons.logo(70)),
                            TextFormField(
                              controller: model.passwordController,
                              decoration: generalTextFieldDecor(context,
                                  hintText: S.of(context).password),
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Button(
                                      value: confirmation
                                          ? S.of(context).confirm
                                          : S.of(context).logIn,
                                      onTap: () async {
                                        model.logIn(context);

                                        ///await locator<Storage>().resetAll();
                                      }),
                                ),
                                if (locator<UserSettings>()
                                    .biometricsEnabled) ...[
                                  SizedBox(width: 8),
                                  IconButton_(
                                    icon: AppIcons.fingerprint_scan(
                                        22, Colors.white),
                                    onTap: () async {
                                      if (_settings.isFace ||
                                          _settings.isFingerprint)
                                        model.biometricsAuth(context);
                                    },
                                  )
                                ],
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class LoginScreenModel extends BaseViewModel {
  var _authService = locator<AuthService>();
  late bool confirmation;
  final passwordController = TextEditingController();

  Future<void> logIn(BuildContext context) async {
    setState(ViewState.Busy);

    if (await _authService.checkPassword(passwordController.text)) {
      if (confirmation) {
        Navigator.of(context).pop(true);
      } else {
        //if (acc != null) {
        //  _authService.accountManager.currentAccount = acc;
        //}
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => MainAppScreen()), (_) => false);
      }
    } else {
      Flushbar.error(title: S.of(context).incorrectPassword).show();
    }
    setState(ViewState.Idle);
  }

  Future<void> biometricsAuth(BuildContext context) async {
    if (await _authService.biometricAuth(S.of(context).confirm)) {
      if (confirmation) {
        Navigator.of(context).pop(true);
      } else {
        //if (acc != null) {
        //  _authService.accountManager.currentAccount = acc;
        //}
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => MainAppScreen(),
          ),
          (_) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
}
