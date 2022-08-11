import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../shared.dart';
import '../../../../BaseView.dart';
import '../../../../widgets/SharedWidgets.dart';
import 'SmartCardAttachModel.dart';

class SmartCardAttachNFC extends StatelessWidget {
  SmartCardAttachModel model;

  SmartCardAttachNFC(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SmartCardAttachModel>(
        onModelReady: (model) async {
          model.checkNFCReady(context);
        },
        model: model,
        builder: (context, model, child) {
          return CScaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                S.of(context).writeSmartCard,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            body: Padding(
                padding: EdgeInsets.fromLTRB(15, 30, 15, 15),
                child: () {
                  if (model.nfcState == 1) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            S.of(context).nfcUnavailable,
                            style: Theme.of(context).textTheme.subtitle1,
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Button(
                                value: S.of(context).refresh,
                                onTap: () {
                                  model.checkNFCReady(context);
                                }),
                          )
                        ]);
                  }
                  if (model.nfcState == 0) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            S.of(context).attachYourCard,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: AppIcons.arrow(
                                MediaQuery.of(context).size.width * 0.7),
                          ),
                        ]);
                  }
                  if (model.nfcState == 2) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.check,
                          color: AppColors.active,
                          size: 70,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            S.of(context).youAttachedCard,
                            style: Theme.of(context).textTheme.subtitle1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Button(
                              value: S.of(context).confirm,
                              onTap: () {
                                Navigator.of(context)
                                  ..pop()
                                  ..pop();
                              }),
                        )
                      ],
                    );
                  }
                }()),
          );
        });
  }
}
