import 'dart:typed_data';

// ignore: implementation_imports
import 'package:binance_chain/src/utils/bip32core.dart' as bip32;
import 'package:convert/convert.dart';
import 'package:voola/core/api/foil/FoilApi.dart';
import 'package:web3dart/web3dart.dart';

class FoilWallet {
  late var privateKey;
  late var address;

  FoilWallet({required this.privateKey, required this.address});

  FoilWallet.fromPrivateKey(keys) {
    this.privateKey = keys.privateKey;
    this.address = keys.address;
  }

  factory FoilWallet.fromSeed(keys) {
    return FoilWallet.fromPrivateKey(keys);
  }

  FoilWallet.fromJson(Map<String, dynamic> json) {
    privateKey = json['private_key'];
    address = json['address'];
  }

  Map<String, String> toJson() {
    return <String, String>{'private_key': privateKey, 'address': address};
  }
}
