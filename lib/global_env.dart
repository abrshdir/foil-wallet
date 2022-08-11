import 'package:binance_chain/binance_chain.dart';
import 'package:binance_chain/binance_chain.dart' as bc;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:solana/solana.dart' as sol;
import 'package:voola/core/token/TokenContainer.dart';
import 'package:voola/core/token/utils.dart';
import 'package:web3dart/web3dart.dart';

import 'core/settings/AppSettings.dart';
import 'locator.dart';

class ENVS_CONTAINER {
  bc.HttpApiClient? BC_ENV;

  Web3Client? BSC_ENV;
  Web3Client? ETH_ENV;
  Web3Client? ETH_DAPP_ENV;
  sol.RPCClient? SOL_ENV;
  Map<int, String>? chainId_urlProvider;
  Map<int, dynamic>? chainId_Provider;
}

final ENVS = ENVS_CONTAINER();

late String FIAT_CURRENCY_SYMBOL = 'USD';
late String FIAT_CURRENCY_LITERAL = r'$';

void setupEnv() {
  var settings = locator<AppSettings>();
  ENVS.BC_ENV = bc.HttpApiClient(
      env: BinanceEnvironment(
          'https://${settings.bc_rpc}', 'wss://${settings.bc_rpc}', 'bnb'));
  ENVS.BSC_ENV = Web3Client(settings.bsc_rpc, Client());
  ENVS.ETH_ENV = Web3Client(settings.eth_rpc, Client());
  ENVS.ETH_DAPP_ENV = Web3Client(settings.eth_dapp_rpc, Client());
  ENVS.SOL_ENV = sol.RPCClient(settings.sol_rpc);
  ENVS.chainId_urlProvider = {
    1: settings.eth_dapp_rpc,
    56: settings.bsc_rpc,
  };
  ENVS.chainId_Provider = {
    1: ENVS.ETH_DAPP_ENV,
    56: ENVS.BSC_ENV,
  };
}

final FIAT_CURRENCIES = [
  "USD", // united states dollar
  "HKD", // hong-kong dollar
  "CNY", // chinese yuan (renminbi)
  "JPY", // Japanese yen
  "EUR", // euro
  "GBP", // Pound sterling
  "SGD", // Singapore dollar
  "RUB", // russian rouble
  "UAH", // ukrainian hryvna
  "AED", // UAE dirham
  "AUD", // Australian dollar
  "BDT", // bengladesh taka
  "BHD", // Bahraini dinar
  "BMD", // Bermudian dollar
  "CAD", // Canadian dollar
  "CHF", // Swiss franc
  "CLP", // chilean peso
  "CZK", // Czech koruna
  "DKK", // Danish krone
  "HUF", // Hungarian forint
  "IDR", // Indonesian rupiah
  "ILS", // Israeli new shekel
  "INR", // Indian rupee
  "KRW", // South Korean won
  "KWD", // Kuwaiti dinar
  "MMK", // Myanmar kyat
  "MYR", // Malaysian ringgit
  "NGN", // Nigerian naira
  "NOK", // Norwegian krone
  "NZD", // New Zealand dollar
  "PHP", // Philippine peso
  "PKR", // Pakistani rupee
  "PLN", // Polish złoty
  "SAR", // Saudi riyal
  "SEK", // Swedish krona
  "THB", // Thai baht
  "TRY", // Turkish lira
  "VEF", // Venezuelan bolívar
  "VND", // Vietnamese dong
];
final FIAT_CURRENCIES_LITERALS = {
  "USD": r"$", // united states dollar
  "HKD": r"$", // hong-kong dollar
  "SGD": r"$", // Singapore dollar
  "AUD": r"$", // Australian dollar
  "BMD": r"$", // Bermudian dollar
  "CAD": r"$", // Canadian dollar
  "NZD": r"$", // New Zealand dollar
  'CNY': r'¥',
  'JPY': r'¥',
  'EUR': r'€',
  'GBP': r'£',
  'CLP': r'$',
  'IDR': r'Rp',
  'ILS': r'₪',
  'KRW': r'₩',
  'MYR': r'RM',
  'NOK': r'kr',
  'PLN': r'zł',
  'SEK': r'kr',
  'THB': r'฿',
  'VEF': r'Bs',
  'VND': r'₫',
};

final NETWORK_COINS = {
  TokenNetwork.BinanceSmartChain: 'bnb',
  TokenNetwork.BinanceChain: 'bnb',
  TokenNetwork.Ethereum: 'eth',
  TokenNetwork.Solana: 'sol',
};

class TokenNetworkInfoWrapper {
  TokenNetwork network;
  String name;
  TokenNetworkInfoWrapper(this.network, this.name);

  Widget icon(double size) {
    return (network != TokenNetwork.BinanceChain
            ? locator<WALLET_TOKENS_CONTAINER>().COINS
            : locator<WALLET_TOKENS_CONTAINER>().BEP2)
        .firstWhere(
            (element) => element.symbol.toLowerCase() == NETWORK_COINS[network])
        .icon(size);
  }
}

final NETWORKS_INFO = {
  TokenNetwork.BinanceChain:
      TokenNetworkInfoWrapper(TokenNetwork.BinanceChain, 'Binance Chain'),
  TokenNetwork.BinanceSmartChain: TokenNetworkInfoWrapper(
      TokenNetwork.BinanceSmartChain, 'Binance Smart Chain'),
  TokenNetwork.Ethereum:
      TokenNetworkInfoWrapper(TokenNetwork.Ethereum, 'Ethereum'),
  TokenNetwork.Solana: TokenNetworkInfoWrapper(TokenNetwork.Solana, 'Solana'),
};
