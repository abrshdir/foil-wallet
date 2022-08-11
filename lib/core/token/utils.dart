import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web3dart/web3dart.dart';
import 'DexPair.dart';
import 'TokenContainer.dart';
import 'package:voola/locator.dart';
import 'dart:convert';
import 'WalletToken.dart';
import 'package:voola/shared.dart';

enum TokenNetwork { BinanceChain, Ethereum, BinanceSmartChain, Solana }

const TOKEN_ICON_BASE_URLs = {
  TokenNetwork.BinanceSmartChain:
      'https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/smartchain',
  TokenNetwork.BinanceChain:
      'https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/binance',
  TokenNetwork.Ethereum:
      'https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/ethereum',
  TokenNetwork.Solana:
      'https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/solana',
};

/////////////////////////////////////////////////////////////////

final _TOKENS_TYPES = [
  'bep2',
  'bep8',
  'bep20',
  'erc20',
  'coins',
];

final DEX_MARKET_PAIRS_BEP2 = {
  'BNB': 'BUSD-BD1',
  'AVA': 'BUSD-BD1',
  'ETH': 'BUSD-BD1',
  'BTC': 'BUSD-BD1',
  'LTC': 'BUSD-BD1',
};

Future<void> readWalletTokens() async {
  final tokensContainer = locator<WALLET_TOKENS_CONTAINER>();
  var jsonsAssets = (await Future.wait([
    for (var type in _TOKENS_TYPES)
      rootBundle.loadString('assets/tokens/assets_$type.json')
  ]))
      .map((e) => json.decode(e))
      .toList();

  var tokensDir = Directory(
      (await getApplicationSupportDirectory()).path + '/token_lists_show');
  if (await tokensDir.exists()) {
    var jsonsStorage = (await Future.wait([
      for (var type in _TOKENS_TYPES)
        File('${tokensDir.path}/assets_show_$type.json').readAsString()
    ]))
        .map((e) => json.decode(e));
    for (var tokenlist in jsonsStorage) {
      parseTokensShow(tokenlist, tokensContainer);
    }
  } else {
    await tokensDir.create(recursive: true);
    for (var i = 0; i < jsonsAssets.length; i++) {
      var json_ = Map.from(jsonsAssets[i]);
      json_['assets'] = (json_['assets'] as List<dynamic>)
          .where((element) => element['showByDefault'] == true)
          .toList();
      await File('${tokensDir.path}/assets_show_${_TOKENS_TYPES[i]}.json')
          .writeAsString(json.encode(json_));
      parseTokensShow(json_, tokensContainer);
    }
  }

  for (var tokenlist in jsonsAssets) {
    parseTokens(tokenlist, tokensContainer);
  }
  var _bnbToken = tokensContainer.BEP2.firstWhere((t) => t.symbol == 'BNB');
  var _busdToken =
      tokensContainer.BEP2.firstWhere((t) => t.symbol == 'BUSD-BD1');

  tokensContainer.DEX_MARKET_PAIRS = [
    DexMarketPair(
        tokensContainer.BEP8.firstWhere((t) => t.symbol == 'TBCC-BA1M'),
        _bnbToken,
        Decimal.parse('0.001'),
        Decimal.parse('0.00001')),
    DexMarketPair(
        tokensContainer.BEP8.firstWhere((t) => t.symbol == 'VTBC-C26M'),
        _bnbToken,
        Decimal.parse('0.01'),
        Decimal.parse('0.000001')),
    DexMarketPair(
        tokensContainer.BEP8.firstWhere((t) => t.symbol == 'VOTE-692M'),
        _bnbToken,
        Decimal.parse('0.1'),
        Decimal.parse('0.0000001')),
    DexMarketPair(
        _bnbToken, _busdToken, Decimal.parse('0.001'), Decimal.parse('0.001')),
    DexMarketPair(
        _bnbToken,
        tokensContainer.BEP2.firstWhere((t) => t.symbol == 'USDT-6D8'),
        Decimal.parse('0.001'),
        Decimal.parse('0.001')),
    DexMarketPair(
        _bnbToken,
        tokensContainer.BEP2.firstWhere((t) => t.symbol == 'ETH-1C9'),
        Decimal.parse('0.001'),
        Decimal.parse('0.000001')),
    DexMarketPair(tokensContainer.BEP2.firstWhere((t) => t.symbol == 'ETH-1C9'),
        _busdToken, Decimal.parse('0.001'), Decimal.parse('0.01')),
    DexMarketPair(tokensContainer.BEP2.firstWhere((t) => t.symbol == 'XRP-BF2'),
        _busdToken, Decimal.parse('0.1'), Decimal.parse('0.0000001')),
    DexMarketPair(tokensContainer.BEP2.firstWhere((t) => t.symbol == 'LTC-F07'),
        _busdToken, Decimal.parse('0.001'), Decimal.parse('0.0001')),
    DexMarketPair(
        tokensContainer.BEP2.firstWhere((t) => t.symbol == 'BTCB-1DE'),
        _busdToken,
        Decimal.parse('0.00001'),
        Decimal.parse('0.1')),
    DexMarketPair(
        tokensContainer.BEP2.firstWhere((t) => t.symbol == 'TRXB-2E6'),
        _bnbToken,
        Decimal.parse('10'),
        Decimal.parse('0.00000001')),
    DexMarketPair(tokensContainer.BEP2.firstWhere((t) => t.symbol == 'AVA-645'),
        _bnbToken, Decimal.parse('0.1'), Decimal.parse('0.0000001')),
    DexMarketPair(tokensContainer.BEP2.firstWhere((t) => t.symbol == 'BCH-1FD'),
        _bnbToken, Decimal.parse('0.001'), Decimal.parse('0.00001')),
    DexMarketPair(
        tokensContainer.BEP2.firstWhere((t) => t.symbol == 'RUNE-B1A'),
        _bnbToken,
        Decimal.parse('0.1'),
        Decimal.parse('0.0000001')),
    DexMarketPair(tokensContainer.BEP2.firstWhere((t) => t.symbol == 'TWT-8C2'),
        _bnbToken, Decimal.parse('1'), Decimal.parse('0.00000001')),
    DexMarketPair(
        tokensContainer.BEP2.firstWhere((t) => t.symbol == 'BTTB-D31'),
        _bnbToken,
        Decimal.parse('100'),
        Decimal.parse('0.00000001')),
    DexMarketPair(
        tokensContainer.BEP2.firstWhere((t) => t.symbol == 'NEXO-A84'),
        _bnbToken,
        Decimal.parse('1'),
        Decimal.parse('0.00000001')),
    DexMarketPair(tokensContainer.BEP2.firstWhere((t) => t.symbol == 'SHR-DB6'),
        _bnbToken, Decimal.parse('10'), Decimal.parse('0.00000001')),
    DexMarketPair(tokensContainer.BEP2.firstWhere((t) => t.symbol == 'CBM-4B2'),
        _bnbToken, Decimal.parse('1000'), Decimal.parse('0.00000001')),
    DexMarketPair(tokensContainer.BEP2.firstWhere((t) => t.symbol == 'AWC-986'),
        _bnbToken, Decimal.parse('1'), Decimal.parse('0.00000001')),
  ];

  var tbcbep20 =
      tokensContainer.BEP20.firstWhere((element) => element.symbol == 'TBCC');
  var tbcerc20 =
      tokensContainer.ERC20.firstWhere((element) => element.symbol == 'TBCC');

  tokensContainer.crossChainSwapTokens = {};
  var crossChainLinkedBep2Tokens = tokensContainer.BEP2
      .where((element) => element.ethAddress != null)
      .toList();
  //crossChainLinkedBep2Tokens.add(tokensContainer.BEP2.firstWhere((element) => element.symbol == 'BNB'));
  for (var t in crossChainLinkedBep2Tokens) {
    List<WalletToken> toTokens;

    if (t.symbol == 'BNB') {
      toTokens = <WalletToken>[
        tokensContainer.COINS.firstWhere((element) => element.symbol == 'BNB')
      ];
    } else {
      var token = tokensContainer.BEP20
          .firstWhereMaybe((element) => element.ethAddress == t.ethAddress);
      if (token != null) {
        toTokens = [token];
      } else {
        toTokens = [];
      }
    }
    tokensContainer.crossChainSwapTokens[t] = toTokens;
  }
  for (var t in tokensContainer.crossChainSwapTokens.entries.toList()) {
    tokensContainer.crossChainSwapTokens[t.value.first] = [t.key];
  }

  tokensContainer.crossChainSwapTokens[tbcerc20] = [tbcbep20];

  ///////////////////////////////////////////////////////////////////////////////
  var tbccbep8 = tokensContainer.BEP8
      .firstWhereMaybe((element) => element.symbol == 'TBCC-BA1M');
  if (!tokensContainer.BEP8_show.contains(tbccbep8) && tbccbep8 != null) {
    tokensContainer.BEP8_show.add(tbccbep8);
    saveTokenLists(tokensContainer);
  }
}

void parseTokens(tokenlist, WALLET_TOKENS_CONTAINER tokensContainer) {
  switch (tokenlist['network']) {
    case 'Ethereum':
      var assets = tokenlist['assets'];
      tokensContainer.ERC20.addAll([
        for (var asset in assets)
          WalletToken.fromJson(asset, TokenNetwork.Ethereum, 'ERC20')
      ]);
      break;
    case 'BinanceSmartChain':
      var assets = tokenlist['assets'];
      tokensContainer.BEP20.addAll([
        for (var asset in assets)
          WalletToken.fromJson(asset, TokenNetwork.BinanceSmartChain, 'BEP20')
      ]);
      break;
    case 'Native':
      var assets = tokenlist['assets'];
      tokensContainer.COINS
          .addAll([for (var asset in assets) WalletToken.fromJsonCoin(asset)]);
      break;
    case 'BinanceChain':
      switch (tokenlist['standard']) {
        case 'BEP2':
          var assets = tokenlist['assets'];
          tokensContainer.BEP2.addAll([
            for (var asset in assets)
              WalletToken.fromJson(asset, TokenNetwork.BinanceChain, 'BEP2')
          ]);
          break;
        case 'BEP8':
          var assets = tokenlist['assets'];
          tokensContainer.BEP8.addAll([
            for (var asset in assets)
              WalletToken.fromJson(asset, TokenNetwork.BinanceChain, 'BEP8')
          ]);
          break;
      }
      break;

    //case 'user':
    //  var assets = tokenlist['assets'];
    //  for (var asset in assets) {
    //    switch (asset['standard']) {
    //      case 'ERC20':
    //        tokensContainer.USER.add(WalletToken.fromJson(asset, TokenNetwork.Ethereum, 'ERC20'));
    //        break;
    //      case 'BEP20':
    //        tokensContainer.USER.add(WalletToken.fromJson(asset, TokenNetwork.BinanceSmartChain, 'BEP20'));
    //        break;
    //    }
    //    break;
    //  }
  }
}

void parseTokensShow(tokenlist, WALLET_TOKENS_CONTAINER tokensContainer) {
  switch (tokenlist['network']) {
    case 'Ethereum':
      var assets = tokenlist['assets'];
      tokensContainer.ERC20_show.addAll([
        for (var asset in assets)
          WalletToken.fromJson(asset, TokenNetwork.Ethereum, 'ERC20')
      ]);
      break;
    case 'BinanceSmartChain':
      var assets = tokenlist['assets'];
      tokensContainer.BEP20_show.addAll([
        for (var asset in assets)
          WalletToken.fromJson(asset, TokenNetwork.BinanceSmartChain, 'BEP20')
      ]);
      break;
    case 'Native':
      var assets = tokenlist['assets'];
      tokensContainer.COINS_show.addAll(
          [for (var asset in assets) WalletToken.fromJsonCoin(asset)]);
      break;
    case 'BinanceChain':
      switch (tokenlist['standard']) {
        case 'BEP2':
          var assets = tokenlist['assets'];
          tokensContainer.BEP2_show.addAll([
            for (var asset in assets)
              WalletToken.fromJson(asset, TokenNetwork.BinanceChain, 'BEP2')
          ]);
          break;
        case 'BEP8':
          var assets = tokenlist['assets'];
          tokensContainer.BEP8_show.addAll([
            for (var asset in assets)
              WalletToken.fromJson(asset, TokenNetwork.BinanceChain, 'BEP8')
          ]);
          break;
      }
      break;

    //case 'user':
    //  var assets = tokenlist['assets'];
    //  for (var asset in assets) {
    //    switch (asset['standard']) {
    //      case 'ERC20':
    //        tokensContainer.USER.add(WalletToken.fromJson(asset, TokenNetwork.Ethereum, 'ERC20'));
    //        break;
    //      case 'BEP20':
    //        tokensContainer.USER.add(WalletToken.fromJson(asset, TokenNetwork.BinanceSmartChain, 'BEP20'));
    //        break;
    //    }
    //    break;
    //  }
  }
}

Future<void> saveTokenLists(WALLET_TOKENS_CONTAINER container,
    [String? dirPath]) async {
  if (dirPath == null) {
    dirPath =
        (await getApplicationSupportDirectory()).path + '/token_lists_show';
  }
  for (var type in [..._TOKENS_TYPES]) {
    var map = <String, dynamic>{};
    switch (type) {
      case 'bep2':
        map = <String, dynamic>{
          "network": "BinanceChain",
          "standard": "BEP2",
          "assets": [...container.BEP2_show.map((e) => e.toJson())]
        };
        break;
      case 'bep8':
        map = <String, dynamic>{
          "network": "BinanceChain",
          "standard": "BEP8",
          "assets": [...container.BEP8_show.map((e) => e.toJson())]
        };
        break;
      case 'bep20':
        map = <String, dynamic>{
          "network": "BinanceSmartChain",
          "standard": "BEP20",
          "assets": [...container.BEP20_show.map((e) => e.toJson())]
        };
        break;
      case 'erc20':
        map = <String, dynamic>{
          "network": "Ethereum",
          "standard": "ERC20",
          "assets": [...container.ERC20_show.map((e) => e.toJson())]
        };
        break;
      case 'coins':
        map = <String, dynamic>{
          "network": "Native",
          "standard": "Native",
          "assets": [...container.COINS_show.map((e) => e.toJsonCoin())]
        };
        break;
      //case 'user':
      //  map = <String, dynamic>{
      //    "assets": [...container.USER.map((e) => e.toJsonUser())]
      //  };
      //  break;
    }
    await File('$dirPath/assets_show_$type.json')
        .writeAsString(json.encode(map));
  }
}
