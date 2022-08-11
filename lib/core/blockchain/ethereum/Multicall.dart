import 'dart:typed_data';

import 'package:voola/core/blockchain/ethereum/contracts/ERC20_abi.dart';
import 'package:voola/global_env.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import '../../token/WalletToken.dart';
import 'contracts/Multicall_abi.dart';

class EthMulticallInteractor {
  late DeployedContract contract;
  late ContractFunction aggFunc;
  Web3Client? provider;

  EthMulticallInteractor([this.provider]) {
    contract = DeployedContract(multicallContractAbi,
        EthereumAddress.fromHex('0xeefBa1e63905eF1D7ACbA5a8513c70307C1cE441'));
    aggFunc = contract.function('aggregate');
  }

  Future<List<EtherAmount>> getBalances(
      List<EthereumAddress> addresses, List<WalletToken> tokens) async {
    final balanceOfFunc = erc20BasicContractAbi.functions
        .firstWhere((f) => f.name == 'balanceOf');
    final getEthBalanceFunction = contract.function('getEthBalance');
    final callArgs = [
      [
        for (var address in addresses) ...[
          [
            contract.address,
            getEthBalanceFunction.encodeCall([address])
          ],
          for (var t in tokens)
            [
              t.ethAddress,
              balanceOfFunc.encodeCall([address])
            ]
        ]
      ]
    ];
    final resp = await aggregate(callArgs);
    final result = (resp[1] as List<dynamic>)
        .cast<Uint8List>()
        .map((e) => EtherAmount.inWei(bytesToInt(e)));
    return result.toList();
  }

  Future<List<dynamic>> aggregate(List<dynamic> args) async {
    return (provider ?? ENVS.ETH_ENV!)
        .call(contract: contract, function: aggFunc, params: args);
  }
}
