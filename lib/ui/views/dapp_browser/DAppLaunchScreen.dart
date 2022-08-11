import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/core/blockchain/binance_smart_chain/contracts/TokenHub_abi.dart';
import 'package:voola/core/token/utils.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/QrCodeReader.dart';
import 'AlertDialog.dart';
import 'DAppScreen.dart';
import 'package:dartx/dartx.dart';

String dappImageUrlBase =
    'https://raw.githubusercontent.com/trustwallet/assets/master/dapps';

enum DAppType { DeFi, Games, Tools, New }

var network_chainId = <TokenNetwork, int>{
  TokenNetwork.BinanceSmartChain: 56,
  TokenNetwork.Ethereum: 1,
};

class DApp {
  late Uri url;
  String? customImageUrl;
  late String name;
  TokenNetwork? network;
  late DAppType type;
  String? description;
  late bool fromAsset;
  late Widget image;
  DApp(this.url, this.name, this.network, this.type,
      {this.customImageUrl, this.fromAsset = false, this.description}) {
    image = fromAsset
        ? Image.asset(
            customImageUrl!,
            height: 60,
            width: 60,
          )
        : CachedNetworkImage(
            height: 60,
            width: 60,
            imageUrl: customImageUrl ?? '$dappImageUrlBase/${url.host}.png',
            placeholder: (ctx, url) => const BaseImagePlaceHolderWidget(),
            errorWidget: (ctx, url, err) => const BaseImagePlaceHolderWidget(),
          );
  }
}

class BaseImagePlaceHolderWidget extends StatelessWidget {
  const BaseImagePlaceHolderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.image,
      color: Theme.of(context).dividerColor,
      size: 32,
    );
  }
}

class DAppLaunchScreenModel extends BaseViewModel {
  final accManager = locator<AccountManager>();
  DApp? currDapp;
  bool? isActiveDapp = false;
  int selectedAccIndex = 0;
  bool needToLoadEmpty = false;
  late DAppScreenModel dappScreenModel;
  FocusNode focusNode = FocusNode();
  final TextEditingController search = TextEditingController();
  List<DApp> allDapps = [];
  List<DApp> allDappsSearched = [];

  void searchList(String value) {
    allDappsSearched.clear();
    allDapps.forEach((element) => {
          if (element.name.contains(search.text))
            {allDappsSearched.add(element)}
        });
    setState();
  }

  var ethDApps = [
    DApp(Uri.parse('https://app.uniswap.org'), 'Uniswap', TokenNetwork.Ethereum,
        DAppType.DeFi,
        description: 'AMM DEX'),
    DApp(Uri.parse('https://app.sushi.com/'), 'SushiSwap',
        TokenNetwork.Ethereum, DAppType.DeFi,
        description: 'AMM DEX',
        customImageUrl:
            'https://raw.githubusercontent.com/trustwallet/assets/master/dapps/sushiswapclassic.org.png'),
    DApp(Uri.parse('https://app.compound.finance/'), 'Compound',
        TokenNetwork.Ethereum, DAppType.DeFi,
        description: 'Lending and borrowing DeFi app'),
    DApp(
      Uri.parse('https://app.1inch.io/#/1'),
      '1inch (Ethereum)',
      TokenNetwork.Ethereum,
      DAppType.DeFi,
      description: 'AMM & DEX aggregator',
      customImageUrl: 'https://app.1inch.io/assets/icons/icon-144x144.png',
    ),
    DApp(
      Uri.parse('https://shibaswap.com/#/'),
      'ShibaSwap',
      TokenNetwork.Ethereum,
      DAppType.DeFi,
      description: 'AMM DEX',
      fromAsset: true,
      customImageUrl: 'assets/images/shibaswap.png',
    ),
  ];

  var bscDApps = [
    //DApp(Uri.parse('https://tbccswap.com'), 'TBCC Swap', TokenNetwork.BinanceSmartChain, DAppType.DeFi, description: 'AMM DEX', fromAsset: true, customImageUrl: 'assets/images/logo.png'),
    DApp(Uri.parse('https://pancakeswap.finance/'), 'PancakeSwap',
        TokenNetwork.BinanceSmartChain, DAppType.DeFi,
        description: 'AMM DEX'),
    DApp(
      Uri.parse('https://app.1inch.io/#/56'),
      '1inch (SmartChain)',
      TokenNetwork.BinanceSmartChain,
      DAppType.DeFi,
      description: 'AMM & DEX aggregator',
      customImageUrl: 'https://app.1inch.io/assets/icons/icon-144x144.png',
    ),
    DApp(Uri.parse('https://app.venus.io/'), 'Venus',
        TokenNetwork.BinanceSmartChain, DAppType.DeFi,
        description: 'Decentralized Marketplace'),
    DApp(Uri.parse('https://apeswap.finance/'), 'ApeSwap',
        TokenNetwork.BinanceSmartChain, DAppType.DeFi,
        description: 'AMM DEX'),
    DApp(Uri.parse('https://www.bakeryswap.org/'), 'BakerySwap',
        TokenNetwork.BinanceSmartChain, DAppType.DeFi,
        description: 'AMM DEX'),
  ];

  var toolsDApps = [
    DApp(Uri.parse('https://bscscan.com/'), 'BscScan',
        TokenNetwork.BinanceSmartChain, DAppType.Tools,
        description: 'Binance Smart Chain Explorer',
        fromAsset: true,
        customImageUrl: 'assets/images/bscscan_logo.png'),
    DApp(Uri.parse('https://etherscan.com/'), 'Etherscan',
        TokenNetwork.Ethereum, DAppType.Tools,
        description: 'ETH blockchain explorer',
        fromAsset: true,
        customImageUrl: 'assets/images/etherscan_logo.png'),
    DApp(Uri.parse('https://cn.etherscan.com/'), 'Etherscan CN',
        TokenNetwork.Ethereum, DAppType.Tools,
        description: '[China] ETH blockchain explorer',
        fromAsset: true,
        customImageUrl: 'assets/images/etherscan_cn_logo.png'),
    DApp(Uri.parse('https://explorer.binance.org/'), 'DEX Explorer',
        TokenNetwork.BinanceChain, DAppType.Tools,
        description: 'Binance Chain explorer',
        customImageUrl:
            'https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/binance/info/logo.png'),
    DApp(Uri.parse('https://coingecko.com/'), 'CoinGecko', null, DAppType.Tools,
        description: 'Market information',
        fromAsset: true,
        customImageUrl: 'assets/images/coingecko_logo.png'),
    DApp(Uri.parse('https://coinmarketcap.com/'), 'CoinMarketCap', null,
        DAppType.Tools,
        description: 'Market information',
        fromAsset: true,
        customImageUrl: 'assets/images/coinmarketcap_logo.png'),
    DApp(Uri.parse('https://info.uniswap.org/#/'), 'Uniswap info',
        TokenNetwork.Ethereum, DAppType.Tools,
        description: 'Uniswap statistics'),
    DApp(Uri.parse('https://pancakeswap.info/'), 'PancakeSwap info',
        TokenNetwork.BinanceSmartChain, DAppType.Tools,
        description: 'PancakeSwap statistics',
        customImageUrl:
            'https://raw.githubusercontent.com/trustwallet/assets/master/dapps/pancakeswap.finance.png'),
  ];

  var newDApps = [
    DApp(Uri.parse('https://dappradar.com/nft/marketplaces'), 'NFT',
        TokenNetwork.Ethereum, DAppType.New,
        description: 'Marketplace | DappRadar',
        fromAsset: true,
        customImageUrl: 'assets/images/dappradar.png'),
    DApp(Uri.parse('https://market.playdapp.com/'), 'PlayDapp',
        TokenNetwork.Ethereum, DAppType.New,
        description: 'Marketplace | PlayDapp',
        fromAsset: true,
        customImageUrl: 'assets/images/playdapp.png'),
    DApp(Uri.parse('https://www.magiceden.io/'), 'MagicEden',
        TokenNetwork.Solana, DAppType.New,
        description: 'NFT marketplace',
        fromAsset: true,
        customImageUrl: 'assets/images/magiceden.png'),
    DApp(Uri.parse('http://nftxcards.com'), 'Muses of pleasure',
        TokenNetwork.BinanceSmartChain, DAppType.New,
        description: 'Tarusov & NFTxCards Generative Collection',
        fromAsset: true,
        customImageUrl: 'assets/images/nftxcards.png'),
    DApp(Uri.parse('https://opensea.io/'), 'OpenSea', TokenNetwork.Solana,
        DAppType.New,
        description: 'the largest NFT marketplace',
        fromAsset: true,
        customImageUrl: 'assets/images/opensea.png'),
  ];

  void getAllDapps() {
    allDapps.addAll(newDApps);
    allDapps.addAll(ethDApps);
    allDapps.addAll(bscDApps);
    allDapps.addAll(toolsDApps);
  }

  List<Widget> caruselWidgets = [
    Container(
      margin: EdgeInsets.only(right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Image.asset(
          'assets/images/banner.png',
        ),
      ),
    ),
    Container(
      margin: EdgeInsets.only(right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Image.asset(
          'assets/images/banner.png',
        ),
      ),
    ),
    Container(
      margin: EdgeInsets.only(right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Image.asset(
          'assets/images/banner.png',
        ),
      ),
    ),
  ];
}

class DAppLaunchScreen extends StatelessWidget {
  DAppLaunchScreenModel model;
  DAppLaunchScreen(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<DAppLaunchScreenModel>(
      model: model,
      onModelReady: (model) {
        model.getAllDapps();
      },
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                model.focusNode.hasFocus
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          model.setState();
                        },
                        child: model.search.text == ''
                            ? Center(
                                child: Text('Строка поиска пуста'),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: dappsBlockAll(
                                    model.allDappsSearched, model, context),
                              ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CarouselSlider(
                                items: model.caruselWidgets,
                                options: CarouselOptions(
                                  disableCenter: true,
                                  initialPage: 0,
                                  height: 185,
                                  autoPlay: false,
                                  enlargeCenterPage: false,
                                  enableInfiniteScroll: true,
                                  viewportFraction: 0.9,
                                  onPageChanged: (index_, reason) {},
                                ),
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text('Hot dApps',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(color: AppColors.text)),
                              ),
                              dappsBlock(
                                model.newDApps,
                                model,
                                context,
                                isHorizontal: true,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text('Binance Smart Chain',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(color: AppColors.text)),
                              ),
                              dappsBlock(model.bscDApps, model, context),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text('Ethereum',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(color: AppColors.text)),
                              ),
                              dappsBlock(model.ethDApps, model, context),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text('Tools',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(color: AppColors.text)),
                              ),
                              dappsBlock(model.toolsDApps, model, context),
                            ],
                          ),
                        ),
                      ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: TextFormField(
                          controller: model.search,
                          focusNode: model.focusNode,
                          key: key,
                          onTap: () {
                            if (model.focusNode.hasFocus)
                              model.focusNode.unfocus();
                            model.setState();
                          },
                          onChanged: (v) {
                            model.searchList(v);
                          },
                          textAlignVertical: TextAlignVertical.center,
                          decoration: generalTextFieldDecor(
                            context,
                            hintText: 'Find dApp or enter the link',
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 8),
                              child: Icon(
                                Icons.search_rounded,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      // onTap: () => Navigator.of(context).push(()),
                      child: Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.only(right: 16),
                        padding: EdgeInsets.only(
                            left: 5, top: 5, bottom: 7, right: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              width: 1,
                              color: AppColors.inactiveText.withOpacity(0.08)),
                          gradient: AppColors.altGradient,
                        ),
                        child: AppIcons.qr_code_scan(22, AppColors.text),
                      ),
                    ),
                  ],
                ),
                model.currDapp != null
                    ? AnimatedPositioned(
                        curve: Curves.easeInOut,
                        top: MediaQuery.of(context).size.height * 0.24,
                        right: model.isActiveDapp == null
                            ? -350
                            : (model.isActiveDapp! ? 0 : -250),
                        duration: Duration(milliseconds: 500),
                        child: GestureDetector(
                          onTap: () {
                            if (model.isActiveDapp != null)
                              model.isActiveDapp = !model.isActiveDapp!;
                            else {
                              model.isActiveDapp = true;
                            }
                            model.setState();
                          },
                          child: Container(
                            width: 335,
                            height: 85,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(16),
                              ),
                              color: AppColors.secondaryBG,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.1)),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.asset('assets/images/donut.png'),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          model.currDapp!.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          model.currDapp?.description ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                color: AppColors.inactiveText,
                                              ),
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.5, color: AppColors.text),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: AppColors.text,
                                      size: 14,
                                    ),
                                  ),
                                  onTap: () async {
                                    model.isActiveDapp = null;
                                    model.setState();

                                    await Future.delayed(
                                        Duration(milliseconds: 500));
                                    model.currDapp = null;

                                    model.setState();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration generalTextFieldDecor(BuildContext context,
          {String? hintText,
          double? paddingRight,
          String? suffixText,
          Widget? prefixIcon}) =>
      InputDecoration(
        hintText: hintText,
        fillColor: AppColors.generalShapesBg,
        filled: true,
        prefixIcon: prefixIcon,
        prefixIconConstraints: BoxConstraints(
          maxWidth: 60,
          maxHeight: 52,
          minHeight: 52,
        ),
        contentPadding: EdgeInsets.only(left: 16),
        isDense: true,
        isCollapsed: true,
        suffixText: suffixText,
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: AppColors.generalBorder.withOpacity(0.5), width: 1)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: AppColors.generalBorder.withOpacity(0.1), width: 1)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: AppColors.generalBorder.withOpacity(0.1), width: 1)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.red, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.active, width: 1)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.red, width: 1.5)),
      );

  Widget dappsBlock(
      List<DApp> dapps, DAppLaunchScreenModel model, BuildContext context,
      {bool? isHorizontal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: () sync* {
                int packCnt = 0;
                List<Widget> pack = [];
                for (var i
                    in List<int>.generate(dapps.length, (index) => index)) {
                  var app = dapps[i];
                  pack.add(
                    DAppCardFull(
                      app,
                      () async {
                        var result = await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent.withOpacity(0),
                          builder: (c) {
                            return optionsBottomSheet(context);
                          },
                        );
                        if (result == true) {
                          model.currDapp = app;
                          model.isActiveDapp = false;
                          model.dappScreenModel.indexToShow = 2;
                          model.dappScreenModel.browserScreenModel
                              .launchDApp(app);
                        }
                      },
                      model,
                      isHorizontal: isHorizontal,
                    ),
                  );

                  packCnt += 1;

                  if (packCnt == 3 || dapps.length == i + 1) {
                    packCnt = 0;
                    if (isHorizontal != true) {
                      yield Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: pack);
                      pack = [];
                    } else {
                      yield Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: pack);
                      pack = [];
                    }
                  }
                }
              }()
                  .toList())),
    );
  }

  Widget dappsBlockAll(
    List<DApp> dapps,
    DAppLaunchScreenModel model,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: () sync* {
                List<Widget> pack = [];
                for (var i
                    in List<int>.generate(dapps.length, (index) => index)) {
                  var app = dapps[i];
                  pack.add(
                    DAppCardFullSearch(
                      app,
                      () async {
                        var result = await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent.withOpacity(0),
                          builder: (c) {
                            return optionsBottomSheet(context);
                          },
                        );
                        if (result == true) {
                          model.currDapp = app;
                          model.isActiveDapp = false;
                          model.dappScreenModel.indexToShow = 2;
                          model.dappScreenModel.browserScreenModel
                              .launchDApp(app);
                        }
                      },
                      model,
                    ),
                  );

                  yield Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: pack);
                }
              }()
                  .toList())),
    );
  }
}

Widget optionsBottomSheet(BuildContext context) {
  return AlierDialogCustom();
}

class DAppCardMin extends StatelessWidget {
  DApp dapp;
  DAppCardMin(this.dapp, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(12),
        width: 60,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: dapp.fromAsset
                  ? Image.asset(dapp.customImageUrl!)
                  : CachedNetworkImage(
                      imageUrl: dapp.customImageUrl ??
                          '$dappImageUrlBase/${dapp.url.host}.png',
                      placeholder: (ctx, url) =>
                          const BaseImagePlaceHolderWidget(),
                      errorWidget: (ctx, url, err) =>
                          const BaseImagePlaceHolderWidget(),
                    ),
            ),
            SizedBox(height: 10),
            AutoSizeText(
              dapp.name,
              softWrap: true,
              maxLines: dapp.name.split(' ').length,
            )
          ],
        ),
      ),
    );
  }
}

class DAppCardFullSearch extends StatelessWidget {
  DAppLaunchScreenModel launchScreenModel;
  DApp dapp;
  void Function() onTap;
  bool? isHorizontal;
  DAppCardFullSearch(
    this.dapp,
    this.onTap,
    this.launchScreenModel, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.secondaryBG,
            borderRadius: BorderRadius.circular(16),
          ),
          child: isHorizontal == true
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: dapp.image,
                    ),
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          dapp.name,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: AppColors.text.withOpacity(0.7),
                                  ),
                        ),
                      ],
                    )
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: dapp.image,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dapp.name,
                            style: Theme.of(context).textTheme.bodyText1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            dapp.description ?? '',
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ));
  }
}

class DAppCardFull extends StatelessWidget {
  DAppLaunchScreenModel launchScreenModel;
  DApp dapp;
  void Function() onTap;
  bool? isHorizontal;
  DAppCardFull(
    this.dapp,
    this.onTap,
    this.launchScreenModel, {
    Key? key,
    this.isHorizontal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: isHorizontal == true ? 65 : 260,
          margin: const EdgeInsets.all(12),
          child: isHorizontal == true
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: dapp.image,
                    ),
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          dapp.name,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: AppColors.text.withOpacity(0.7),
                                  ),
                        ),
                      ],
                    )
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: dapp.image,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dapp.name,
                              style: Theme.of(context).textTheme.bodyText1),
                          Text(
                            dapp.description ?? '',
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ));
  }
}

class DAppLoadingScreen extends StatefulWidget {
  DAppLaunchScreenModel launchScreenModel;
  DAppLoadingScreen(this.launchScreenModel, {Key? key}) : super(key: key);

  @override
  _DAppLoadingScreenState createState() => _DAppLoadingScreenState();
}

class _DAppLoadingScreenState extends State<DAppLoadingScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    animation = Tween<double>(begin: 140, end: 160).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          controller.reverse();
        else if (status == AnimationStatus.dismissed) controller.forward();
      });
    controller.forward();
  }
  // #enddocregion print-state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CAppBar(
          elevation: 0,
          title: Text('Loading...'),
          actions: [
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  widget.launchScreenModel.dappScreenModel.indexToShow = 0;
                  widget.launchScreenModel.dappScreenModel.browserScreenModel
                      .firstPageLoad = false;
                  widget.launchScreenModel.dappScreenModel.browserScreenModel
                      .loadEmpty();
                })
          ],
        ),
        body: Center(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return SizedBox(
                height: animation.value,
                width: animation.value,
                child: child,
              );
            },
            child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                clipBehavior: Clip.hardEdge,
                child: widget.launchScreenModel.currDapp?.image),
          ),
        ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  // #docregion print-state
}
