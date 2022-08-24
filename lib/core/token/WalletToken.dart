import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:voola/ui/styles/icons.dart';
import 'package:web3dart/credentials.dart';

import '../../ui/views/dapp_browser/DAppLaunchScreen.dart';
import 'utils.dart';

var chainIds = {
  TokenNetwork.Ethereum: 1,
  TokenNetwork.BinanceChain: 42,
  TokenNetwork.BinanceSmartChain: 56,
};

class WalletToken {
  late TokenNetwork network;
  int? chainID;
  late String standard;
  late String symbol;
  late String name;
  int? decimals;
  late String coingeckoId;
  // late bool show;
  EthereumAddress? ethAddress;

  WalletToken({
    required this.network,
    this.chainID,
    required this.standard,
    required this.symbol,
    required this.name,
    required this.decimals,
    required this.coingeckoId,
    // required this.show,
    this.ethAddress,
  });

  @override
  bool operator ==(Object other) {
    if (other is WalletToken)
      return chainID == other.chainID &&
          ethAddress == other.ethAddress &&
          standard == other.standard &&
          symbol == other.symbol &&
          network == other.network;
    else
      return false;
  }

  @override
  int get hashCode =>
      symbol.hashCode ^
      chainID.hashCode ^
      standard.hashCode ^
      network.hashCode ^
      (ethAddress?.hashCode ?? 1);

  WalletToken.fromJson(Map<String, dynamic> json, TokenNetwork tnetwork,
      [String? tstandard]) {
    network = tnetwork;
    standard = tstandard ?? json['standard'];
    symbol = json['symbol'];
    name = json['name'];
    decimals = json['decimals'];
    coingeckoId = json['coingeckoId'] ?? '-1';
    //show = json['showByDefault'] ?? false;
    if (json['address'] != null)
      ethAddress = EthereumAddress.fromHex(json['address']);
    chainID = chainIds[network] ?? 0;
  }

  Widget icon(double size) {
    if (standard == 'Native') {
      return AppIcons.token_ic(symbol.toLowerCase(), size);
    } else {
      String url;
      switch (network) {
        case TokenNetwork.BinanceChain:
          if (symbol == 'BNB') {
            url = '${TOKEN_ICON_BASE_URLs[network]}/info/logo.png';
          } else if (['TBC-3A7', 'TBCC-BA1M', 'VTBC-C26M', 'VOTE-692M']
              .contains(symbol)) {
            return AppIcons.token_ic(symbol.toLowerCase(), size);
          } else {
            url = '${TOKEN_ICON_BASE_URLs[network]}/assets/$symbol/logo.png';
          }
          break;
        case TokenNetwork.Ethereum:
          if (['TBCC', 'API3'].contains(symbol)) {
            return AppIcons.token_ic(symbol.toLowerCase(), size);
          } else {
            url =
                '${TOKEN_ICON_BASE_URLs[network]}/assets/${ethAddress!.hexEip55}/logo.png';
          }
          break;

        case TokenNetwork.BinanceSmartChain:
          if (['TBCC'].contains(symbol)) {
            return AppIcons.token_ic(symbol.toLowerCase(), size);
          } else {
            url =
                '${TOKEN_ICON_BASE_URLs[network]}/assets/${ethAddress!.hexEip55}/logo.png';
          }
          break;
        case TokenNetwork.Solana:
          //TODO
          url =
              '${TOKEN_ICON_BASE_URLs[network]}/assets/${ethAddress!.hexEip55}/logo.png';

          break;
        case TokenNetwork.Foil:
          url =
              '${TOKEN_ICON_BASE_URLs[network]}';
          break;
      }

      return CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        placeholder: (ctx, url) => const BaseImagePlaceHolderWidget(),
        errorWidget: (ctx, url, err) => const BaseImagePlaceHolderWidget(),
        //placeholder: (context, url) => CircularProgressIndicator(),
      );
    }
  }

  WalletToken.fromJsonCoin(Map<String, dynamic> json) {
    switch (json['network']) {
      case 'Ethereum':
        network = TokenNetwork.Ethereum;
        break;
      case 'BinanceSmartChain':
        network = TokenNetwork.BinanceSmartChain;
        break;
      case 'Solana':
        network = TokenNetwork.Solana;
        break;
      case 'Foil':
        network = TokenNetwork.Foil;
        break;
    }

    standard = 'Native';
    name = json['name'];
    symbol = json['symbol'];
    decimals = json['decimals'];
    coingeckoId = json['coingeckoId'];
    //show = json['show'] ?? false;
  }

  Map<String, dynamic> toJson() {
    var json_ = <String, dynamic>{
      "symbol": symbol,
      'name': name,
      "coingeckoId": coingeckoId,
    };
    if (decimals != null) json_["decimals"] = decimals;
    if (ethAddress != null) json_["address"] = ethAddress?.hexEip55;
    return json_;
  }

  Map<String, dynamic> toJsonCoin() {
    return {
      "network": network.toString().split('.').last,
      "symbol": symbol,
      "coingeckoId": coingeckoId,
      "decimals": decimals,
      "name": name,
    };
  }

  @override
  String toString() {
    return '$network - $standard - $symbol - $ethAddress';
  }
}
