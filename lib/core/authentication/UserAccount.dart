import 'dart:typed_data';

import 'package:solana/solana.dart' as sol;
import 'package:decimal/decimal.dart';
import 'package:voola/core/api/tbcc/models/TBCCUser.dart';
import 'package:voola/core/balance/WalletBalance.dart';

import 'package:voola/core/token/utils.dart';

import 'wallets/BSCWallet.dart';
import 'wallets/BinanceChainWallet.dart';
import 'wallets/EthereumWallet.dart';

class UserAccount {
  // late Uint8List seed;
  late BCWallet bcWallet;
  late EthWallet ethWallet;
  late BSCWallet bscWallet;
  late sol.Wallet solWallet;
  late TBCCUserModel tbccUser;
  bool? cardAttached;
  String? privHalf;
  late String accountAlias;
  late String mnemonic;
  Uint8List? seed;
  late bool unlockedWithCard = false;
  late Decimal totalBalance = Decimal.zero;
  late Decimal totalPNL = Decimal.zero;
  late Decimal totalPNLPercent = Decimal.zero;
  late List<WalletBalance> erc20Balances;
  late List<WalletBalance> bep20Balances;
  late List<WalletBalance> bc_bep2_Balances;
  late List<WalletBalance> bc_bep8_Balances;
  late List<WalletBalance> bc_Balances_all;
  late List<WalletBalance> coinBalances;
  //late List<WalletBalance> nftBalances;
  late List<WalletBalance> allBalances;
  UserAccount();
  String addressFormNetwork(TokenNetwork network) {
    if (network == TokenNetwork.Ethereum)
      return ethWallet.address.hex;
    else if (network == TokenNetwork.BinanceChain)
      return bcWallet.address!;
    else if (network == TokenNetwork.BinanceSmartChain)
      return bscWallet.address.hex;
    else if (network == TokenNetwork.Solana)
      return solWallet.address;
    else
      return '';
  }

  void calcTotalBalance() {
    totalBalance = allBalances.fold<Decimal>(Decimal.zero,
        (previousValue, element) => previousValue + element.fiatBalance);
  }

  void calcTotalPNL() {
    totalPNL = allBalances.fold(Decimal.zero, (previousValue, element) {
      if (element.fiatBalance != Decimal.zero) {
        return previousValue +
            element.fiatBalance *
                (Decimal.one + element.changePercent / Decimal.fromInt(100));
      } else
        return previousValue;
    });
    totalPNL = totalPNL - totalBalance;
    totalPNLPercent = totalPNL == Decimal.zero
        ? Decimal.zero
        : (totalBalance + totalPNL) / totalPNL / Decimal.fromInt(100);
  }

  void sortBalances() {
    var balComparator = (WalletBalance bal1, WalletBalance bal2) =>
        -bal1.fiatBalance.compareTo(bal2.fiatBalance);

    allBalances.sort(balComparator);
    coinBalances.sort(balComparator);
    erc20Balances.sort(balComparator);
    bep20Balances.sort(balComparator);
    bc_bep2_Balances.sort(balComparator);
    bc_bep8_Balances.sort(balComparator);
  }

  //WalletBalance? getBep2Balance(String symbol) {
  //  return bc_bep2_Balances.firstWhere((element) => element.token.symbol == symbol, orElse: () => WalletBalance());
  //}
//
  //WalletBalance? getBep8Balance(String symbol) {
  //  return bc_bep8_Balances.firstWhere((element) => element.token.symbol == symbol, orElse: () => null);
  //}
//
  //WalletBalance getERC20Balance(String symbol) {
  //  return erc20Balances.firstWhere((element) => element.token.symbol == symbol, orElse: () => null);
  //}
//
  //WalletBalance getBEP20Balance(String symbol) {
  //  return bep20Balances.firstWhere((element) => element.token.symbol == symbol, orElse: () => null);
  //}
//
  //WalletBalance getCoinBalance(String symbol) {
  //  return coinBalances.firstWhere((element) => element.token.symbol == symbol, orElse: () => null);
  //}
//
  //WalletBalance getBalance(String symbol, [TokenNetwork network = TokenNetwork.BinanceChain]) {
  //  return allBalances.firstWhere((element) => element.token.symbol == symbol && element.token.network == network, orElse: () => null);
  //}
//
  //WalletBalance getNFTBalance(String symbol) {
  //  return nftBalances.firstWhere((element) => element.token.symbol == symbol, orElse: () => null);
  //}

  UserAccount.fromJson(Map<String, dynamic> json) {
    mnemonic = json['mnemonic'];
    if (json['seed'] != null)
      seed = Uint8List.fromList((json['seed'] as List<dynamic>).cast<int>());

    ethWallet = EthWallet.fromJson(json['eth_wallet']);
    bcWallet = BCWallet.fromJson(json['bc_wallet']);
    try {
      bscWallet = BSCWallet.fromJson(json['bsc_wallet']);
    } catch (e) {
      bscWallet = BSCWallet(
          address: ethWallet.address, privateKey: ethWallet.privateKey);
    }

    cardAttached = json['cardAttached'] == '1';
    privHalf = json['privHalf'];
    accountAlias = json['accountAlias'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{
      'cardAttached': cardAttached == true ? '1' : '0',
      'privHalf': privHalf == null ? '' : privHalf,
      'accountAlias': accountAlias,
      'mnemonic': mnemonic,
      'seed': seed?.toList(),
    };
    data['bc_wallet'] = bcWallet.toJson();
    data['eth_wallet'] = ethWallet.toJson();
    data['bsc_wallet'] = bscWallet.toJson();

    return data;
  }
}
