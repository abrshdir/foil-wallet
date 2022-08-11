import 'dart:async';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voola/core/api/binance_chain/BCApi.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/core/authentication/AuthService.dart';
import 'package:voola/core/authentication/UserAccount.dart';
import 'package:voola/core/blockchain/binance_smart_chain/contracts/TokenHub_abi.dart';
import 'package:voola/core/blockchain/ethereum/contracts/ERC20_abi.dart';
import 'package:voola/core/blockchain/ethereum/contracts/TBCC_Bridge_abi.dart';
import 'package:voola/core/token/TokenContainer.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/dex/DexMainScreen.dart';
import 'package:web3dart/web3dart.dart';
import 'package:binance_chain/binance_chain.dart' as bc;
import 'package:binance_chain/src/utils/crypto.dart' as bc_crypto;

class CrossChainSwapScreen extends StatelessWidget {
  WalletBalance from_bal;
  WalletToken to;
  UserAccount account;
  String title;

  CrossChainSwapScreen(this.title,
      {required this.from_bal,
      required this.to,
      required this.account,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CrossChainSwapModel>(
      onModelReady: (model) {
        model.from_bal = from_bal;
        model.to = to;
        model.account = account;
        model.checkBalances();
      },
      builder: (context, model, child) {
        return CScaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(title),
            ),
            body: model.state == ViewState.Busy
                ? TBCCLoader()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: ChangeNotifierProvider.value(
                      value: model.accManager,
                      builder: (context, _) => Consumer<AccountManager>(
                        builder: (_, val, __) => Form(
                          key: model.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Stack(children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(height: 8),
                                    Text(S.of(context).youPay),
                                    SizedBox(height: 8),
                                    Stack(children: [
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(',',
                                              replacementString: '.')
                                        ],
                                        validator: (val) {
                                          var dAmount = Decimal.tryParse(
                                              model.controllerFrom.text);
                                          if (dAmount != null &&
                                              dAmount > Decimal.zero &&
                                              dAmount <=
                                                  model.from_bal!.balance) {
                                            return null;
                                          }
                                          return S.of(context).notEnoughTokens;
                                        },
                                        onChanged: (val) {
                                          model.dAmount = Decimal.tryParse(val);
                                          model.controllerTo.text = val;
                                          model.setState();
                                        },
                                        controller: model.controllerFrom,
                                        decoration: generalTextFieldDecor(
                                          context,
                                          hintText: '0.00',
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12, right: 12),
                                            child: Row(
                                              children: [
                                                model.from_bal!.token.icon(32),
                                                SizedBox(width: 8),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        '${model.from_bal!.token.symbol}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1),
                                                    Text(
                                                        '${model.from_bal!.token.standard}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2!
                                                            .copyWith(
                                                                fontSize: 12)),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ),
                                    ]),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, bottom: 16, top: 8),
                                      child: Row(
                                        children: [
                                          Text('${S.of(context).yourBalance}: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2),
                                          Text(
                                            '${model.from_bal!.balance} ${model.from_bal!.token.symbol}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    color: AppColors.active),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(height: 6),
                                    SizedBox(height: 6),
                                    Text(S.of(context).youReceive),
                                    SizedBox(height: 8),
                                    Stack(
                                      children: [
                                        TextFormField(
                                          controller: model.controllerTo,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(
                                                ',',
                                                replacementString: '.')
                                          ],
                                          decoration: generalTextFieldDecor(
                                            context,
                                            hintText: '0.00',
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12, right: 12),
                                            child: Row(
                                              children: [
                                                model.to_bal!.token.icon(32),
                                                SizedBox(width: 8),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        '${model.to_bal!.token.symbol}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1),
                                                    Text(
                                                        '${model.to_bal!.token.standard}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2!
                                                            .copyWith(
                                                                fontSize: 12)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, bottom: 16, top: 8),
                                      child: Row(
                                        children: [
                                          Text('${S.of(context).yourBalance}: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2),
                                          Text(
                                            '${model.to_bal!.balance} ${model.to_bal!.token.symbol}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    color: AppColors.active),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 40,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryBg,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppColors.inactiveText)),
                                    child: Icon(
                                      Icons.arrow_downward,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ]),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, bottom: 32),
                                child: Row(
                                  children: [
                                    for (var percent in [
                                      '25',
                                      '50',
                                      '75',
                                      '100'
                                    ])
                                      Expanded(
                                          child: GestureDetector(
                                              onTap: () {
                                                model.percentage(Decimal.parse(
                                                    percent.startsWith('1')
                                                        ? '1'
                                                        : '0.$percent'));
                                              },
                                              behavior: HitTestBehavior.opaque,
                                              child:
                                                  DexPercentBtn('$percent%'))),
                                  ].separate<Widget>(SizedBox(width: 8)),
                                ),
                              ),

                              if (model.waitingApproveTxHash != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    decoration: BoxDecoration(
                                      color: AppColors.inactiveText,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${S.of(context).confirm} ${model.from_bal!.token.symbol}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(width: 10),
                                            CircularProgressIndicator(
                                                strokeWidth: 2)
                                          ],
                                        ),
                                        Text(S.of(context).waitingConfirmation)
                                      ],
                                    ),
                                  ),
                                )
                              else if (model.tbccwaitingApproveTxHash != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    decoration: BoxDecoration(
                                      color: AppColors.inactiveText,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${S.of(context).confirm} ${model.from_bal!.token.symbol}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(width: 10),
                                            CircularProgressIndicator(
                                                strokeWidth: 2)
                                          ],
                                        ),
                                        Text(S.of(context).waitingConfirmation)
                                      ],
                                    ),
                                  ),
                                )
                              else if (model.from_bal!.token.standard ==
                                      'BEP20' &&
                                  !model.isAllowanceEnough)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Button(
                                      value:
                                          '${S.of(context).confirm} ${model.from_bal!.token.symbol}',
                                      onTap: () {
                                        model.approveToken(context);
                                      }),
                                )
                              else if (model.from_bal!.token.standard ==
                                      'ERC20' &&
                                  !model.isERC20AllowanceEnough)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Button(
                                      value:
                                          '${S.of(context).confirm} ${model.from_bal!.token.symbol}',
                                      onTap: () {
                                        model.approveERC20TBCC(context);
                                      }),
                                ),
                              //Padding(
                              //  padding: const EdgeInsets.only(top: 10, bottom: 20),
                              //  child: Row(
                              //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //    children: [
                              //      Text('${S.of(context).networkFee}:'),
                              //      () {
                              //        if (to.standard == 'BEP20' || (to.standard == 'Native' && to.symbol == 'BNB'))
                              //          return Text('${model.toBscFee} BNB (\$${(model.bc_bnb_bal.fiatPrice * model.toBscFee).toStringWithFractionDigits(2)})');
                              //        else if (to.standard == 'ERC20')
                              //          return Text('1bnb');
                              //        else if (to.standard == 'BEP2') return Text('1bnb');
                              //      }()
                              //    ],
                              //  ),
                              //),
                              if (model.waitingApproveTxHash != null)
                                Button(
                                    value: S.of(context).next,
                                    color: AppColors.inactiveText,
                                    onTap: () {})
                              else if (model.tbccwaitingApproveTxHash != null)
                                Button(
                                    value: S.of(context).next,
                                    color: AppColors.inactiveText,
                                    onTap: () {})
                              else
                                Button(
                                    value: S.of(context).next,
                                    onTap: () {
                                      if (model.formKey.currentState!
                                          .validate())
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    SwapConfirmScreen(model)));
                                    })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
      },
    );
  }
}

class CrossChainSwapModel extends BaseViewModel {
  late UserAccount account;
  final controllerFrom = TextEditingController();
  final controllerTo = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var tokenContainer = locator<WALLET_TOKENS_CONTAINER>();
  AccountManager accManager = locator<AuthService>().accManager;
  WalletBalance? from_bal;

  WalletToken? to;
  WalletBalance? to_bal;

  WalletBalance? bc_bnb_bal;
  WalletBalance? bsc_bnb_bal;
  WalletBalance? eth_bal;

  Decimal? dAmount;

  Decimal? fee;

  int? maxGas;

  Transaction? bscTransaction;
  Transaction? ethTransaction;
  late DeployedContract erc20_bep20BridgeContract;
  late DeployedContract tbccerc20TokenContract;
  late DeployedContract bep20TokenContract;
  BigInt? tbccerc20TokenAllowance;
  BigInt? bep20TokenAllowance;
  bool get isAllowanceEnough {
    return BigInt.parse(
            '${((dAmount ?? Decimal.zero) * Decimal.fromInt(10).pow(from_bal!.token.decimals!)).ceil()}') <=
        bep20TokenAllowance!;
  }

  bool get isERC20AllowanceEnough {
    return BigInt.parse(
            '${((dAmount ?? Decimal.zero) * Decimal.fromInt(10).pow(from_bal!.token.decimals!)).ceil()}') <=
        tbccerc20TokenAllowance!;
  }

  Future<void> checkBalances() async {
    setState(ViewState.Busy);
    var bnb = tokenContainer.BEP2
        .firstWhereMaybe((element) => element.symbol == 'BNB');
    var bsc_bnb = tokenContainer.COINS
        .firstWhereMaybe((element) => element.symbol == 'BNB');
    var eth = tokenContainer.COINS
        .firstWhereMaybe((element) => element.symbol == 'ETH');

    if (to!.standard == 'Native' && to!.symbol == 'BNB') {
      to_bal = account.coinBalances.firstWhereMaybe(
          (element) => element.token == to,
          orElse: () => null);
    } else if (to!.standard == 'BEP20') {
      to_bal = account.bep20Balances.firstWhereMaybe(
          (element) => element.token == to,
          orElse: () => null);
    } else if (to!.standard == 'ERC20' && to!.symbol == 'TBCC') {
      to_bal = account.erc20Balances.firstWhereMaybe(
          (element) => element.token == to,
          orElse: () => null);
    } else if (to!.standard == 'BEP2') {
      to_bal = account.bc_bep2_Balances.firstWhereMaybe(
          (element) => element.token == to,
          orElse: () => null);
    } else {
      throw ArgumentError();
    }

    bc_bnb_bal = account.bc_bep2_Balances
        .firstWhereMaybe((element) => element.token == bnb, orElse: () => null);
    bsc_bnb_bal = account.coinBalances.firstWhereMaybe(
        (element) => element.token == bsc_bnb,
        orElse: () => null);
    eth_bal = account.coinBalances
        .firstWhereMaybe((element) => element.token == eth, orElse: () => null);

    var getBalFutures = <Future>[];
    if (to_bal == null)
      getBalFutures.add(() async {
        to_bal = await accManager.loadSingleTokenBalance(to!, account);
      }());
    if (bc_bnb_bal == null)
      getBalFutures.add(() async {
        bc_bnb_bal = await accManager.loadSingleTokenBalance(bnb!, account);
      }());
    if (bsc_bnb_bal == null)
      getBalFutures.add(() async {
        bsc_bnb_bal =
            await accManager.loadSingleTokenBalance(bsc_bnb!, account);
      }());
    if (eth_bal == null)
      getBalFutures.add(() async {
        eth_bal = await accManager.loadSingleTokenBalance(eth!, account);
      }());

    if (from_bal!.token.standard == 'BEP20') {
      bep20TokenContract =
          DeployedContract(erc20BasicContractAbi, from_bal!.token.ethAddress!);
      getBalFutures.add(() async {
        bep20TokenAllowance = (await ENVS.BSC_ENV!.call(
                contract: bep20TokenContract,
                function: bep20TokenContract.function('allowance'),
                params: [
              account.bscWallet.address,
              EthereumAddress.fromHex(
                  '0x0000000000000000000000000000000000001004')
            ]))
            .first;
      }());
    }
    if (from_bal!.token.standard == 'ERC20' &&
        from_bal!.token.symbol == 'TBCC') {
      erc20_bep20BridgeContract = DeployedContract(
          BRIDGE_ABI,
          EthereumAddress.fromHex(
              '0xe1b290C961c58dADb8Dc5b395551AA108398deDD'));
      tbccerc20TokenContract = DeployedContract(
          erc20BasicContractAbi,
          EthereumAddress.fromHex(
              '0x2ecb95eb932dfbbb71545f4d23ca303700ac855f'));
      getBalFutures.add(() async {
        tbccerc20TokenAllowance = (await ENVS.ETH_ENV!.call(
                contract: tbccerc20TokenContract,
                function: tbccerc20TokenContract.function('allowance'),
                params: [
              account.ethWallet.address,
              EthereumAddress.fromHex(
                  '0xe1b290C961c58dADb8Dc5b395551AA108398deDD')
            ]))
            .first;
      }());
    }
    if (getBalFutures.isNotEmpty) {
      await Future.wait(getBalFutures);
    }
    setState(ViewState.Idle);
  }

  Future<void> init() async {
    setState(ViewState.Busy);
    if (from_bal!.token.standard == 'BEP2') {
      fee = Decimal.parse('0.004075');
    } else if (from_bal!.token.standard == 'ERC20' &&
        from_bal!.token.symbol == 'TBCC') {
      var bridgeAddr =
          EthereumAddress.fromHex('0xe1b290C961c58dADb8Dc5b395551AA108398deDD');
      var bridgeContract = DeployedContract(BRIDGE_ABI, bridgeAddr);
      var getRelayFeeFunc = bridgeContract.function('relayFee');
      var transferOutFunc = bridgeContract.function('transferOut');

      var relayFee = EtherAmount.inWei((await ENVS.ETH_ENV!.call(
                  contract: bridgeContract,
                  function: getRelayFeeFunc,
                  params: []))
              .first +
          BigInt.from(10000000000));
      var swapAmount = EtherAmount.inWei(BigInt.parse(
          (Decimal.parse(dAmount!.toStringWithFractionDigits(18)) *
                  Decimal.fromInt(10).pow(18))
              .ceil()
              .toString()));
      EtherAmount txValue = relayFee;

      ethTransaction = Transaction.callContract(
        contract: bridgeContract,
        function: transferOutFunc,
        parameters: [
          swapAmount.getInWei,
        ],
        value: txValue,
        from: account.bscWallet.address,
      );

      maxGas = (await ENVS.ETH_ENV!.estimateGas(
              sender: ethTransaction!.from,
              to: bridgeAddr,
              value: txValue,
              data: ethTransaction!.data))
          .toInt();
      var gasPrice = (await ENVS.ETH_ENV!.getGasPrice()).weiToDecimalEther(18);
      fee =
          gasPrice * Decimal.fromInt(maxGas!) + relayFee.weiToDecimalEther(18);
    } else {
      var tokenHubAddr =
          EthereumAddress.fromHex('0x0000000000000000000000000000000000001004');
      var tokenHubContract = DeployedContract(bscTokenHubAbi, tokenHubAddr);
      var getRelayFeeFunc = tokenHubContract.function('relayFee');
      var transferOutFunc = tokenHubContract.function('transferOut');

      var relayFee = EtherAmount.inWei((await ENVS.BSC_ENV!.call(
              contract: tokenHubContract,
              function: getRelayFeeFunc,
              params: []))
          .first);
      var swapAmount = EtherAmount.inWei(BigInt.parse(
          (Decimal.parse(dAmount!.toStringWithFractionDigits(8)) *
                  Decimal.fromInt(10).pow(18))
              .ceil()
              .toString()));
      EtherAmount txValue;
      if (from_bal!.token == bsc_bnb_bal!.token) {
        txValue = EtherAmount.inWei(swapAmount.getInWei + relayFee.getInWei);
      } else {
        txValue = relayFee;
      }
      bscTransaction = Transaction.callContract(
        contract: tokenHubContract,
        function: transferOutFunc,
        parameters: [
          to!.ethAddress,
          EthereumAddress(bc_crypto.decode_address(account.bcWallet.address!)!),
          swapAmount.getInWei,
          BigInt.from(
              DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 + 600),
        ],
        value: txValue,
        from: account.bscWallet.address,
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 5),
      );
      try {
        maxGas = (await ENVS.BSC_ENV!.estimateGas(
                sender: bscTransaction!.from,
                to: tokenHubAddr,
                value: txValue,
                data: bscTransaction!.data,
                gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 5)))
            .toInt();
      } catch (e) {
        maxGas = 100000;
      }
      fee = Decimal.fromInt(5).gweiToEther() * Decimal.fromInt(maxGas!) +
          relayFee.weiToDecimalEther(18);
    }
    setState(ViewState.Idle);
  }

  void percentage(Decimal percent) {
    var am = from_bal!.balance * percent;
    controllerFrom.text = am.toStringWithFractionDigits(
        from_bal!.token.decimals ?? 8,
        shrinkZeros: true);
    dAmount = am;
    setState();

    controllerTo.text = am.toStringWithFractionDigits(
        from_bal!.token.decimals ?? 18,
        shrinkZeros: true);
  }

  Future<void> sendSwap(context) async {
    setState(ViewState.Busy);

    // bnb(bc) or any linked bep2 (excluding tbc) to bsc
    if (to!.standard == 'Native' && to!.symbol == 'BNB' ||
        to!.standard == 'BEP20' && to!.symbol != 'TBCC') {
      var t = bc.TransferOutMsg(
        addressFrom: account.bcWallet.address,
        addressTo: bc.BSCAddress.fromHex(account.bscWallet.address.hex),
        symbol: from_bal!.token.symbol,
        amount: dAmount,
        expireTime: DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 + 600,
        wallet: account.bcWallet,
      );

      var resp = await locator<BinanceChainApi>().broadcastMsg(t, sync: true);
      if (resp.ok) {
        Navigator.of(context)
          ..pop()
          ..pop();
        Flushbar.success(title: S.of(context).swapStandardSent)
            .show(Duration(seconds: 5));
        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => TransferSuccessScreen(resp.load.first.hash)));
        //Flushbar.success(title:S.of(context).success).show();
      } else {
        Flushbar.error(title: '${S.of(context).error} ${resp.errorMessage}')
            .show();
      }
    }

    //from bsc to bc: bep20 top bep2 or bnb(bsc) to bc
    else if ((from_bal!.token.standard == 'BEP20' ||
            (from_bal!.token.standard == 'Native' &&
                from_bal!.token.symbol == 'BNB')) &&
        to!.standard == 'BEP2') {
      bscTransaction =
          bscTransaction!.copyWith(maxGas: (maxGas! * 1.5).toInt());
      var resp = await ENVS.BSC_ENV!.sendTransaction(
          account.bscWallet.privateKey, bscTransaction!,
          chainId: 56);
      if (resp.startsWith('0x')) {
        Navigator.of(context)
          ..pop()
          ..pop();
        Flushbar.success(title: S.of(context).swapStandardSent).show();
      } else {
        Flushbar.error(title: S.of(context).error).show();
      }
    } else if (from_bal!.token.standard == 'ERC20' &&
        from_bal!.token.symbol == 'TBCC' &&
        to_bal!.token.standard == 'BEP20') {
      ethTransaction =
          ethTransaction!.copyWith(maxGas: (maxGas! * 1.5).toInt());
      var resp = await ENVS.ETH_ENV!
          .sendTransaction(account.bscWallet.privateKey, ethTransaction!);
      if (resp.startsWith('0x')) {
        Navigator.of(context)
          ..pop()
          ..pop();
        Flushbar.success(title: S.of(context).swapStandardSent).show();

        //Flushbar.success(title:S.of(context).success).show();
      } else {
        Flushbar.error(title: S.of(context).error).show();
      }
    }

    setState(ViewState.Idle);
  }

  Future<void> approveToken(BuildContext context) async {
    approveTransaction = Transaction.callContract(
      contract: bep20TokenContract,
      function: bep20TokenContract.function('approve'),
      parameters: [
        EthereumAddress.fromHex('0x0000000000000000000000000000000000001004'),
        BigInt.parse(
            '115792089237316195423570985008687907853269984665640564039457584007913129639935'),
      ],
      value: EtherAmount.zero(),
      from: account.bscWallet.address,
      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 5),
    );

    Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => ConfirmApprove(this)));
  }

  Future<void> approveERC20TBCC(BuildContext context) async {
    tbccapproveTransaction = Transaction.callContract(
      contract: tbccerc20TokenContract,
      function: tbccerc20TokenContract.function('approve'),
      parameters: [
        EthereumAddress.fromHex('0xe1b290C961c58dADb8Dc5b395551AA108398deDD'),
        BigInt.parse(
            '115792089237316195423570985008687907853269984665640564039457584007913129639935'),
      ],
      value: EtherAmount.zero(),
      from: account.ethWallet.address,
    );

    Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => ConfirmTBCCApprove(this)));
  }

  Future<void> initApprove() async {
    setState(ViewState.Busy);
    approveMaxGas = ((await ENVS.BSC_ENV!.estimateGas(
              sender: approveTransaction!.from,
              to: bep20TokenContract.address,
              value: approveTransaction?.value,
              data: approveTransaction?.data,
              gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 5),
            ))
                .toInt() *
            1.5)
        .toInt();
    setState(ViewState.Idle);
  }

  Future<void> inittbccApprove() async {
    setState(ViewState.Busy);
    tbccapproveMaxGas = ((await ENVS.ETH_ENV!.estimateGas(
              sender: tbccapproveTransaction!.from,
              to: tbccerc20TokenContract.address,
              value: tbccapproveTransaction!.value,
              data: tbccapproveTransaction!.data,
            ))
                .toInt() *
            1.5)
        .toInt();
    setState(ViewState.Idle);
  }

  Future<void> sendApproveTx(BuildContext context) async {
    setState(ViewState.Busy);
    var resp = await ENVS.BSC_ENV!.sendTransaction(
        account.bscWallet.privateKey, approveTransaction!,
        chainId: 56);
    if (resp.startsWith('0x')) {
      waitingApproveTxHash = resp;

      Navigator.of(context).pop();
      waitingApproveTxTimer =
          Timer.periodic(Duration(seconds: 3), (timer) async {
        if (waitingApproveTxHash != null) {
          var txReceipt =
              await ENVS.BSC_ENV!.getTransactionReceipt(waitingApproveTxHash!);
          if (txReceipt?.status == true) {
            timer.cancel();
            waitingApproveTxHash = null;
            bep20TokenAllowance = (await ENVS.BSC_ENV!.call(
                    contract: bep20TokenContract,
                    function: bep20TokenContract.function('allowance'),
                    params: [
                  account.bscWallet.address,
                  EthereumAddress.fromHex(
                      '0x0000000000000000000000000000000000001004')
                ]))
                .first;
            setState();
          }
        } else {
          timer.cancel();
        }
      });
      Flushbar.success(title: S.of(context).success).show();
    } else {
      Navigator.of(context).pop();
      Flushbar.error(title: S.of(context).success).show();
    }
    setState(ViewState.Idle);
  }

  Future<void> sendtbccApproveTx(BuildContext context) async {
    setState(ViewState.Busy);
    var resp = await ENVS.ETH_ENV!
        .sendTransaction(account.ethWallet.privateKey, tbccapproveTransaction!);
    if (resp.startsWith('0x')) {
      tbccwaitingApproveTxHash = resp;

      Navigator.of(context).pop();
      tbccwaitingApproveTxTimer =
          Timer.periodic(Duration(seconds: 3), (timer) async {
        if (tbccwaitingApproveTxHash != null) {
          var txReceipt = await ENVS.ETH_ENV!
              .getTransactionReceipt(tbccwaitingApproveTxHash!);
          if (txReceipt?.status == true) {
            timer.cancel();
            tbccwaitingApproveTxHash = null;
            tbccerc20TokenAllowance = (await ENVS.ETH_ENV!.call(
                    contract: tbccerc20TokenContract,
                    function: tbccerc20TokenContract.function('allowance'),
                    params: [
                  account.ethWallet.address,
                  EthereumAddress.fromHex(
                      '0xe1b290C961c58dADb8Dc5b395551AA108398deDD')
                ]))
                .first;
            setState();
          }
        } else {
          timer.cancel();
        }
      });
      Flushbar.success(title: S.of(context).success).show();
    } else {
      Navigator.of(context).pop();
      Flushbar.error(title: S.of(context).success).show();
    }
    setState(ViewState.Idle);
  }

  Transaction? approveTransaction;
  Transaction? tbccapproveTransaction;
  int? approveMaxGas;
  int? tbccapproveMaxGas;

  String? waitingApproveTxHash;
  String? tbccwaitingApproveTxHash;
  Timer? waitingApproveTxTimer;
  Timer? tbccwaitingApproveTxTimer;
}

class SwapConfirmScreen extends StatelessWidget {
  CrossChainSwapModel model;
  SwapConfirmScreen(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CrossChainSwapModel>(
      onModelReady: (model) async {
        await model.init();
        //model.calcFee();
      },
      model: model,
      builder: (context, model, child) {
        return CScaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(S.of(context).confirm),
          ),
          body: model.state == ViewState.Busy
              ? TBCCLoader()
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(model.controllerFrom.text,
                                  style: Theme.of(context).textTheme.bodyText1),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(model.from_bal!.token.symbol,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  Text(model.from_bal!.token.standard),
                                ],
                              ),
                              SizedBox(width: 10),
                              model.from_bal!.token.icon(34),
                            ],
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, right: 20, bottom: 20),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryBg,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.inactiveText)),
                                  child: Icon(
                                    Icons.arrow_downward,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(model.controllerTo.text,
                                  style: Theme.of(context).textTheme.bodyText1),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(model.to_bal!.token.symbol,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  Text(model.to_bal!.token.standard),
                                ],
                              ),
                              SizedBox(width: 10),
                              model.from_bal!.token.icon(34),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              //InfoListTile(S.of(context).from, locator<AuthService>().accountManager.currentAccount.addressFormNetwork(balance.token.network)),
                              Divider(),
                              //InfoListTile(S.of(context).to, model.controllerAddress.text),
                              //Divider(),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(S.of(context).networkFee,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                                color: AppColors.inactiveText)),
                                    model.from_bal!.token.standard == 'ERC20'
                                        ? Row(children: [
                                            Text(
                                              '${model.fee!.toStringWithFractionDigits(18, shrinkZeros: true)} ETH ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                      color: AppColors.text,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                            Text(
                                              ' (\$${(model.eth_bal!.fiatPrice * model.fee!).toStringWithFractionDigits(3, shrinkZeros: true)})',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                      color: AppColors
                                                          .inactiveText,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ])
                                        : Row(children: [
                                            Text(
                                              '${model.fee!.toStringWithFractionDigits(18, shrinkZeros: true)} BNB ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                      color: AppColors.text,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                            Text(
                                              ' (\$${(model.bsc_bnb_bal!.fiatPrice * model.fee!).toStringWithFractionDigits(3, shrinkZeros: true)})',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                      color: AppColors
                                                          .inactiveText,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ])
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ...() {
                        if (model.from_bal!.token == model.bsc_bnb_bal!.token) {
                          if (model.bsc_bnb_bal!.balance >=
                              model.fee! + model.dAmount!)
                            return [
                              Button(
                                value: S.of(context).confirmSwap,
                                onTap: () {
                                  model.sendSwap(context);
                                },
                              )
                            ];
                          else
                            return [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  S.of(context).notEnoughTokensFee('BNB'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: AppColors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Button(
                                color: AppColors.inactiveText,
                                value: S.of(context).confirmSwap,
                                onTap: null,
                              )
                            ];
                        } else if (model.from_bal!.token.standard == 'BEP20') {
                          if (model.bsc_bnb_bal!.balance >= model.fee!)
                            return [
                              Button(
                                value: S.of(context).confirmSwap,
                                onTap: () {
                                  model.sendSwap(context);
                                },
                              )
                            ];
                          else
                            return [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  S.of(context).notEnoughTokensFee('BNB'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: AppColors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Button(
                                color: AppColors.inactiveText,
                                value: S.of(context).confirmSwap,
                                onTap: null,
                              )
                            ];
                        } else if (model.from_bal!.token.standard == 'BEP2') {
                          if (model.from_bal!.token ==
                              model.bc_bnb_bal!.token) {
                            if (model.bc_bnb_bal!.balance >=
                                model.fee! + model.dAmount!)
                              return [
                                Button(
                                  value: S.of(context).confirmSwap,
                                  onTap: () {
                                    model.sendSwap(context);
                                  },
                                )
                              ];
                            else
                              return [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    S.of(context).notEnoughTokensFee('BNB'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: AppColors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Button(
                                  color: AppColors.inactiveText,
                                  value: S.of(context).confirmSwap,
                                  onTap: null,
                                )
                              ];
                          } else {
                            if (model.bc_bnb_bal!.balance >= model.fee!)
                              return [
                                Button(
                                  value: S.of(context).confirmSwap,
                                  onTap: () {
                                    model.sendSwap(context);
                                  },
                                )
                              ];
                            else
                              return [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    S.of(context).notEnoughTokensFee('BNB'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: AppColors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Button(
                                  color: AppColors.inactiveText,
                                  value: S.of(context).confirmSwap,
                                  onTap: null,
                                )
                              ];
                          }
                        } else {
                          if (model.eth_bal!.balance >= model.fee!)
                            return [
                              Button(
                                value: S.of(context).confirmSwap,
                                onTap: () {
                                  model.sendSwap(context);
                                },
                              )
                            ];
                          else
                            return [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  S.of(context).notEnoughTokensFee('ETH'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: AppColors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Button(
                                color: AppColors.inactiveText,
                                value: S.of(context).confirmSwap,
                                onTap: null,
                              )
                            ];
                        }
                      }()
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class ConfirmApprove extends StatelessWidget {
  CrossChainSwapModel model;
  ConfirmApprove(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CrossChainSwapModel>(
      onModelReady: (model) {
        model.initApprove();
      },
      model: model,
      builder: (context, model, child) {
        Decimal fee;
        try {
          fee = Decimal.fromInt(model.approveMaxGas!) *
              EtherAmount.fromUnitAndValue(EtherUnit.gwei, 5)
                  .weiToDecimalEther(18);
        } catch (e) {
          fee = Decimal.zero;
        }
        return CScaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('Confirm Transaction'),
          ),
          body: model.state == ViewState.Busy
              ? TBCCLoader()
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Approve ${model.from_bal!.token.symbol}',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: AppColors.text),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(S.of(context).networkFee),
                          Spacer(),
                          Text(
                              '$fee BNB (\$${(fee * model.bsc_bnb_bal!.fiatPrice).toStringWithFractionDigits(2)})'),
                        ],
                      ),
                      SizedBox(height: 40),
                      Button(
                          value: S.of(context).confirm,
                          onTap: () {
                            model.sendApproveTx(context);
                          })
                    ],
                  )),
        );
      },
    );
  }
}

class ConfirmTBCCApprove extends StatelessWidget {
  CrossChainSwapModel model;
  ConfirmTBCCApprove(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CrossChainSwapModel>(
      onModelReady: (model) {
        model.inittbccApprove();
      },
      model: model,
      builder: (context, model, child) {
        Decimal fee;
        try {
          fee = Decimal.fromInt(model.tbccapproveMaxGas!) *
              EtherAmount.fromUnitAndValue(EtherUnit.gwei, 5)
                  .weiToDecimalEther(18);
        } catch (e) {
          fee = Decimal.zero;
        }
        return CScaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('Confirm Transaction'),
          ),
          body: model.state == ViewState.Busy
              ? TBCCLoader()
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Approve ${model.from_bal!.token.symbol}',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: AppColors.text),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(S.of(context).networkFee),
                          Spacer(),
                          Text(
                              '$fee ETH (\$${(fee * model.eth_bal!.fiatPrice).toStringWithFractionDigits(2)})'),
                        ],
                      ),
                      SizedBox(height: 40),
                      Button(
                          value: S.of(context).confirm,
                          onTap: () {
                            model.sendtbccApproveTx(context);
                          })
                    ],
                  )),
        );
      },
    );
  }
}
