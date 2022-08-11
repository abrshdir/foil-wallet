import 'package:voola/core/authentication/AuthService.dart';
import 'package:voola/core/settings/UserSettings.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';

class SetPasswordModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _settings = locator<UserSettings>();
  bool? changePassword;
  Function? onDone;

  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  bool obscure = true;

  Future<void> setPassword(BuildContext context) async {
    setState(ViewState.Busy);
    await _authService.setPassword(repeatPasswordController.text);
    if (changePassword != true) {
      if (_settings.canCheckBiometrics) {
        var confirmed = (await showConfirmationDialog(
                S.of(context).biometrics, S.of(context).biometricsEnableAsk))
            .confirmed;

        if (confirmed) {
          var authenticated =
              await _authService.biometricAuth(S.of(context).confirmAction);
          if (authenticated) {
            _settings
              ..biometricsEnabled = true
              ..save();
          }
        }
      }
    }
    this.onDone?.call();
  }

  @override
  void dispose() {
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }
}

class SetPasswordScreen extends StatelessWidget {
  String btnValue;
  Function onDone;
  bool changePassword;
  SetPasswordScreen(this.btnValue, this.onDone, {this.changePassword = false});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<SetPasswordModel>(
      onModelReady: (model) {
        model.changePassword = changePassword;
        model.onDone = onDone;
      },
      builder: (context, model, child) {
        return CScaffold(
          appBar: CAppBar(
            elevation: 0,
            title: Text(S.of(context).password),
          ),
          body: model.state == ViewState.Busy
              ? TBCCLoader()
              : SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 40,
                                right: MediaQuery.of(context).size.width * 0.08,
                                left: MediaQuery.of(context).size.width * 0.08,
                              ),
                              child: Text(
                                S.of(context).passwordInfo,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        color: AppColors.text.withOpacity(0.6)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TextFormField(
                              controller: model.passwordController,
                              decoration: generalTextFieldDecor(context,
                                  hintText: S.of(context).password),
                              obscureText: model.obscure,
                              validator: (val) {
                                if (val?.length != null && val!.length < 8) {
                                  return S.of(context).passwordSymbolAmount;
                                }
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: model.repeatPasswordController,
                              decoration: generalTextFieldDecor(context,
                                  hintText: S.of(context).repeatPassword),
                              obscureText: model.obscure,
                              validator: (val) {
                                if (model.passwordController.text != val) {
                                  return S.of(context).passwordDoNotMatch;
                                }
                              },
                            ),
                            Spacer(),
                            Button(
                              value: btnValue,
                              onTap: () {
                                if (formKey.currentState?.validate() == true)
                                  model.setPassword(context);
                              },
                            )
                          ],
                        ),
                      )),
                ),
        );
      },
    );
  }
}
