import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../generated/l10n.dart';
import '../../../../BaseView.dart';
import '../../../../widgets/SharedWidgets.dart';
import 'SmartCardAttachModel.dart';
import 'SmartCardAttachNFC.dart';

class SmartCardAttachPin extends StatelessWidget {
  SmartCardAttachPin({Key? key}) : super(key: key);

  GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BaseView<SmartCardAttachModel>(
        onModelReady: (model) {},
        builder: (context, model, child) {
          return CScaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                S.of(context).enterPin,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _key,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          S.of(context).cardPinText1,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      TextFormField(
                        controller: model.controller1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: generalTextFieldDecor(context,
                            hintText: S.of(context).enterPin),
                        validator: (value) {
                          if ((value?.length ?? 0) < 6) {
                            return S.of(context).sixDigitsNeeded;
                          }
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: TextFormField(
                            controller: model.controller2,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: generalTextFieldDecor(context,
                                hintText: S.of(context).repeatPin),
                            validator: (value) {
                              if (model.controller1.text != value) {
                                return S.of(context).pinCodesNotMatch;
                              }
                            },
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          S.of(context).cardPinText2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Button(
                          value: S.of(context).continue_,
                          onTap: () {
                            if (_key.currentState?.validate() ?? false)
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => SmartCardAttachNFC(model),
                              ));
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
