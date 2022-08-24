import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:voola/core/api/ApiBase.dart';
import 'package:voola/core/api/binance_chain/BCApi.dart';
import 'package:voola/core/api/coingecko/CoingeckoAPI.dart';
import 'package:voola/core/api/coingecko/model/SimplePrice.dart';
import 'package:voola/core/api/tbcc/TBCCApi.dart';
import 'package:voola/core/api/tbcc/models/TBCCUser.dart';
import 'package:voola/core/blockchain/binance_smart_chain/contracts/BEP20_abi.dart';

import 'package:voola/core/blockchain/ethereum/Multicall.dart';
import 'package:voola/core/blockchain/ethereum/contracts/ERC20_abi.dart';
import 'package:voola/core/storage/SecureStorage.dart';
import 'package:voola/core/tickers/TickersService.dart';
import 'package:voola/core/token/utils.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/wallet/WalletMainScreenModel.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'UserAccount.dart';
import '../token/TokenContainer.dart';
import '../token/WalletToken.dart';
import '../blockchain/binance_smart_chain/Multicall.dart';
import 'package:binance_chain/binance_chain.dart' as bc;
import 'package:solana/solana.dart' as sol;
import 'package:voola/locator.dart';

enum AccType { Free, Pro, Premium }

class ComputeTickersArg {
  List<String> coingeckoIds;
  String fiatCurr;
  TickersService tickersProvider;
  BinanceChainApi bcProvider;

  ComputeTickersArg(
      this.coingeckoIds, this.fiatCurr, this.tickersProvider, this.bcProvider);
}

class ComputeTickersResult {
  Map<String, SimplePrice> tickers;

  ComputeTickersResult(this.tickers);
}

class ComputeBalancesArg<AddrType, ProviderType> {
  List<WalletToken> tokens;
  List<AddrType> addresses;
  Map<String, SimplePrice> tickers;
  List<dynamic>? additionalArgs;
  ProviderType provider;
  ComputeBalancesArg(this.tokens, this.addresses, this.tickers, this.provider,
      [this.additionalArgs]);
}

class ComputeBalancesResult<AddrType> {
  bool hasError;
  List<ParsedBalances<AddrType>> result;
  ComputeBalancesResult(this.hasError, this.result);
}

class ParsedBalances<AddrType> {
  AddrType address;
  List<WalletBalance> balances;
  dynamic additionalLoad;
  ParsedBalances(this.address, this.balances);
}

class AccountManager extends ChangeNotifier {
  final _storage = locator<Storage>();
  final _tbccApi = locator<TBCCApi>();
  final tickersService = locator<TickersService>();
  final blockchainConnState = locator<BLOCKCHAIN_CONNECTION_STATE>();
  late List<bc.WebsocketBinanceListener> binanceBalancesListeners = [];
  List<UserAccount> allAccounts = <UserAccount>[];
  AccType accountType = AccType.Free;
  DateTime? subscriptionExpireDate;
  AccountManager();

  Timer? reloadTickerTimer;

  final _tokensContainer = locator<WALLET_TOKENS_CONTAINER>();

  Future<void> loadAccounts([bool notify = true]) async {
    var _ethTokens = [
      _tokensContainer.COINS.firstWhere((c) => c.symbol == 'ETH'),
      ..._tokensContainer.ERC20_show
    ];
    var _bscTokens = [
      _tokensContainer.COINS.firstWhere((c) => c.symbol == 'BNB'),
      ..._tokensContainer.BEP20_show
    ];
    var _bcTokens = [
      ..._tokensContainer.BEP2_show,
      ..._tokensContainer.BEP8_show
    ];
    var _solanaTokens = [
      _tokensContainer.COINS.firstWhere((c) => c.symbol == 'SOL')
    ];

    var _foilTokens = [
      _tokensContainer.COINS.firstWhere((c) => c.symbol == 'Foil')
    ];

    var ids = {
      ..._ethTokens.map((e) => e.coingeckoId).toSet(),
      ..._bscTokens.map((e) => e.coingeckoId).toSet(),
      ..._bcTokens.map((e) => e.coingeckoId).toSet(),
      ..._solanaTokens.map((e) => e.coingeckoId).toSet(),
      ..._foilTokens.map((e) => e.coingeckoId).toSet(),
    }.toList();

    try {
      tickersService.simpleTickers = (await locator<CoingeckoApi>().loadTickers(
              ids: ids..removeWhere((element) => element == '-1'),
              include24hchange: true,
              include24hvol: true,
              vsCurrencies: [FIAT_CURRENCY_SYMBOL.toLowerCase()]))
          .load;

      var bep8Tickers = await locator<BinanceChainApi>().getMiniTickers();

      var bep8Tokens = [
        'TBCC-BA1M_BNB',
        'VOTE-692M_BNB',
        'VTBC-C26M_BNB',
      ];

      var bnb = tickersService.simpleTickers!['binancecoin'];
      for (var t in bep8Tickers.load) {
        if (bep8Tokens.contains(t.symbol)) {
          var ticker = SimplePrice();
          ticker.inCurrency = bnb!.inCurrency! * Decimal.parse(t.lastPrice!);
          ticker.priceChange = Decimal.parse(t.priceChangePercent!);
          ticker.volume = bnb.inCurrency! * Decimal.parse(t.quoteVolume!);
          ticker.marketCap = Decimal.zero;
          tickersService.simpleTickers?[t.symbol!.split('_').first] = ticker;
        }
      }
      for (var t in bep8Tokens) {
        if (tickersService.simpleTickers![t.split('_').first] == null) {
          tickersService.simpleTickers![t.split('_').first] =
              SimplePrice.zero();
        }
      }

      // (await compute(
      //        _loadTickers,
      //        ComputeTickersArg(
      //          coingeckoIdsTickers,
      //          FIAT_CURRENCY_SYMBOL.toLowerCase(),
      //          locator<TickersService>(),
      //          locator<BinanceChainApi>(),
      //        )))
      //    .tickers;
    } catch (e, st) {
      print(e);
      print(st);
    }
    var results = await Future.wait([
      compute(
          _loadEthBalances,
          ComputeBalancesArg<EthereumAddress, Web3Client>(
            _ethTokens,
            allAccounts.map((e) => e.ethWallet.address).toList(),
            tickersService.simpleTickers!,
            ENVS.ETH_ENV!,
          )),
      compute(
          _loadBSCBalances,
          ComputeBalancesArg<EthereumAddress, Web3Client>(
            _bscTokens,
            allAccounts.map((e) => e.bscWallet.address).toList(),
            tickersService.simpleTickers!,
            ENVS.BSC_ENV!,
          )),
      //compute(
      //    _loadBCBalances,
      //    ComputeBalancesArg<String, bc.HttpApiClient>(
      //      _bcTokens,
      //      allAccounts.map((e) => e.bcWallet.address!).toList(),
      //      tickersService.simpleTickers!,
      //      ENVS.BC_ENV!,
      //      [..._tokensContainer.BEP2, ..._tokensContainer.BEP8],
      //    )),
      compute(
        _loadSolanaBalances,
        ComputeBalancesArg<String, sol.RPCClient>(
          _solanaTokens,
          allAccounts.map((e) => e.solWallet.address).toList(),
          tickersService.simpleTickers!,
          ENVS.SOL_ENV!,
        ),
      ),
      compute(
        _loadFoilBalances,
        ComputeBalancesArg(
          _foilTokens,
          allAccounts.map((e) => e.foilWallet.address).toList(),
          tickersService.simpleTickers!,
          ENVS.SOL_ENV!,
        ),
      ),
      _tbccApi.getUsers(allAccounts.map((e) => e.bcWallet.address!).toList()),
    ]);
    var ethResults = results[0] as ComputeBalancesResult<EthereumAddress>;
    if (ethResults.hasError) {
      blockchainConnState
        ..states[TokenNetwork.Ethereum] = false
        ..notifyListeners();
    } else {
      if (blockchainConnState.states[TokenNetwork.Ethereum] != true) {
        blockchainConnState
          ..states[TokenNetwork.Ethereum] = true
          ..notifyListeners();
      }
      for (var result in ethResults.result) {
        try {
          var acc = allAccounts
              .firstWhere((acc) => acc.ethWallet.address == result.address);
          acc.coinBalances = [];
          acc.coinBalances.add(result.balances.first);
          acc.erc20Balances = result.balances.sublist(1);
        } catch (e, st) {
          print(
              'err: account with eth address ${result.address.hex} not found');
          print('$e\n$st');
        }
      }
    }

    var bscResults = results[1] as ComputeBalancesResult<EthereumAddress>;
    if (bscResults.hasError) {
      blockchainConnState
        ..states[TokenNetwork.BinanceSmartChain] = false
        ..notifyListeners();
    } else {
      if (blockchainConnState.states[TokenNetwork.BinanceSmartChain] != true) {
        blockchainConnState
          ..states[TokenNetwork.BinanceSmartChain] = true
          ..notifyListeners();
      }
      for (var result in bscResults.result) {
        try {
          var acc = allAccounts
              .firstWhere((acc) => acc.bscWallet.address == result.address);
          var coinIndex = acc.coinBalances
              .indexWhere((e) => e.token == result.balances.first.token);
          if (coinIndex < 0)
            acc.coinBalances.add(result.balances.first);
          else
            acc.coinBalances[coinIndex] = result.balances.first;
          acc.bep20Balances = result.balances.sublist(1);
        } catch (e, st) {
          print(
              'err: account with eth address ${result.address.hex} not found');
          print('$e\n$st');
        }
      }
    }

    //var bcResults = results[2] as ComputeBalancesResult<String>;
    var bcResults =
        await _loadBCBalances(ComputeBalancesArg<String, bc.HttpApiClient>(
      _bcTokens,
      allAccounts.map((e) => e.bcWallet.address!).toList(),
      tickersService.simpleTickers!,
      ENVS.BC_ENV!,
      [..._tokensContainer.BEP2, ..._tokensContainer.BEP8],
    ));
    if (bcResults.hasError) {
      blockchainConnState
        ..states[TokenNetwork.BinanceChain] = false
        ..notifyListeners();
    } else {
      if (blockchainConnState.states[TokenNetwork.BinanceChain] != true) {
        blockchainConnState
          ..states[TokenNetwork.BinanceChain] = true
          ..notifyListeners();
      }
      for (var result in bcResults.result) {
        try {
          var acc = allAccounts
              .firstWhere((acc) => acc.bcWallet.address == result.address);

          acc.bc_bep2_Balances =
              result.balances.where((b) => b.token.standard == 'BEP2').toList();
          acc.bc_bep8_Balances =
              result.balances.where((b) => b.token.standard == 'BEP8').toList();
          acc.bc_Balances_all = result.additionalLoad as List<WalletBalance>;
        } catch (e, st) {
          print('err: account with eth address ${result.address} not found');
          print('$e\n$st');
        }
      }
    }

    var solResults = results[2] as ComputeBalancesResult<String>;
    if (solResults.hasError) {
      blockchainConnState
        ..states[TokenNetwork.Solana] = false
        ..notifyListeners();
    } else {
      if (blockchainConnState.states[TokenNetwork.Solana] != true) {
        blockchainConnState
          ..states[TokenNetwork.Solana] = true
          ..notifyListeners();
      }
      for (var result in solResults.result) {
        try {
          var acc = allAccounts
              .firstWhere((acc) => acc.solWallet.address == result.address);
          var coinIndex = acc.coinBalances
              .indexWhere((e) => e.token == result.balances.first.token);
          if (coinIndex < 0)
            acc.coinBalances.add(result.balances.first);
          else
            acc.coinBalances[coinIndex] = result.balances.first;
          //TODO
          //acc.bep20Balances = result.balances.sublist(1);
        } catch (e, st) {
          print('err: account with eth address ${result.address} not found');
          print('$e\n$st');
        }
      }
    }

    var foilResults = results[3] as ComputeBalancesResult<String>;
    if (foilResults.hasError) {
      blockchainConnState
        ..states[TokenNetwork.Foil] = false
        ..notifyListeners();
    } else {
      if (blockchainConnState.states[TokenNetwork.Foil] != true) {
        blockchainConnState
          ..states[TokenNetwork.Foil] = true
          ..notifyListeners();
      }
      for (var result in foilResults.result) {
        try {
          var acc = allAccounts
              .firstWhere((acc) => acc.foilWallet.address == result.address);
          var coinIndex = acc.coinBalances
              .indexWhere((e) => e.token == result.balances.first.token);
          if (coinIndex < 0)
            acc.coinBalances.add(result.balances.first);
          else
            acc.coinBalances[coinIndex] = result.balances.first;
          //TODO
          //acc.bep20Balances = result.balances.sublist(1);
        } catch (e, st) {
          print('err: account with eth address ${result.address} not found');
          print('$e\n$st');
        }
      }
    }

    var tbccResult = results.last as ApiResponse<List<TBCCUserModel>>;

    allAccounts.forEach((acc) {
      try {
        var user = tbccResult.load
            .firstWhere((user) => acc.bcWallet.address == user.address);
        acc.tbccUser = user;
        if (user.paidFee.toString().startsWith('2')) {
          accountType = AccType.Pro;
        } else if (user.paidFee.toString().startsWith('1.5')) {
          if (accountType != AccType.Pro) {
            accountType = AccType.Premium;
          }
        }
        accountType = AccType.Pro; // hardcode pro account
      } catch (e) {
        acc.tbccUser = TBCCUserModel(address: acc.bcWallet.address!);
        _tbccApi.newClient(acc.bcWallet.address!);
      }
    });

    var userSubDates = [];
    tbccResult.load.forEach((user) {
      allAccounts
          .firstWhere((acc) => acc.bcWallet.address == user.address)
          .tbccUser = user;
      userSubDates.add(user.subPurchaseDate
          ?.add(Duration(days: 365))
          .millisecondsSinceEpoch);
    });

    var greaterDate = 0;
    for (var d in userSubDates) {
      if (d != null && d > greaterDate) {
        greaterDate = d;
      }
    }
    subscriptionExpireDate = greaterDate != 0
        ? DateTime.fromMillisecondsSinceEpoch(greaterDate)
        : null;

    for (var sub in binanceBalancesListeners) {
      try {
        await sub.close();
      } catch (e) {}
    }
    binanceBalancesListeners.clear();
    for (var acc in allAccounts) {
      acc.allBalances = [
        ...acc.coinBalances,
        ...acc.erc20Balances,
        ...acc.bep20Balances,
        ...acc.bc_bep2_Balances,
        ...acc.bc_bep8_Balances
      ];
      acc.calcTotalBalance();
      acc.calcTotalPNL();
      acc.sortBalances();

      var listener = bc.WebsocketBinanceListener(ENVS.BC_ENV!.env!)
        ..subscribeAccountUpdates(
          acc.bcWallet.address!,
          onMessage: (bc.WsBinanceMessage<bc.AccountData> message) async {
            try {
              var newBalances = message.data?.balances;
              if (newBalances != null) {
                acc.bc_bep2_Balances.forEach((balance) {
                  var index = newBalances.indexWhere(
                      (newBalance) => newBalance.asset == balance.token.symbol);
                  if (index != -1) {
                    balance.balance = Decimal.parse(newBalances[index].free!);
                    balance.fiatBalance = (tickersService
                                .simpleTickers![balance.token.coingeckoId]
                                ?.inCurrency ??
                            Decimal.zero) *
                        balance.balance;
                  } else {
                    balance.balance = Decimal.zero;
                    balance.fiatBalance = Decimal.zero;
                  }
                });
                acc.bc_bep8_Balances.forEach((balance) {
                  var index = newBalances.indexWhere(
                      (newBalance) => newBalance.asset == balance.token.symbol);
                  if (index != -1) {
                    balance.balance = Decimal.parse(newBalances[index].free!);
                    balance.fiatBalance = (tickersService
                                .simpleTickers![balance.token.coingeckoId]
                                ?.inCurrency ??
                            Decimal.zero) *
                        balance.balance;
                  } else {
                    balance.balance = Decimal.zero;
                    balance.fiatBalance = Decimal.zero;
                  }
                });
                acc.calcTotalBalance();
                notifyListeners();
              }
            } catch (e, st) {
              print('$e: $st');
            }
          },
        );

      this.binanceBalancesListeners.add(listener);
    }

    reloadTickerTimer?.cancel();
    reloadTickerTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      reloadTickers();
    });
    if (notify) notifyListeners();
  }

  Future<void> reloadTickers([bool notify = true]) async {
    await tickersService.loadSimpleTickers(
      allAccounts.first.allBalances
          .map(
            (e) => e.token.coingeckoId,
          )
          .toSet()
          .toList(),
      FIAT_CURRENCY_SYMBOL,
    );
    var bep8Tickers = await locator<BinanceChainApi>().getMiniTickers();

    var bep8Tokens = [
      'TBCC-BA1M_BNB',
      'VOTE-692M_BNB',
      'VTBC-C26M_BNB',
    ];

    var bnb = tickersService.simpleTickers!['binancecoin'];
    for (var t in bep8Tickers.load) {
      if (bep8Tokens.contains(t.symbol)) {
        var ticker = SimplePrice();
        ticker.inCurrency = bnb!.inCurrency! * Decimal.parse(t.lastPrice!);
        ticker.priceChange = Decimal.parse(t.priceChangePercent!);
        ticker.volume = bnb.inCurrency! * Decimal.parse(t.quoteVolume!);
        ticker.marketCap = Decimal.zero;
        tickersService.simpleTickers?[t.symbol!.split('_').first] = ticker;
      }
    }
    for (var t in bep8Tokens) {
      if (tickersService.simpleTickers![t.split('_').first] == null) {
        tickersService.simpleTickers![t.split('_').first] = SimplePrice.zero();
      }
    }
    var tickers = tickersService.simpleTickers;
    allAccounts.forEach((acc) {
      acc.allBalances.forEach((bal) {
        var ticker = tickers![bal.token.standard != 'BEP8'
            ? bal.token.coingeckoId
            : bal.token.symbol];
        bal.fiatPrice = ticker?.inCurrency ?? Decimal.zero;
        bal.changePercent = ticker?.priceChange ?? Decimal.zero;
        bal.fiatBalance = bal.fiatPrice * bal.balance;
      });
      acc.totalBalance = acc.allBalances.fold<Decimal>(Decimal.zero,
          (previousValue, element) => previousValue + element.fiatBalance);
    });

    if (notify) notifyListeners();
  }

  addressByToken(int accIndex, WalletToken token) {
    var acc = allAccounts[accIndex];
    var network = token.network;
    if (network == TokenNetwork.Ethereum)
      return acc.ethWallet.address.hex;
    else if (network == TokenNetwork.BinanceChain)
      return acc.bcWallet.address;
    else if (network == TokenNetwork.BinanceSmartChain)
      return acc.bscWallet.address.hex;
    else if (network == TokenNetwork.Solana)
      return acc.solWallet.address;
    else
      return '';
  }

  WalletBalance? balanceByToken(int accIndex, WalletToken token) {
    var acc = allAccounts[accIndex];
    List<WalletBalance> balancesList;
    switch (token.standard) {
      case 'BEP2':
        balancesList = acc.bc_bep2_Balances;
        break;
      case 'BEP8':
        balancesList = acc.bc_bep8_Balances;
        break;
      case 'ERC20':
        balancesList = acc.erc20Balances;
        break;
      case 'BEP20':
        balancesList = acc.bep20Balances;
        break;
      default:
        balancesList = acc.coinBalances;
    }
    try {
      return balancesList.firstWhere((element) => element.token == token);
    } catch (e) {
      print(e);
      return null;
    }
  }

  WalletBalance? bcBalanceByToken(int accIndex, WalletToken token) {
    var acc = allAccounts[accIndex];

    try {
      return acc.bc_Balances_all
          .firstWhere((element) => element.token == token);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveAccounts() async {
    _storage.writeUserAccounts(
        json.encode([for (var i in this.allAccounts) i.toJson()]));
  }

  Future<void> deleteAllAccounts() async {
    allAccounts.clear();
    _storage.writeUserAccounts('[]');
  }

  Future<WalletBalance> loadSingleTokenBalance(
      WalletToken token, UserAccount account) async {
    var balance = WalletBalance()..token = token;

    if (token.standard == 'Native') {
      if (token.symbol == 'BNB') {
        balance.balance =
            (await ENVS.BSC_ENV!.getBalance(account.bscWallet.address))
                .weiToDecimalEther(token.decimals!);
      } else if (token.symbol == 'ETH') {
        balance.balance =
            (await ENVS.ETH_ENV!.getBalance(account.ethWallet.address))
                .weiToDecimalEther(token.decimals!);
      }
    } else if (token.standard == 'BEP20') {
      balance.balance = (await ENVS.BSC_ENV!.call(
              contract:
                  DeployedContract(erc20BasicContractAbi, token.ethAddress!),
              function: erc20BasicContractAbi.functions
                  .firstWhere((f) => f.name == 'balanceOf'),
              params: [account.bscWallet.address]))
          .first
          .weiToDecimalEther(token.decimals);
    } else if (token.standard == 'ERC20') {
      balance.balance = (await ENVS.ETH_ENV!.call(
              contract:
                  DeployedContract(bep20BasicContractAbi, token.ethAddress!),
              function: bep20BasicContractAbi.functions
                  .firstWhere((f) => f.name == 'balanceOf'),
              params: [account.ethWallet.address]))
          .first
          .weiToDecimalEther(token.decimals);
    } else if (token.standard == 'BEP2' || token.standard == 'BEP8') {
      var bal = (await ENVS.BC_ENV!.getAccount(account.bcWallet.address))
          .load
          ?.balances
          ?.firstWhereMaybe((element) => element.symbol == token.symbol,
              orElse: () => null);
      if (bal == null) {
        balance.balance = Decimal.zero;
      } else {
        balance.balance = Decimal.parse(bal.free!);
      }
    }
    return balance;
  }
}

Future<ComputeTickersResult> _loadTickers(ComputeTickersArg args) async {
  var ts = args.tickersProvider;

  await ts.loadSimpleTickers(args.coingeckoIds, args.fiatCurr);

  var bep8Tickers = await args.bcProvider.getMiniTickers();

  var bep8Tokens = [
    'TBCC-BA1M_BNB',
    'VOTE-692M_BNB',
    'VTBC-C26M_BNB',
  ];

  var bnb = ts.simpleTickers!['binancecoin'];
  for (var t in bep8Tickers.load) {
    if (bep8Tokens.contains(t.symbol)) {
      var ticker = SimplePrice();
      ticker.inCurrency = bnb!.inCurrency! * Decimal.parse(t.lastPrice!);
      ticker.priceChange = Decimal.parse(t.priceChangePercent!);
      ticker.volume = bnb.inCurrency! * Decimal.parse(t.quoteVolume!);
      ticker.marketCap = Decimal.zero;
      ts.simpleTickers?[t.symbol!.split('_').first] = ticker;
    }
  }
  for (var t in bep8Tokens) {
    if (ts.simpleTickers![t.split('_').first] == null) {
      ts.simpleTickers![t.split('_').first] = SimplePrice.zero();
    }
  }
  return ComputeTickersResult(ts.simpleTickers ?? {});
}

Future<ComputeBalancesResult<String>> _loadBCBalances(
    ComputeBalancesArg<String, bc.HttpApiClient> args) async {
  var tokens = args.tokens;
  var tickers = args.tickers;
  var addresses = args.addresses;

  var resultBalances = <ParsedBalances<String>>[];
  var provider = args.provider;

  try {
    var result =
        await Future.wait(addresses.map((addr) => provider.getAccount(addr)));

    for (var addr in addresses.indexed()) {
      var bcAccount = result[addr.first];
      var addressBalances = <WalletBalance>[];
      var allTokens = args.additionalArgs?.cast<WalletToken>();
      var allBalancesForDex = <WalletBalance>[];

      if (bcAccount.load == null) {
        for (var t in allTokens!) {
          if (tokens.contains(t)) {
            var ticker =
                tickers[t.standard == 'BEP8' ? t.symbol : t.coingeckoId];

            var balance = WalletBalance()
              ..token = t
              ..balance = Decimal.zero
              ..fiatPrice = ticker?.inCurrency ?? Decimal.zero
              ..changePercent = ticker?.priceChange ?? Decimal.zero
              ..fiatBalance = Decimal.zero;

            addressBalances.add(balance);
            allBalancesForDex.add(balance);
          } else {
            var balance = WalletBalance.empty(t);
            addressBalances.add(balance);
            allBalancesForDex.add(balance);
          }
        }
      } else {
        for (var t in allTokens!) {
          if (tokens.contains(t)) {
            var ticker =
                tickers[t.standard == 'BEP8' ? t.symbol : t.coingeckoId];
            var respBal = Decimal.parse(bcAccount.load?.balances
                    ?.firstWhere((b) => b.symbol == t.symbol,
                        orElse: () => bc.Balance(
                            free: '0',
                            frozen: '0',
                            locked: '0',
                            symbol: t.symbol))
                    .free ??
                '0');
            var balance = WalletBalance()
              ..token = t
              ..balance = respBal
              ..fiatPrice = ticker?.inCurrency ?? Decimal.zero
              ..changePercent = ticker?.priceChange ?? Decimal.zero;
            balance.fiatBalance = balance.fiatPrice * balance.balance;
            addressBalances.add(balance);
            allBalancesForDex.add(balance);
          } else {
            var balance = WalletBalance.empty(t);
            allBalancesForDex.add(balance);
          }
        }
      }
      resultBalances.add(
          ParsedBalances<String>(addr.last as String, addressBalances)
            ..additionalLoad = allBalancesForDex);
    }
    return ComputeBalancesResult(false, resultBalances);
  } catch (e, st) {
    print('$e,$st');

    return ComputeBalancesResult(true, resultBalances);
  }
}

Future<ComputeBalancesResult<EthereumAddress>> _loadEthBalances(
    ComputeBalancesArg args) async {
  var tokens = args.tokens;
  var addresses = args.addresses as List<EthereumAddress>;
  var tickers = args.tickers;
  var resultBalances = <ParsedBalances<EthereumAddress>>[];
  var provider = args.provider;

  try {
    var result = await EthMulticallInteractor(provider)
        .getBalances(addresses, tokens.sublist(1));
    for (var addr in addresses.indexed()) {
      var addressBalances = <WalletBalance>[];
      var rawBalances = result.sublist(
          addr.first * tokens.length, (addr.first + 1) * tokens.length);
      for (var t in tokens.indexed()) {
        // ignore: non_constant_identifier_names
        var token_ = t.last as WalletToken;
        var ticker = tickers[token_.coingeckoId];
        var balance = WalletBalance()
          ..token = token_
          ..balance =
              rawBalances[t.first as int].weiToDecimalEther(token_.decimals!)
          ..fiatPrice = ticker?.inCurrency ?? Decimal.zero
          ..changePercent = ticker?.priceChange ?? Decimal.zero;

        balance.fiatBalance = balance.fiatPrice * balance.balance;
        addressBalances.add(balance);
      }
      resultBalances.add(ParsedBalances<EthereumAddress>(
          addr.last as EthereumAddress, addressBalances));
    }
    return ComputeBalancesResult(false, resultBalances);
  } catch (e) {
    print('$e');
    return ComputeBalancesResult(true, resultBalances);
  }
}

Future<ComputeBalancesResult<EthereumAddress>> _loadBSCBalances(
    ComputeBalancesArg args) async {
  var tokens = args.tokens;
  var addresses = args.addresses as List<EthereumAddress>;
  var tickers = args.tickers;
  var resultBalances = <ParsedBalances<EthereumAddress>>[];
  var provider = args.provider;
  try {
    var result = await BSCMulticallInteractor(provider)
        .getBalances(addresses, tokens.sublist(1));
    for (var addr in addresses.indexed()) {
      var addressBalances = <WalletBalance>[];
      var rawBalances = result.sublist(
          addr.first * tokens.length, (addr.first + 1) * tokens.length);
      for (var t in tokens.indexed()) {
        // ignore: non_constant_identifier_names
        var token_ = t.last as WalletToken;
        var ticker = tickers[token_.coingeckoId];
        var balance = WalletBalance()
          ..token = token_
          ..balance =
              rawBalances[t.first as int].weiToDecimalEther(token_.decimals!)
          ..fiatPrice = ticker?.inCurrency ?? Decimal.zero
          ..changePercent = ticker?.priceChange ?? Decimal.zero;

        balance.fiatBalance = balance.fiatPrice * balance.balance;
        addressBalances.add(balance);
      }
      resultBalances.add(ParsedBalances<EthereumAddress>(
          addr.last as EthereumAddress, addressBalances));
    }
    return ComputeBalancesResult(false, resultBalances);
  } catch (e) {
    print('$e');

    return ComputeBalancesResult(true, resultBalances);
  }
}

Future<ComputeBalancesResult<String>> _loadSolanaBalances(
    ComputeBalancesArg<String, sol.RPCClient> args) async {
  var tokens = args.tokens;
  var addresses = args.addresses as List<String>;
  var tickers = args.tickers;
  var resultBalances = <ParsedBalances<String>>[];
  var provider = args.provider;

  try {
    var result =
        await Future.wait(addresses.map((addr) => provider.getBalance(addr)));

    for (var addr in addresses.indexed()) {
      var addressBalances = <WalletBalance>[];
      var rawBalances = result.sublist(
          addr.first * tokens.length, (addr.first + 1) * tokens.length);
      for (var t in tokens.indexed()) {
        // ignore: non_constant_identifier_names
        var token_ = t.last as WalletToken;
        var ticker = tickers[token_.coingeckoId];
        var balance = WalletBalance()
          ..token = token_
          ..balance =
              rawBalances[t.first as int].lamportsToDecimal(token_.decimals!)
          ..fiatPrice = ticker?.inCurrency ?? Decimal.zero
          ..changePercent = ticker?.priceChange ?? Decimal.zero;
////
        balance.fiatBalance = balance.fiatPrice * balance.balance;
        addressBalances.add(balance);
      }
      resultBalances
          .add(ParsedBalances<String>(addr.last as String, addressBalances));
    }
    return ComputeBalancesResult(false, resultBalances);
  } catch (e) {
    print('$e');

    return ComputeBalancesResult(true, resultBalances);
  }
}

Future<ComputeBalancesResult<String>> _loadFoilBalances(
    ComputeBalancesArg args) async {
  var tokens = args.tokens;
  var addresses = args.addresses;
  var tickers = args.tickers;
  var resultBalances = <ParsedBalances<String>>[];
  var provider = args.provider;

  var balances;
  Future foilBalanceFromAddress(address) async {
    final url = 'http://185.63.191.197:9088/addresses/assetbalanceown/1/$address';
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      balances = responseData;
      return balances;
    } catch (error) {
      throw error;
    }
  }

  try {
    var result =
        await Future.wait(addresses.map((addr) => foilBalanceFromAddress(addr)));
    for (var addr in addresses.indexed()) {
      var addressBalances = <WalletBalance>[];
      // var rawBalances = result.sublist(
      //     addr.first * tokens.length, (addr.first + 1) * tokens.length);
      for (var t in tokens.indexed()) {
        // ignore: non_constant_identifier_names
        var token_ = t.last as WalletToken;
        var ticker = tickers[token_.coingeckoId];
        var balance = WalletBalance()
          ..token = token_
          ..balance = Decimal.fromInt(balances)
          ..fiatPrice = Decimal.zero
          ..changePercent = Decimal.one;
////
        balance.fiatBalance = Decimal.zero;
        addressBalances.add(balance);
      }
      resultBalances
          .add(ParsedBalances<String>(addr.last as String, addressBalances));
    }
    return ComputeBalancesResult(false, resultBalances);
  } catch (e) {
    print('$e');

    return ComputeBalancesResult(true, resultBalances);
  }


}
