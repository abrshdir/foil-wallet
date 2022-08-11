import 'package:voola/locator.dart';
import 'package:voola/shared.dart';

import 'UpdateModel.dart';

class ForceUpdateScreen extends StatelessWidget {
  ForceUpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<UpdateViewModel>(
      onModelReady: (model) {
        model.checkUpdate();
      },
      builder: (context, model, child) {
        return Theme(
          data: DARK_THEME,
          child: Scaffold(
            backgroundColor: Color(0xFF13131A),
            appBar: CAppBar(
              centerTitle: true,
              elevation: 0,
              title: Text(
                S.of(context).updateAvailable,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: AppColors.text, fontWeight: FontWeight.w500),
              ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16),
                child: model.state == ViewState.Busy
                    ? TBCCLoader()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Center(
                          //  child: GestureDetector(
                          //    onTap: () {
                          //      Navigator.of(context).push(MaterialPageRoute(fullscreenDialog: true, builder: (_) => WhatsNewScreen()));
                          //    },
                          //    behavior: HitTestBehavior.opaque,
                          //    child: Container(
                          //      decoration: BoxDecoration(
                          //        border: Border.all(color: AppColors.active),
                          //        borderRadius: BorderRadius.circular(20),
                          //      ),
                          //      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          //      child: Text(
                          //        S.of(context).whatsNew,
                          //        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: AppColors.active),
                          //      ),
                          //    ),
                          //  ),
                          //),
                          Expanded(
                            child: Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: AppIcons.download_cloud(
                                        160, AppColors.active),
                                  ),
                                  ...() {
                                    if (model.updateState == 2)
                                      return [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              S.of(context).updateDownloading,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      color: DarkColors.text),
                                            ),
                                            Text(
                                              '${model.downloadedPercent.toInt()}%',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      color: DarkColors.text),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Stack(children: [
                                            LinearProgressIndicator(
                                              value:
                                                  model.downloadedPercent / 100,
                                              minHeight: 5,
                                              backgroundColor: Colors.grey[800],
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      AppColors.active),
                                            )
                                          ]),
                                        ),
                                      ];
                                    else if (model.updateState == 3)
                                      return [
                                        Text(S.of(context).checkingIntegrity),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Stack(children: [
                                            LinearProgressIndicator(
                                              value: null,
                                              backgroundColor: Colors.grey[800],
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      AppColors.active),
                                            )
                                          ]),
                                        ),
                                      ];
                                    else if (model.updateState == 4)
                                      return [
                                        Text(
                                          S.of(context).updateDownlodaded,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(color: DarkColors.text),
                                          textAlign: TextAlign.center,
                                        ),
                                      ];
                                    else
                                      return [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 40, bottom: 50),
                                          child: Text(
                                            S.of(context).forceUpdate,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    color: AppColors.text
                                                        .withOpacity(0.8),
                                                    height: 1.3),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ];
                                  }(),
                                ],
                              ),
                            )),
                          ),
                          () {
                            if (model.updateState == 1)
                              return Button(
                                value: S.of(context).download,
                                onTap: () {
                                  model.downloadUpdate(context);
                                },
                              );
                            else if (model.updateState == 4)
                              return Button(
                                value: S.of(context).installUpdate,
                                onTap: () {
                                  model.installUpdate();
                                },
                              );
                            else
                              return Container(height: 0);
                          }()
                        ],
                      )),
          ),
        );
      },
    );
  }
}

//class WhatsNewScreen extends StatelessWidget {
//  WhatsNewScreen({Key? key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return BaseView<WhatsNewModel>(
//      onModelReady: (model) {
//        model.loadWhatsNewInfo();
//      },
//      builder: (context, model, child) {
//        return Scaffold(
//          appBar: AppBar(
//            elevation: 0,
//            title: Text(S.of(context).whatsNew),
//          ),
//          body: model.state == ViewState.Busy
//              ? TbccLoader()
//              : SingleChildScrollView(
//                  padding: const EdgeInsets.all(16),
//                  child: Html(
//                    data: model.whatsNew.text_en ?? model.whatsNew.text_ru ?? model.whatsNew.text_zh,
//                  ),
//                ),
//        );
//      },
//    );
//  }
//}

//class WhatsNewModel extends BaseViewModel {
//  WhatsNew whatsNew;
//  Future<void> loadWhatsNewInfo() async {
//    setState(ViewState.Busy);
//    var resp = await locator<TBCCApi>().whatsNewLastVer(S.currLocale.languageCode);
//    whatsNew = resp.load;
//    setState(ViewState.Idle);
//  }
//}

//class DownloadUpdateWidget extends StatelessWidget {
//  UpdateViewModel model;
//  DownloadUpdateWidget({Key key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return BaseView<UpdateViewModel>(onModelReady: (model) async {
//      model = model;
//      model.checkUpdate();
//    }, builder: (context, model, child) {
//      return Container(
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          children: [
//            ...getWidgetBody(context),
//          ],
//        ),
//      );
//    });
//  }
//
//  List<Widget> getWidgetBody(BuildContext context) {
//    if (model.updateState == 1) {
//      return [
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: [
//            Text(S.of(context).updateAvailable, style: Theme.of(context).textTheme.bodyText2),
//            GestureDetector(
//              behavior: HitTestBehavior.opaque,
//              onTap: () {
//                model.downloadUpdate(context);
//              },
//              child: Container(
//                decoration: BoxDecoration(
//                  color: Colors.transparent,
//                  borderRadius: BorderRadius.circular(100),
//                ),
//                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                child: Text(
//                  S.of(context).download,
//                  textAlign: TextAlign.center,
//                  style: Theme.of(context).textTheme.bodyText2,
//                ),
//              ),
//            )
//          ],
//        ),
//        //Divider(color: AppColors.black)
//      ];
//    } else if (model.updateState == 2) {
//      return [
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: [
//            Text(
//              S.of(context).updateDownloading,
//              style: Theme.of(context).textTheme.bodyText2,
//            ),
//            Text(
//              '${model.downloadedPercent.toInt()}%',
//              style: Theme.of(context).textTheme.bodyText2,
//            ),
//          ],
//        ),
//        Padding(
//          padding: const EdgeInsets.only(top: 10),
//          child: Stack(children: [
//            LinearProgressIndicator(
//              value: model.downloadedPercent / 100,
//              backgroundColor: Colors.orange[50],
//              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
//            )
//          ]),
//        ),
//        //Divider(color: AppColors.black)
//      ];
//    } else if (model.updateState == 3) {
//      return [
//        Text(S.of(context).checkingIntegrity),
//        Padding(
//          padding: const EdgeInsets.only(top: 10),
//          child: Stack(children: [
//            LinearProgressIndicator(
//              value: null,
//              backgroundColor: Colors.orange[50],
//              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
//            )
//          ]),
//        ),
//      ];
//    } else if (model.updateState == 4) {
//      return [
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: [
//            Text(
//              S.of(context).updateDownlodaded,
//              style: Theme.of(context).textTheme.bodyText2,
//            ),
//            GestureDetector(
//              behavior: HitTestBehavior.opaque,
//              onTap: () {
//                model.installUpdate();
//              },
//              child: Container(
//                decoration: BoxDecoration(
//                  color: Colors.transparent,
//                  borderRadius: BorderRadius.circular(100),
//                ),
//                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                child: Text(S.of(context).installUpdate, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2),
//              ),
//            )
//          ],
//        ),
//        //Divider(color: widget.force ? AppColors.black : AppColors.black)
//      ];
//    } else
//      return [Container(height: 0)];
//  }
//}
//
