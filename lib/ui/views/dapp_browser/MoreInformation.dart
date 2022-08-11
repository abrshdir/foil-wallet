import 'package:voola/global_env.dart';
import 'package:voola/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DAppBrowserScreen.dart';

class MoreInformation extends StatelessWidget {
  int mode;
  String? contactId;
  final DAppBrowserScreenModel modelDapp;
  MoreInformation(
      {this.mode = 1, this.contactId, Key? key, required this.modelDapp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<MoreInformationModel>(
      onModelReady: (model) {
        model.model = modelDapp;
      },
      builder: (context, model, child) {
        return CScaffold(
          appBar: CAppBar(
            elevation: 0,
            title: Text(model.model.pageTitle ?? ''),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: AspectRatio(
                          aspectRatio: 16 / 10,
                          child: model.getImage() == null
                              ? Container(
                                  color: AppColors.primary,
                                )
                              : Image.asset(
                                  model.getImage()!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.altGradient,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            width: 1,
                            color: AppColors.inactiveText.withOpacity(0.08),
                          ),
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 7,
                          child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextTile('Введение'),
                                      TextTileDesc(
                                        model.getDesc() ?? 'нет информации',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextTile('Работает на:'),
                                      TextTileDesc(
                                        model.getNetWork() ?? 'нет информации',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextTile('Провайдер:'),
                                      TextTileDesc(
                                        model.getProvider() ?? 'нет информации',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextTile('Сайт'),
                                      TextTileUrl(
                                        model.getUrl(),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(
                          child: Button(
                            value: S.of(context).openOrders,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            model.isFavorite = !model.isFavorite!;
                            model.setState();
                          },
                          child: Container(
                            child: Icon(
                              model.isFavorite!
                                  ? Icons.star_rate_rounded
                                  : Icons.star_border_rounded,
                              color: AppColors.primary,
                              size: model.isFavorite! ? 28 : 22,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                width: 1,
                                color: AppColors.primary,
                              ),
                            ),
                            height: 52,
                            width: 52,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TextTileDesc extends StatelessWidget {
  const TextTileDesc(
    this.text, {
    Key? key,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        maxLines: 1,
        textAlign: TextAlign.end,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: AppColors.inactiveText),
      ),
    );
  }
}

class TextTileUrl extends StatelessWidget {
  const TextTileUrl(
    this.text, {
    Key? key,
  }) : super(key: key);
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (text != null) launch(text!);
        },
        child: Text(
          text ?? 'нет информации',
          maxLines: 1,
          textAlign: TextAlign.end,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}

class TextTile extends StatelessWidget {
  const TextTile(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}

class MoreInformationModel extends BaseViewModel {
  late DAppBrowserScreenModel model;
  late bool? isFavorite = false;

  String? getDesc() {
    if (model.dappScreenModel.launchScreenModel.currDapp?.description != null)
      return model.dappScreenModel.launchScreenModel.currDapp?.description!
          .split(' ')[0];
    else
      return null;
  }

  String? getNetWork() {
    return model.dappScreenModel.launchScreenModel.currDapp?.network
        .toString()
        .split('.')[0]
        .toString();
  }

  String? getProvider() {}
  String? getUrl() {
    return model.dappScreenModel.launchScreenModel.currDapp?.url.origin;
  }

  String? getImage() {
    return model.dappScreenModel.launchScreenModel.currDapp?.customImageUrl;
  }
}
