import 'package:flutter/material.dart';
import '../../../../../shared.dart';
import '../../../../BaseView.dart';
import '../../../../widgets/SharedWidgets.dart';
import 'SmartCardAttachModel.dart';
import 'SmartCardAttachPin.dart';

class SmartCardAttach1 extends StatefulWidget {
  const SmartCardAttach1({Key? key}) : super(key: key);

  @override
  _SmartCardAttach1State createState() => _SmartCardAttach1State();
}

class _SmartCardAttach1State extends State<SmartCardAttach1> {
  bool rulesCheckbox = false;
  bool checkboxErr = false;

  @override
  Widget build(BuildContext context) {
    return BaseView<SmartCardAttachModel>(onModelReady: (model) async {
      await model.checkCardOrdered(context);
    }, builder: (context, model, child) {
      return CScaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(S.of(context).attachSmartCard),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: model.state == ViewState.Busy
              ? CircularProgressIndicator()
              : model.cardOrdered
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          S.of(context).attachCardText1,
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "\n${S.of(context).attachCardText2}",
                          style: Theme.of(context).textTheme.subtitle1,
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Positioned.fill(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: checkboxErr
                                                ? AppColors.red
                                                : Colors.transparent),
                                      ),
                                    ),
                                  ),
                                ),
                                Checkbox(
                                  value: rulesCheckbox,
                                  onChanged: (value) {
                                    setState(() {
                                      rulesCheckbox = value ?? false;
                                      checkboxErr = false;
                                    });
                                  },
                                  checkColor: Colors.white,
                                  activeColor: AppColors.green,
                                ),
                              ],
                            ),
                            Text(
                              S.of(context).iUnderstood,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Button(
                            value: S.of(context).attachSmartCard,
                            onTap: () {
                              if (rulesCheckbox) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (_) => SmartCardAttachPin()));
                              } else {
                                setState(() {
                                  checkboxErr = true;
                                });
                              }
                            },
                          ),
                        )
                      ],
                    )
                  : Text(S.of(context).cardNotOrderedYet),
        ),
      );
    });
  }
}
