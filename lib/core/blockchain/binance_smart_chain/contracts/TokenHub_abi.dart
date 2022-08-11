import 'package:web3dart/contracts.dart' show ContractAbi;

final bscTokenHubAbi = ContractAbi.fromJson(
    '[{"constant":false,"inputs":[{"internalType":"address","name":"contractAddr","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"uint64","name":"expireTime","type":"uint64"}],"name":"transferOut","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[],"name":"relayFee","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"}]',
    'TokenHub');
