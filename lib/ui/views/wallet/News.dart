import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:voola/core/api/tbcc/TBCCApi.dart';
import 'package:voola/core/api/tbcc/models/News.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/core/authentication/AuthService.dart';
import 'package:voola/core/blockchain/binance_smart_chain/contracts/BEP20_abi.dart';
import 'package:voola/core/settings/AppSettings.dart';
import 'package:voola/core/settings/UserSettings.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:voola/ui/views/premium/Pro_Premium.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

import '../dapp_browser/DAppLaunchScreen.dart';

class NewsListViewModel extends BaseViewModel {
  var tbccApi = locator<TBCCApi>();
  List<NewsModel>? news;
  Future<void> loadNews() async {
    setState(ViewState.Busy);
    news = (await tbccApi
            .loadNews(locator<UserSettings>().language?.languageCode ?? 'en'))
        .load;
    setState(ViewState.Idle);
  }

  String getDate(DateTime? date) {
    if (date != null) {
      if (date.day == DateTime.now().day) {
        var result = DateTime.now().hour - date.hour;
        if (result <= 4 || result > 0) {
          if (result < 1) {
            var result = DateTime.now().minute - date.minute;
            return result.toString() + 'min ago';
          }
          return result.toString() + 'h ago';
        }
      }
      return date.toStringDMY();
    } else {
      return '';
    }
  }
}

class NewsListView extends StatelessWidget {
  final NewsListViewModel model;
  const NewsListView(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tt = Theme.of(context).textTheme;
    return BaseView<NewsListViewModel>(
      model: model,
      onModelReady: (model) {
        model.loadNews();
      },
      builder: (context, model, _) {
        return model.state == ViewState.Busy
            ? TBCCLoader()
            : Column(
                children: [
                  if (locator<AppSettings>().lottery) ...[
                    LotteryBanner(),
                    Divider(
                      color: AppColors.active,
                      thickness: 1.5,
                    )
                  ],
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (c, i) => SizedBox(height: 12),
                      padding: const EdgeInsets.all(16),
                      itemCount: model.news!.length,
                      itemBuilder: (c, i) {
                        var post = model.news?[i];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: NewsDetailsView(post!),
                              ),
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 18,
                                  color: AppColors.shadowColor,
                                  offset: Offset(0, 13),
                                )
                              ],
                              gradient: AppColors.altGradientRotate,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: post!.previewImageUrl ?? '',
                                    width: 68,
                                    height: 68,
                                    placeholder: (ctx, url) =>
                                        const BaseImagePlaceHolderWidget(),
                                    errorWidget: (ctx, url, err) =>
                                        const BaseImagePlaceHolderWidget(),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${post.header}',
                                              style: tt.bodyText2,
                                            ),
                                          ),
                                          Text(
                                            model.getDate(post.timestamp),
                                            style: tt.caption,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '${post.preview}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: tt.bodyText1!.copyWith(
                                          fontSize: 14,
                                          height: 1.4,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
      },
    );
  }
}

class NewsDetailsView extends StatelessWidget {
  final NewsModel post;
  const NewsDetailsView(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tt = Theme.of(context).textTheme;
    var mqsize = MediaQuery.of(context).size;
    return CScaffold(
      appBar: CAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 4),
                Text(
                  post.timestamp == null
                      ? 'No time'
                      : post.timestamp?.toStringDMYT(post.timestamp!) ?? '',
                  style: tt.bodyText1!.copyWith(fontSize: 14),
                ),
                SizedBox(height: 12),
                Text(
                  '${post.header ?? ''}',
                  style: tt.bodyText2!.copyWith(fontSize: 20),
                ),
                SizedBox(height: 24),
                LotteryBanner(),
                SizedBox(height: 24),
              ],
            ),
            Text(
              post.content ?? '',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}

class LotteryBanner extends StatelessWidget {
  const LotteryBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageTransition(
            type: PageTransitionType.rightToLeft, child: LotteryScreen()));
      },
      behavior: HitTestBehavior.opaque,
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}

class LotteryScreen extends StatelessWidget {
  LotteryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LotteryScreenModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) {
        //model.lotterySettings.status = 1;
        return CScaffold(
            appBar: CAppBar(
              title: Text(S.of(context).lottery),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: model.state == ViewState.Busy
                  ? TBCCLoader()
                  : () {
                      if (model.lotterySettings.status == 0) {
                        return SingleChildScrollView(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/lottery.jpg',
                                        width: 70,
                                      ),
                                      Expanded(
                                        child: Text(
                                          S.of(context).lotteryDesc1,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  )),
                              for (var item in [
                                S.of(context).lotteryRule1,
                                S.of(context).lotteryRule2,
                                S.of(context).lotteryRule3(
                                    '${model.lotterySettings.ticketPrice}'),
                                S.of(context).lotteryRule4,
                              ])
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    item,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  S.of(context).lotteryDesc3(
                                        '${model.lotterySettings.startTickets.toStringDMY()} - ${model.lotterySettings.endTickets.toStringDMY()}',
                                        '${model.lotterySettings.startCount.toStringDMY()} - ${model.lotterySettings.endCount.toStringDMY()}',
                                      ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: AppColors.active),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  S.of(context).lotteryDesc4(
                                      '${model.lotterySettings.end.toStringDMY()}'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: AppColors.active),
                                ),
                              ),
                              SizedBox(height: 30),
                              Center(
                                child: AccountSelector((index) {
                                  model
                                    ..accIndex = index
                                    ..init();
                                }, initIndex: model.accIndex),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  '${S.of(context).lotteryAccepted} ${model.lotterySettings.userCount}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: AppColors.active),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Button(
                                    value: S.of(context).lotteryAccept,
                                    onTap: () {
                                      model.acceptLottery(context);
                                    }),
                              )
                            ]));
                      } else if (model.lotterySettings.status == 1) {
                        return Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        S.of(context).lotteryDesc4(
                                            '${model.lotterySettings.end.toStringDMY()}'),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        );
                      } else if (model.lotterySettings.status == 2) {
                        return SingleChildScrollView(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                S.of(context).lotteryWinnersDesc2,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ));
                      }
                    }(),
            ));
      },
    );
  }
}

class LotteryScreenModel extends BaseViewModel {
  var authService = locator<AuthService>();
  var tbccApi = locator<TBCCApi>();
  int accIndex = 0;

  late LotterySettings lotterySettings;

  Future<void> init() async {
    setState(ViewState.Busy);

    var resp = await tbccApi.loadLotterySettings(
        authService.accManager.allAccounts[accIndex].bscWallet.address.hex);
    lotterySettings = resp.load;

    setState(ViewState.Idle);
  }

  Future<void> acceptLottery(BuildContext context) async {
    if (authService.accManager.accountType != AccType.Free) {
      setState(ViewState.Busy);
      var confirmed = (await showConfirmationDialog('Lottery',
              S.of(context).lotteryRule3('${lotterySettings.ticketPrice}'),
              confirmationTitle: S.of(context).confirm))
          .confirmed;

      if (confirmed) {
        var tbccContract = DeployedContract(
            bep20BasicContractAbi,
            EthereumAddress.fromHex(
                '0xf29480344d8e21EFeAB7Fde39F8D8299056A7FEA'));
        var price = EtherAmount.fromUnitAndValue(
            EtherUnit.ether, lotterySettings.ticketPrice);

        var t = Transaction.callContract(
            contract: tbccContract,
            function: tbccContract.function('transfer'),
            parameters: [
              EthereumAddress.fromHex(
                  '0x0ac5eb7005f1da7bf43440aa9f2ee3f4c9ac8eec'),
              price.getInWei
            ]);
        try {
          var resp = await ENVS.BSC_ENV!.sendTransaction(
              authService.accManager.allAccounts[accIndex].bscWallet.privateKey,
              t,
              chainId: 56);
          lotterySettings.userCount += 1;
          Flushbar.success(title: S.of(context).success).show();
        } catch (e) {
          Flushbar.error(title: S.of(context).error + e.toString())
              .show(Duration(seconds: 5));
        }
      }
      setState(ViewState.Idle);
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => Pro_PremiumView()));
    }
  }
}
