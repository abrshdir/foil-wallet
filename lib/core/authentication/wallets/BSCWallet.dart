import 'dart:typed_data';
// ignore: implementation_imports
import 'package:binance_chain/src/utils/bip32core.dart' as bip32;
import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart';

class BSCWallet {
  late EthPrivateKey privateKey;
  late EthereumAddress address;
  BSCWallet({required this.privateKey, required this.address});

  BSCWallet.fromPrivateKey(String privateKeyHex) {
    this.privateKey = EthPrivateKey.fromHex(privateKeyHex);
    this.address = privateKey.address;
  }

  factory BSCWallet.fromSeed(Uint8List seed) {
    var bip32inst = bip32.BIP32.fromSeed(seed).derivePath("44'/60'/0'/0/0");
    var privateKeyHex = hex.encode(bip32inst.privateKey!.toList());
    return BSCWallet.fromPrivateKey(privateKeyHex);
  }

  BSCWallet.fromJson(Map<String, dynamic> json) {
    privateKey = EthPrivateKey.fromHex(json['private_key']);
    address = EthereumAddress.fromHex(json['address']);
  }
  Map<String, String> toJson() {
    return <String, String>{'private_key': hex.encode(privateKey.privateKey), 'address': address.hex};
  }
}
