import 'dart:typed_data';

import 'package:binance_chain/binance_chain.dart';
import 'package:voola/global_env.dart';

class BCWallet extends Wallet {
  BCWallet(String privateKey, BinanceEnvironment env) : super(privateKey, env);

  BCWallet.fromSeed(Uint8List seed, BinanceEnvironment env)
      : super.fromSeed(seed, env);

  factory BCWallet.fromJson(Map<String, dynamic> json) {
    return BCWallet(json['private_key'], ENVS.BC_ENV!.env!);
  }
  Map<String, String?> toJson() {
    return <String, String?>{'private_key': privateKey};
  }
}
