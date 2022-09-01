import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/core/settings/AppSettings.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/MainScreen.dart';
import 'package:voola/ui/styles/AppTheme.dart';
import 'package:voola/ui/views/premium/Pro_Premium.dart';
import 'package:voola/ui/widgets/SharedWidgets.dart';
import 'package:voola/ui/widgets/TokenCard.dart';
import 'package:voola/ui/widgets/bottom_sheet/CustomBottomSheet.dart';

//import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'AccountsSettings.dart';
import 'News.dart';
import 'SparklineChart.dart';
import 'TokenFilterScreen.dart';
import 'WalletMainScreenModel.dart';

class WalletMainScreen extends StatefulWidget {
  const WalletMainScreen({Key? key}) : super(key: key);

  @override
  _WalletMainScreenState createState() => _WalletMainScreenState();
}

class _WalletMainScreenState extends State<WalletMainScreen> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tt = Theme.of(context).textTheme;
    return BaseView<WalletMainScreenModel>(
      onModelReady: (model) async {
        bool inited = false;

        try {
          inited = model.accManager.allAccounts.first.allBalances.isNotEmpty;
        } catch (e) {}
        if (!inited && model.state != ViewState.Busy) await model.loadBalances();
      },
      builder: (context, model, _) => Scaffold(
        body: ChangeNotifierProvider.value(
          value: model.accManager,
          builder: (context, _) => Consumer<AccountManager>(
            builder: (_, val, __) => SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  if (model.barValue == 0)
                    await model.loadBalances(refresh: true);
                  else if (model.barValue == 1) {
                    await model.newsModel.loadNews();
                  }
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PremiumWidget(acc: model.accManager, state: model.state),
                          SizedBox(width: 12),
                          NotificationWidget(
                            isNewNotification: true,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    BlockchainConnectionState(),
                    Expanded(
                      child: NestedScrollView(
                        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                                pinned: false,
                                toolbarHeight: MediaQuery.of(context).size.height * 0.31,
                                flexibleSpace: FlexibleSpaceBar(
                                  collapseMode: CollapseMode.pin,
                                  background: Column(
                                    children: [
                                      AnimatedButtonBar([
                                        ButtonBarEntry(
                                          child: Text(
                                            S.of(context).wallet,
                                            style: 0 == model.barValue
                                                ? tt.bodyText2
                                                : tt.bodyText1!.copyWith(
                                                    color: AppColors.text.withOpacity(0.7),
                                                  ),
                                          ),
                                          onTap: () {
                                            if (model.barValue != 0) {
                                              model.barValue = 0;
                                              model.setState();
                                            }
                                          },
                                        ),
                                        ButtonBarEntry(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(S.of(context).news,
                                                  style: 1 == model.barValue ? tt.bodyText2 : tt.bodyText1!.copyWith(color: AppColors.text.withOpacity(0.7))),
                                              //if (locator<AppSettings>().lastNewsId != locator<UserSettings>().lastNewsRedId)
                                              if (locator<AppSettings>().lottery)
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.active,
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                    bottom: 10,
                                                    left: 4,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          onTap: () {
                                            if (model.barValue != 1) {
                                              model.barValue = 1;
                                              model.setState();
                                            }
                                          },
                                        ),
                                      ]),
                                      if (model.barValue == 0) ...[
                                        if (model.manualRefresh)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: LinearProgressIndicator(),
                                          ),
                                        SizedBox(height: 14),
                                        //cart
                                        Showcase(
                                          key: locator<MainScreenModel>().showcaseKeys['account_carousel'],
                                          //key: locator<MainScreenModel>().showcaseKeys[0],
                                          contentPadding: EdgeInsets.all(8.0),
                                          description: 'Swipe to change account',
                                          child: AccountCarousel(),
                                        ),
                                      ]
                                    ],
                                  ),
                                ))
                          ];
                        },
                        body: Column(
                          children: [
                            ...() {
                              if (model.barValue == 0)
                                return [
                                  Padding(padding: const EdgeInsets.all(16), child: TokenTypeSwitch()),
                                  Expanded(
                                    child: model.state == ViewState.Busy
                                        ? ShimmerBalancesListView()
                                        : ChangeNotifierProvider.value(
                                            value: model.balListModel,
                                            builder: (_, __) => Consumer<BalListModel>(
                                              builder: (_, balModel, __) => BalancesListView(
                                                model,
                                                key: ValueKey(model.currAccIndex + model.accManager.allAccounts[model.currAccIndex].hashCode),
                                              ),
                                            ),
                                          ),
                                  ),
                                ];
                              else
                                return [
                                  Expanded(
                                    child: NewsListView(model.newsModel),
                                  ),
                                ];
                            }()
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumWidget extends StatelessWidget {
  const PremiumWidget({
    Key? key,
    required this.acc,
    required this.state,
  }) : super(key: key);

  final AccountManager acc;
  final ViewState state;

  @override
  Widget build(BuildContext context) {
    var active = false;
    var type = 'Premium';
    if (acc.accountType == AccType.Free) {
      active = false;
    } else {
      active = true;
      switch (acc.accountType) {
        case AccType.Pro:
          type = 'PRO';
          break;
        case AccType.Premium:
          type = 'Premium';
          break;
        case AccType.Free:
          // TODO: Handle this case.
          break;
      }
    }
    return GestureDetector(
        onTap: () {
          if (state != ViewState.Busy) {
            if (active) {
              Flushbar.success(title: S.of(context).youProNow(type)).show();
            } else {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => Pro_PremiumView()));
            }
          }
        },
        child: PremiumGlobalButton(
          type,
          active,
          true,
          shimmer: state == ViewState.Busy,
        ));
  }
}

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    Key? key,
    required this.onTap,
    required this.isNewNotification,
  }) : super(key: key);
  final Function()? onTap;
  final bool isNewNotification;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), gradient: AppColors.altGradient, border: Border.all(width: 1, color: AppColors.inactiveText.withOpacity(0.1))),
            child: AppIcons.notification_bell(20, AppColors.text),
          ),
          isNewNotification
              ? Positioned(
                  right: 6,
                  top: 5,
                  child: Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary, border: Border.all(width: 2, color: AppColors.primaryBg)),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

class TokenTypeSwitch extends StatefulWidget {
  TokenTypeSwitch({Key? key}) : super(key: key);

  @override
  _TokenTypeSwitchState createState() => _TokenTypeSwitchState();
}

class _TokenTypeSwitchState extends State<TokenTypeSwitch> {
  late int index;
  late int barValue;

  @override
  void initState() {
    index = 0;
    barValue = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: locator<MainScreenModel>().showcaseKeys['token_filter_switch_bar'],
      contentPadding: EdgeInsets.all(8.0),
      description: 'Filter tokens by type',
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return TokenFilterScreen();
                        });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      gradient: AppColors.altGradient,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 1, color: AppColors.inactiveText.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(blurRadius: 18, color: AppColors.shadowColor, offset: Offset(0, 13)),
                      ],
                    ),
                    child: AppIcons.filter(24, AppColors.text),
                  ),
                ),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.78,
                  child: AnimatedButtonBar([
                    ButtonBarEntry(
                      child: Text(S.of(context).coin,
                          style: 0 == barValue ? Theme.of(context).textTheme.bodyText2 : Theme.of(context).textTheme.bodyText1!.copyWith(color: AppColors.text.withOpacity(0.7))),
                      onTap: () {
                        if (barValue != 0) {
                          setState(() {
                            barValue = 0;
                          });
                        }
                      },
                      activeColor: Theme.of(context).canvasColor,
                    ),
                    ButtonBarEntry(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(S.of(context).nft,
                              style:
                                  1 == barValue ? Theme.of(context).textTheme.bodyText2 : Theme.of(context).textTheme.bodyText1!.copyWith(color: AppColors.text.withOpacity(0.7))),
                          //if (locator<AppSettings>().lastNewsId != locator<UserSettings>().lastNewsRedId)
                          if (locator<AppSettings>().lottery)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.active),
                              margin: const EdgeInsets.only(bottom: 10, left: 4),
                            ),
                        ],
                      ),
                      onTap: () {
                        if (barValue != 1) {
                          setState(() {
                            barValue = 1;
                          });
                        }
                      },
                    ),
                  ]),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ...() {
                  var values = (1 == barValue
                      ? [
                          ['BEP20', TokenFilterType.BEP20],
                          ['ERC20', TokenFilterType.ERC20],
                          ['BEP2', TokenFilterType.BEP2],
                          ['BEP8', TokenFilterType.BEP8],
                        ]
                      : [
                          ['Coins', TokenFilterType.Native],
                        ]);

                  return [
                    for (var i in range(0, values.length))
                      GestureDetector(
                          onTap: () => setState(() {
                                index = i;
                                locator<WalletMainScreenModel>().tokenFilterType = values[i][1] as TokenFilterType;
                              }),
                          child: TokenTypeButton(values[i][0] as String, values[i][1] == locator<WalletMainScreenModel>().tokenFilterType))
                  ];
                }()
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TokenTypeButton extends StatelessWidget {
  final String value;
  final bool selected;

  const TokenTypeButton(this.value, this.selected, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(boxShadow: selected ? [BoxShadow(blurRadius: 18, color: AppColors.shadowColor, offset: Offset(0, 13))] : null),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.only(top: 10, right: 18, left: 18),
        duration: Duration(milliseconds: 200),
        child: Text(value, style: selected ? tt.bodyText2 : tt.bodyText1!.copyWith(color: AppColors.inactiveText)),
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  final int index;

  const AccountCard(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tt = Theme.of(context).textTheme;
    return Consumer<WalletMainScreenModel>(builder: (_, model, __) {
      var acc = model.accManager.allAccounts[index];

      return SingleChildScrollView(
        child: AspectRatio(
          aspectRatio: 16 / 8,
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: AppColors.cardGradient,
              // color: Colors.red,
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text('${acc.accountAlias}', style: tt.bodyText1!.copyWith(color: AppColors.inactiveText)),
              ...() {
                if (model.state == ViewState.Busy)
                  return [
                    Shimmer.fromColors(
                      child: shimmerBlock(130, 30, 16),
                      baseColor: AppColors.inactiveText.withOpacity(0.3),
                      highlightColor: AppColors.active,
                    ),
                    Shimmer.fromColors(
                      child: shimmerBlock(90, 30, 16),
                      baseColor: AppColors.inactiveText.withOpacity(0.3),
                      highlightColor: AppColors.active,
                    ),
                  ];
                else
                  return [
                    Text('$FIAT_CURRENCY_LITERAL${acc.totalBalance.toStringWithFractionDigits(2)}', style: tt.headline5),
                    AccountPNL(
                      '${acc.totalPNL.toStringWithFractionDigits(2)}',
                      '${acc.totalPNLPercent.toStringWithFractionDigits(2)}',
                    ),
                  ];
              }()
            ]),
          ),
        ),
      );
    });
  }
}

class EditAccountsCard extends StatelessWidget {
  EditAccountsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AspectRatio(
        aspectRatio: 16 / 8,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => AccountsSettingsScreen()));
          },
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture(
                            AppIcons.plus_circle(21).pictureProvider,
                            allowDrawingOutsideViewBox: true,
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                          SizedBox(height: 8),
                          Text(S.of(context).addChange, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: SvgPicture.asset(
                        'assets/images/vector/icons/elipsLeft.svg',
                        fit: BoxFit.fill,
                        clipBehavior: Clip.hardEdge,
                        allowDrawingOutsideViewBox: true,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(
                        'assets/images/vector/icons/elipsRight.svg',
                        fit: BoxFit.fill,
                        clipBehavior: Clip.hardEdge,
                        allowDrawingOutsideViewBox: true,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AccountCarousel extends StatefulWidget {
  AccountCarousel();

  @override
  State<StatefulWidget> createState() {
    return _AccountCarouselState();
  }
}

class _AccountCarouselState extends State<AccountCarousel> with TickerProviderStateMixin {
  late List<Widget> slides;
  final CarouselController _controller = CarouselController();

  int index = 0;

  @override
  void initState() {
    locator<WalletMainScreenModel>().addListener(() {
      index = locator<WalletMainScreenModel>().currAccIndex;
      _controller.animateToPage(index);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    slides = [];
    locator<AccountManager>().allAccounts.forEachIndexed((e, i) {
      slides.add(AccountCard(i));
    });

    slides.insert(slides.length, EditAccountsCard());

    return Consumer<WalletMainScreenModel>(
      builder: (_, model, __) => Column(children: [
        Stack(children: [
          CarouselSlider(
            items: slides,
            carouselController: _controller,
            options: CarouselOptions(
                initialPage: index,
                aspectRatio: 16 / 8,
                autoPlay: false,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                viewportFraction: 0.95,
                onPageChanged: (index_, reason) {
                  setState(() {
                    index = index_;
                    if (index_ != 0 && model.currAccIndex != index - 1) model.currAccIndex = index_ - 1;
                  });
                }),
          ),
        ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: range(0, slides.length).map((entry) {
              return GestureDetector(
                onTap: () => setState(() {
                  index = entry;
                  _controller.animateToPage(entry);
                }),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: entry == index ? AppColors.primary : AppColors.inactiveText.withOpacity(0.3),
                  ),
                ),
              );
            }).toList()),
      ]),
    );
  }
}

class ShimmerBalancesListView extends StatelessWidget {
  const ShimmerBalancesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return TokenCardShimmerPlaceholder();
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 12,
        );
      },
    );
  }
}

class BalancesListView extends StatelessWidget {
  final WalletMainScreenModel walletMainModel;

  const BalancesListView(this.walletMainModel, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var balances = <WalletBalance>[];
    switch (walletMainModel.tokenFilterType) {
      case TokenFilterType.All:
        balances = walletMainModel.accManager.allAccounts[walletMainModel.currAccIndex].allBalances;
        break;
      case TokenFilterType.Native:
        balances = walletMainModel.accManager.allAccounts[walletMainModel.currAccIndex].coinBalances;
        break;
      case TokenFilterType.BEP20:
        balances = walletMainModel.accManager.allAccounts[walletMainModel.currAccIndex].bep20Balances;
        break;
      case TokenFilterType.ERC20:
        balances = walletMainModel.accManager.allAccounts[walletMainModel.currAccIndex].erc20Balances;
        break;
      case TokenFilterType.BEP2:
        balances = walletMainModel.accManager.allAccounts[walletMainModel.currAccIndex].bc_bep2_Balances;
        break;
      case TokenFilterType.BEP8:
        balances = walletMainModel.accManager.allAccounts[walletMainModel.currAccIndex].bc_bep8_Balances;
        break;
    }

    return ListView.separated(
      //controller: walletMainModel.sc,
      padding: const EdgeInsets.all(16),
      //shrinkWrap: true,
      physics: ClampingScrollPhysics(),

      itemCount: balances.length,
      addAutomaticKeepAlives: false,
      itemBuilder: (context, index) {
        return AnimatedOpacityWrapper(
          index: index,
          child: TokenCardHeroWrapper(
            'cardAllBalances$index',
            balances[index],
            walletMainModel,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 12,
        );
      },
    );
  }
}

class TokenCardShimmerPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: AppColors.inactiveText.withOpacity(0.3), borderRadius: BorderRadius.circular(24)),
        height: 90,
        padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
        child: Shimmer.fromColors(
          baseColor: AppColors.inactiveText,
          highlightColor: AppColors.active,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.secondaryBG, borderRadius: BorderRadius.circular(16)),
                child: Icon(
                  Icons.ac_unit,
                  size: 45,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            shimmerBlock(80, 18, 8),
                          ],
                        ),
                        Spacer(),
                        shimmerBlock(50, 18, 8),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            shimmerBlock(120, 18, 8),
                          ],
                        ),
                        Spacer(),
                        shimmerBlock(60, 18, 8),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class TokenCardHeroWrapper extends StatelessWidget {
  final String heroTag;
  final WalletBalance balance;
  final WalletMainScreenModel model;

  const TokenCardHeroWrapper(this.heroTag, this.balance, this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var card = TokenCard(balance);
    return GestureDetector(
      onTap: () async {
        locator<WalletMainScreenModel>().currentTokenMarketsModel = TokenMarketsModel();
        await showCupertinoModalBottomSheet(
          elevation: 0,
          enableDrag: true,
          expand: false,
          barrierColor: Color(0xA6272323),
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => TokenCardActionsBottomSheet(heroTag, card, model),
        );

        locator<WalletMainScreenModel>().currentTokenMarketsModel = null;
      },
      child: Hero(tag: heroTag, child: card),
    );
  }
}

class BlockchainConnectionState extends StatelessWidget {
  BlockchainConnectionState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<BLOCKCHAIN_CONNECTION_STATE>(
      onModelReady: (model) {},
      builder: (context, model, child) {
        var children = [
          for (var i in model.states.entries)
            if (i.value == false) Text('⚠️ No connection to ${i.key.toString().split('.').last}', textAlign: TextAlign.center),
        ];
        return children.isNotEmpty
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children))
            : SizedBox();
      },
    );
  }
}
