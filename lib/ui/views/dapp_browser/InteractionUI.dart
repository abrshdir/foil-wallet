import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:voola/core/api/coingecko/model/SimplePrice.dart';
import 'package:voola/core/api/network_fees/NetworkFeesApi.dart';
import 'package:voola/core/authentication/AccountManager.dart';
import 'package:voola/core/blockchain/ethereum/contracts/ERC20_abi.dart';
import 'package:voola/core/tickers/TickersService.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';
import 'package:voola/ui/views/dapp_browser/DAppScreen.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

var chainID_symbol = {
  1: 'ETH',
  56: 'BNB',
};

class TxFee {
  late Decimal gwei;
  late Decimal inCoin;
  late Decimal inFiat;
  TxFee(SimplePrice? coinTicker, this.gwei, int maxGas) {
    inCoin = gwei.gweiToEther() * Decimal.fromInt(maxGas);
    inFiat = inCoin * (coinTicker?.inCurrency ?? Decimal.zero);
  }
}

class DAppTransactionViewModel extends BaseViewModel {
  bool? approve;
  late int chainId;
  late String approveTokenName;
  late Transaction tx;
  late List<TxFee> fees;
  late TxFee selectedFee;
  feeSelected(TxFee fee) {
    selectedFee = fee;
    setState();
  }

  Future<void> loadGasPrice() async {
    setState(ViewState.Busy);
    var ticker =
        locator<TickersService>().simpleTickers?[chainID_symbol[chainId]];
    if (chainId == 1) {
      var resp = await locator<NetworkFeesApi>().getEthGasPrices();
      var load = resp.load;
      this.fees = [
        TxFee(ticker, load.average!, tx.maxGas!),
        TxFee(ticker, load.fast!, tx.maxGas!),
        TxFee(ticker, load.fastest!, tx.maxGas!)
      ];
    } else if (chainId == 56) {
      //var resp = await locator<NetworkFeesApi>().getBSCGasPrices();

      //if (resp.statusCode == 200) {
      //  var load = resp.load;
      //  if (load.standard == Decimal.fromInt(5)) {
      //    fees = [TxFee(ticker, Decimal.fromInt(5), tx.maxGas!), TxFee(ticker, Decimal.fromInt(6), tx.maxGas!), TxFee(ticker, Decimal.fromInt(7), tx.maxGas!)];
      //  } else {
      //    this.fees = [TxFee(ticker, load.slow!, tx.maxGas!), TxFee(ticker, load.standard!, tx.maxGas!), TxFee(ticker, load.fast!, tx.maxGas!)];
      //  }
      //} else {
      fees = [
        TxFee(ticker, Decimal.fromInt(5), tx.maxGas!),
        TxFee(ticker, Decimal.fromInt(6), tx.maxGas!),
        TxFee(ticker, Decimal.fromInt(6), tx.maxGas!)
      ];
      //}
    }
    selectedFee = fees[1];

    if (approve == true) {
      try {
        var c = DeployedContract(erc20BasicContractAbi, tx.to!);
        this.approveTokenName = (await ENVS.chainId_Provider![chainId]!
                .call(contract: c, function: c.function('symbol'), params: []))
            .first as String;
      } catch (e) {
        print(e);
      }
    }
    setState(ViewState.Idle);
  }

  void parseTx(Map<String, dynamic> txJson) {
    tx = Transaction(
      value: txJson['value'] != null
          ? EtherAmount.inWei(BigInt.parse(strip0x(txJson['value']), radix: 16))
          : null,
      from: txJson['from'] != null
          ? EthereumAddress.fromHex(txJson['from'])
          : null,
      to: txJson['to'] != null ? EthereumAddress.fromHex(txJson['to']) : null,
      maxGas: txJson['gas'] != null ? hexToDartInt(txJson['gas']) : null,
      data: txJson['data'] != null ? hexToBytes(txJson['data']) : null,
    );
  }

  Future<void> sendTransaction(context) async {
    setState(ViewState.Busy);

    tx = tx.copyWith(
        gasPrice: EtherAmount.fromUnitAndValue(
            EtherUnit.gwei, selectedFee.gwei.toInt()));

    var resp = await ENVS.chainId_Provider![chainId]?.sendTransaction(
        locator<AccountManager>()
            .allAccounts[
                locator<DAppScreenModel>().launchScreenModel.selectedAccIndex]
            .bscWallet
            .privateKey,
        tx,
        chainId: chainId);

    Navigator.of(context).pop(resp);
  }
}

class DAppApproveScreen extends StatelessWidget {
  int chainId;
  Map<String, dynamic> requestTx;
  DAppApproveScreen(this.requestTx, this.chainId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<DAppTransactionViewModel>(
      onModelReady: (model) {
        model.chainId = chainId;
        model.parseTx(requestTx);
        model.approve = true;

        model.loadGasPrice();
      },
      builder: (context, model, child) {
        return Column(children: [
          Expanded(
              flex: 3,
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop('canceled');
                  },
                  child: SizedBox.expand())),
          Expanded(
            flex: 7,
            child: Material(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: AppColors.primaryBg,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Text('Approve')),
                        Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.of(context).pop('canceled');
                                },
                                child: Icon(Icons.close))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: model.state == ViewState.Busy
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: TBCCLoader(),
                          )
                        : Scrollbar(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    S.of(context).thirdPartyApp,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(color: AppColors.yellow),
                                  ),
                                  Text(S.of(context).currency),
                                  Text(
                                    '${model.approveTokenName}',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  //SizedBox(height: 20),
                                  //TextFieldSimple(
                                  //  label: 'Авторизованный лимит',
                                  //  placeholder: 'No limit',
                                  //),
                                  SizedBox(height: 30),
                                  FeeSelector(model),
                                  SizedBox(height: 40),
                                  Button(
                                      value: S.of(context).confirm,
                                      onTap: () async {
                                        model.sendTransaction(context);
                                      }),
                                  SizedBox(height: 20),
                                  Button(
                                      value: S.of(context).cancel,
                                      color: AppColors.red,
                                      onTap: () {
                                        Navigator.of(context).pop('canceled');
                                      }),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          )
        ]);
      },
    );
  }
}

class FeeSelector extends StatelessWidget {
  DAppTransactionViewModel model;

  FeeSelector(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).networkFee,
            style: Theme.of(context).textTheme.bodyText1),
        feeTile(context, model.fees[0], S.of(context).slow,
            model.selectedFee == model.fees[0], () {
          model.feeSelected(model.fees[0]);
        }),
        feeTile(context, model.fees[1], S.of(context).recommended,
            model.selectedFee == model.fees[1], () {
          model.feeSelected(model.fees[1]);
        }),
        feeTile(context, model.fees[2], S.of(context).fast,
            model.selectedFee == model.fees[2], () {
          model.feeSelected(model.fees[2]);
        }),
      ],
    );
  }

  feeTile(context, TxFee fee, String speed, bool active,
          void Function()? onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(
                  color: active ? AppColors.active : AppColors.inactiveText),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(speed,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: active
                                        ? AppColors.active
                                        : AppColors.text)),
                        Text('  ${fee.gwei} Gwei'),
                      ],
                    ),
                    Row(
                      children: [
                        Text('${fee.inCoin} ${chainID_symbol[model.chainId]}'),
                        Text(
                            '  \$${fee.inFiat.toStringWithFractionDigits(4, shrinkZeros: true)}')
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? AppColors.active : AppColors.inactiveText,
                ),
              )
            ],
          ),
        ),
      );
}

class DAppTransactionScreen extends StatelessWidget {
  int chainId;

  Map<String, dynamic> requestTx;

  DAppTransactionScreen(this.requestTx, this.chainId, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<DAppTransactionViewModel>(
      onModelReady: (model) {
        model.chainId = chainId;
        model.parseTx(requestTx);
        model.loadGasPrice();
      },
      builder: (context, model, child) {
        return Column(children: [
          Expanded(
              flex: 3,
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop('canceled');
                  },
                  child: SizedBox.expand())),
          Expanded(
              flex: 7,
              child: Material(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: AppColors.primaryBg,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: Text(S.of(context).signTx)),
                            Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Navigator.of(context).pop('canceled');
                                    },
                                    child: Icon(Icons.close))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: model.state == ViewState.Busy
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30),
                                child: TBCCLoader(),
                              )
                            : Scrollbar(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        S.of(context).thirdPartyApp,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(color: AppColors.yellow),
                                      ),
                                      SizedBox(height: 20),
                                      if (model.tx.value != null) ...[
                                        Text(S.of(context).amount),
                                        AutoSizeText(
                                          '${model.tx.value!.weiToDecimalEther(18)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                          maxLines: 1,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                            '${chainID_symbol[model.chainId]}'),
                                        SizedBox(height: 20),
                                      ],
                                      FeeSelector(model),
                                      SizedBox(height: 20),
                                      Text(S.of(context).to,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                      SizedBox(height: 15),
                                      Text('${model.tx.to?.hex}'),
                                      SizedBox(height: 20),
                                      Text('Data',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                      SizedBox(height: 15),
                                      Text(
                                          '0x${bytesToHex(model.tx.data!.toList())}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      SizedBox(height: 40),
                                      Button(
                                          value: S.of(context).confirm,
                                          onTap: () async {
                                            model.sendTransaction(context);
                                          }),
                                      SizedBox(height: 20),
                                      Button(
                                          value: S.of(context).cancel,
                                          color: AppColors.red,
                                          onTap: () {
                                            Navigator.of(context)
                                                .pop('canceled');
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  )))
        ]);
      },
    );
  }
}
