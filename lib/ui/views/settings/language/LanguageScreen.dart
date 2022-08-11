import 'package:voola/shared.dart';

import '../SettingsMainModel.dart';

class LanguageScreen extends StatelessWidget {
  SettingsMainModel model;
  LanguageScreen(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SettingsMainModel>(
      model: model,
      onModelReady: (model) {},
      builder: (context, model, child) {
        return CScaffold(
            appBar: CAppBar(
              elevation: 0,
              title: Text(S.of(context).language),
            ),
            body: model.state == ViewState.Busy
                ? TBCCLoader()
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.separated(
                        itemCount: model.localesList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              model.changeLocale(model.localesList[index][1]);
                            },
                            child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.generalShapesBg,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(model.localesList[index][0]),
                                    Localizations.localeOf(context) ==
                                            model.localesList[index][1]
                                        ? Icon(Icons.check,
                                            color: AppColors.active)
                                        : Container()
                                  ],
                                )),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10)),
                  ));
      },
    );
  }
}
