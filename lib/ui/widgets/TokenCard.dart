import 'dart:math' show pi;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/core/authentication/AuthService.dart';
import 'package:voola/core/settings/AppSettings.dart';
import 'package:voola/core/token/TokenContainer.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/styles/AppTheme.dart';
import 'package:voola/ui/views/premium/Pro_Premium.dart';
import 'package:voola/ui/views/wallet/ReceiveScreen.dart';
import 'package:voola/ui/views/wallet/SparklineChart.dart';
import 'package:voola/ui/views/wallet/Swaps.dart';
import 'package:voola/ui/views/wallet/WalletMainScreenModel.dart';
import 'package:voola/ui/views/wallet/details/WalletDetails.dart';

class TokenCard extends StatelessWidget {
  final WalletBalance balance;
  const TokenCard(this.balance, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tt = Theme.of(context).textTheme;
    return GestureDetector(
      onLongPress: () async {
        var address = locator<AccountManager>().addressByToken(
            locator<WalletMainScreenModel>().currAccIndex, balance.token);
        var text;
        if (address is String) {
          text = address;
        } else if (address is EthereumAddress) {
          text = address.hexEip55;
        }
        await Clipboard.setData(ClipboardData(text: text));
        Flushbar.success(
                title: S.of(context).copiedToClipboard(
                    '${balance.token.symbol} ${S.of(context).address}'))
            .show();
      },
      child: Container(
        height: 80,
        padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
        decoration: BoxDecoration(
            color: balance.changePercent >= Decimal.zero
                ? AppColors.tokenCardPriceUp
                : AppColors.tokenCardPriceDown,
            borderRadius: BorderRadius.circular(24)),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 56,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.primaryBg
                    : AppColors.secondaryBG,
                borderRadius: BorderRadius.circular(16),
              ),
              child: balance.token.icon(45),
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
                        children: [
                          Text(
                              '${[
                                'BEP2',
                                'BEP8'
                              ].contains(balance.token.standard) ? balance.token.symbol.split('-').first : balance.token.symbol}',
                              style: tt.bodyText2),
                          SizedBox(width: 11),
                          Text('${balance.token.standard}',
                              style: tt.subtitle2),
                        ],
                      ),
                      Spacer(),
                      Text(
                          '${balance.balance.toStringWithFractionDigits(3, shrinkZeros: true)} ${[
                            'BEP2',
                            'BEP8'
                          ].contains(balance.token.standard) ? balance.token.symbol.split('-').first : balance.token.symbol}',
                          style: tt.subtitle2),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                              '$FIAT_CURRENCY_LITERAL${balance.fiatPrice.toStringWithFractionDigits(2)}  ',
                              style: tt.subtitle2),
                          Row(children: [
                            Transform.rotate(
                              angle: balance.changePercent.isNegative ? pi : 0,
                              child: AppIcons.arrow(
                                  10,
                                  balance.changePercent.isNegative
                                      ? AppColors.red
                                      : AppColors.green),
                            ),
                            Text(
                                '${balance.changePercent.abs().toStringWithFractionDigits(2)}%',
                                style: tt.subtitle2!.copyWith(
                                    color: balance.changePercent.isNegative
                                        ? AppColors.red
                                        : AppColors.green)),
                          ]),
                        ],
                      ),
                      Spacer(),
                      Text(
                          '$FIAT_CURRENCY_LITERAL${balance.fiatBalance.toStringWithFractionDigits(2)}',
                          style: tt.bodyText2),

                      //() {
                      //  var balChange = balance.changePercent / Decimal.fromInt(100) * balance.fiatBalance;
                      //  var ic = AppIcons.arrow(16);
                      //  return Row(children: [
                      //    Transform.rotate(
                      //      angle: balance.changePercent.isNegative ? pi : 0,
                      //      child: SvgPicture(
                      //        ic.pictureProvider,
                      //        width: 16,
                      //        colorFilter: ColorFilter.mode(balance.changePercent.isNegative ? AppColors.red : AppColors.green, BlendMode.srcIn),
                      //      ),
                      //    ),
                      //    Text('$FIAT_CURRENCY_LITERAL${balChange.abs().toStringWithFractionDigits(2)} (${balance.changePercent.toStringWithFractionDigits(2)}%)', style: tt.subtitle2!.copyWith(color: balance.changePercent.isNegative ? AppColors.red : AppColors.green))
                      //  ]);
                      //}()
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TokenCardActionsBottomSheet extends StatelessWidget {
  final TokenCard card;
  final String heroTag;
  final WalletMainScreenModel model;
  TokenCardActionsBottomSheet(this.heroTag, this.card, this.model, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent, applyElevationOverlayColor: false),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.85,
        maxChildSize: 0.98,
        builder: (context, scrollController) {
          return Material(
            elevation: 0,
            color: Colors.transparent,
            borderOnForeground: true,
            shadowColor: Colors.transparent,
            child: NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n is OverscrollNotification && n.velocity < -1700) {
                  Navigator.of(context).pop();
                  return true;
                }
                return false;
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Container(
                      width: 36,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.5),
                          color: Colors.white.withOpacity(0.6)),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: AppColors.primaryBg,
                        ),
                        //color: Colors.transparent,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          controller: scrollController,
                          child: Column(
                            children: [
                              Hero(
                                tag: heroTag,
                                flightShuttleBuilder: (context, animation,
                                    direction, fromContext, toHeroContext) {
                                  final Hero toHero =
                                      toHeroContext.widget as Hero;
                                  if (direction == HeroFlightDirection.push) {
                                    final RenderBox toHeroBox = toHeroContext
                                        .findRenderObject() as RenderBox;
                                    final RenderBox finalRouteBox =
                                        ModalRoute.of(toHeroContext)
                                            ?.subtreeContext
                                            ?.findRenderObject() as RenderBox;
                                    final Offset toHeroOrigin =
                                        toHeroBox.localToGlobal(Offset.zero,
                                            ancestor: finalRouteBox);

                                    final RenderBox fromHeroBox = fromContext
                                        .findRenderObject() as RenderBox;
                                    final RenderBox fromRouteBox =
                                        ModalRoute.of(fromContext)
                                            ?.subtreeContext
                                            ?.findRenderObject() as RenderBox;
                                    final Offset fromHeroOrigin =
                                        fromHeroBox.localToGlobal(Offset.zero,
                                            ancestor: fromRouteBox);
                                    return AnimatedBuilder(
                                        animation: animation,
                                        builder: (context, child) {
                                          final y = (toHeroOrigin.dy -
                                                  fromHeroOrigin.dy -
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height) *
                                              animation.value;
                                          return Transform.translate(
                                              offset: Offset(0, y),
                                              child: child);
                                        },
                                        child: toHero.child);
                                  } else {
                                    return toHero.child;
                                  }
                                },
                                createRectTween: (begin, end) => RectTween(
                                  begin: begin,
                                  end: Rect.fromLTWH(end!.left, begin!.top,
                                      end.width, end.height),
                                ),
                                child: card,
                              ),
                              card.balance.token.coingeckoId != '-1'
                                  ? Container(
                                      height: 280,
                                      margin: const EdgeInsets.only(
                                          top: 20, bottom: 20),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 16),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryBG,
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 18,
                                              color: AppColors.shadowColor,
                                              offset: Offset(0, 13)),
                                        ],
                                      ),
                                      child: SparklineChart(
                                          locator<WalletMainScreenModel>()
                                              .currentTokenMarketsModel!,
                                          card.balance.token.coingeckoId),
                                    )
                                  : SizedBox(height: 40),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryBG_gray
                                      .withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  children: [
                                    ...() {
                                      var divider = Divider(height: 0);
                                      return [
                                        for (var btn in [
                                          [
                                            AppIcons.arrow_income(
                                                24, AppColors.text),
                                            S.of(context).send,
                                            () => routeToTransfer(
                                                card.balance,
                                                context,
                                                locator<WalletMainScreenModel>()
                                                    .currAccIndex),
                                          ],
                                          [divider],
                                          [
                                            AppIcons.arrow_outcome(
                                                24, AppColors.text),
                                            S.of(context).receive,
                                            () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (_) => ReceiveScreen(
                                                      card.balance.token,
                                                      locator<AccountManager>()
                                                          .addressByToken(
                                                              locator<WalletMainScreenModel>()
                                                                  .currAccIndex,
                                                              card.balance
                                                                  .token))));
                                            }
                                          ],
                                          [divider],
                                          [
                                            AppIcons.pending(
                                                24, AppColors.text),
                                            S.of(context).transactions,
                                            () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => WalletDetails(
                                                    card.balance,
                                                    locator<WalletMainScreenModel>()
                                                        .currAccIndex,
                                                    model,
                                                  ),
                                                ),
                                              );
                                            }
                                          ],
                                          [divider],
                                          [
                                            Icon(Icons.more_horiz_outlined,
                                                size: 24,
                                                color: AppColors.text),
                                            S.of(context).actions,
                                            () {
                                              var from = card.balance;
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (ctx) {
                                                  return Container(
                                                      // height: 200,
                                                      child: Material(
                                                    color: AppColors
                                                        .generalShapesBg,
                                                    child: Column(
                                                      //mainAxisAlignment: MainAxisAlignment.center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          child: Text(S
                                                              .of(context)
                                                              .availableActions(
                                                                  '${from.token.symbol} ${from.token.standard}')),
                                                        ),
                                                        ...() {
                                                          var availableSwaps =
                                                              locator<WALLET_TOKENS_CONTAINER>()
                                                                      .crossChainSwapTokens[
                                                                  card.balance
                                                                      .token];
                                                          var tiles = [];
                                                          if (availableSwaps ==
                                                              null) {
                                                            tiles = [
                                                              Text(S
                                                                  .of(context)
                                                                  .noActions),
                                                            ];
                                                          } else {
                                                            for (var swap
                                                                in availableSwaps) {
                                                              if (from.token
                                                                          .standard ==
                                                                      'ERC20' &&
                                                                  swap.symbol ==
                                                                      'TBCC' &&
                                                                  swap.standard ==
                                                                      'BEP20' &&
                                                                  locator<AppSettings>()
                                                                          .swap_erc20_bep20 !=
                                                                      true) {
                                                                continue;
                                                              } else {
                                                                tiles.addAll(
                                                                  [
                                                                    actionsTile(
                                                                        S.of(context).swapTo(
                                                                            '${swap.symbol} ${from.token.symbol == 'BNB' && from.token.standard == 'BEP2' ? swap.network.toString().split('.').last : swap.standard}'),
                                                                        Icon(
                                                                            Icons
                                                                                .swap_horiz,
                                                                            color:
                                                                                AppColors.active),
                                                                        () {
                                                                      if (from.token.symbol ==
                                                                              'TBCC' &&
                                                                          locator<AuthService>().accManager.accountType ==
                                                                              AccType.Free)
                                                                        Navigator.of(ctx).push(MaterialPageRoute(
                                                                            builder: (_) =>
                                                                                Pro_PremiumView()));
                                                                      else {
                                                                        Navigator.of(ctx)
                                                                            .push(
                                                                          MaterialPageRoute(
                                                                            builder: (_) =>
                                                                                CrossChainSwapScreen(
                                                                              S.of(ctx).swapTo('${swap.symbol} ${from.token.symbol == 'BNB' && from.token.standard == 'BEP2' ? swap.network.toString().split('.').last : swap.standard}'),
                                                                              from_bal: from,
                                                                              to: swap,
                                                                              account: locator<AccountManager>().allAccounts[locator<WalletMainScreenModel>().currAccIndex],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                    },
                                                                        swap.symbol
                                                                            .contains('TBC'),
                                                                        context),
                                                                    Divider(
                                                                        color: AppColors
                                                                            .inactiveText),
                                                                  ],
                                                                );
                                                              }
                                                            }
                                                            if (tiles.isEmpty)
                                                              tiles = [
                                                                Text(S
                                                                    .of(context)
                                                                    .noActions)
                                                              ];
                                                          }
                                                          return tiles;
                                                        }(),
                                                        SizedBox(height: 20)
                                                      ],
                                                    ),
                                                  ));
                                                },
                                              );
                                            }
                                          ],
                                        ])
                                          btn.length == 1
                                              ? btn[0] as Widget
                                              : GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  onTap: btn[2] as Function(),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 20,
                                                        horizontal: 18),
                                                    child: Row(
                                                      children: [
                                                        btn[0] as Widget,
                                                        SizedBox(width: 16),
                                                        Text(
                                                          btn[1] as String,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                      ];
                                    }()
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              if (card.balance.token.coingeckoId != '-1')
                                ChangeNotifierProvider.value(
                                  value: locator<WalletMainScreenModel>()
                                      .currentTokenMarketsModel!,
                                  builder: (_, __) =>
                                      Consumer<TokenMarketsModel>(
                                    builder: (_, model, __) {
                                      if (!model.isLoading)
                                        return Column(
                                          children: [
                                            for (var i in [
                                              ['Вебсайт', 'bitcoin.org'],
                                              [
                                                'MarketCap',
                                                '$FIAT_CURRENCY_LITERAL${dividedStringNum(model.data?.marketCap.toInt())}'
                                              ],
                                              [
                                                'Volume',
                                                '$FIAT_CURRENCY_LITERAL${dividedStringNum(model.data?.totalVolume.toInt())}'
                                              ],
                                            ])
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(i[0],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle2),
                                                    Text(i[1],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2!
                                                            .copyWith(
                                                                fontSize: 14)),
                                                  ],
                                                ),
                                              )
                                          ],
                                        );
                                      else {
                                        return Shimmer.fromColors(
                                            child: Column(
                                              children: [
                                                shimmerBlock(120, 16, 16),
                                                SizedBox(height: 12),
                                                shimmerBlock(120, 16, 16),
                                              ],
                                            ),
                                            baseColor: AppColors.inactiveText,
                                            highlightColor: AppColors.active);
                                      }
                                    },
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget actionsTile(
      String text, Widget icon, void Function() onTap, bool premium, context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: icon,
            ),
            Text('$text'),
            if (premium == true)
              Container(
                margin: const EdgeInsets.only(left: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Premium',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: AppColors.yellow),
                ),
              )
          ],
        ),
      ),
    );
  }
}
