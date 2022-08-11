import 'dart:convert';

import 'package:voola/core/storage/SecureStorage.dart';
import 'package:voola/core/token/utils.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';

class AddressBookModel extends BaseViewModel {
  final storage = locator<Storage>();

  late List<AddressBookContactEntity> contacts;

  Future<void> readAddressBook() async {
    contacts = [];
    var stor = await storage.readAddressBook();
    var decoded = json.decode(stor);

    for (var i in decoded) {
      contacts.add(AddressBookContactEntity.fromJson(i));
    }
  }

  Future<void> saveAddressBook() async {
    var encoded = json.encode(contacts.map((e) => e.toJson()).toList());
    storage.saveAddressBook(encoded);
  }
}

class AddressBookContactEntity {
  late String name;
  late List<AddressBookAddressEntity> addresses;
  late String id;
  AddressBookContactEntity();
  AddressBookContactEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    addresses = [
      for (var a in json['addresses']) AddressBookAddressEntity.fromJson(a)
    ];
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'addresses': [for (var a in addresses) a.toJson()],
      };
}

class AddressBookAddressEntity {
  late TokenNetwork network;
  late String address;
  late String description;
  AddressBookAddressEntity();
  AddressBookAddressEntity.fromJson(Map<String, dynamic> json) {
    switch (json['network']) {
      case 'BinanceChain':
        network = TokenNetwork.BinanceChain;
        break;
      case 'BinanceSmartChain':
        network = TokenNetwork.BinanceSmartChain;
        break;
      case 'Ethereum':
        network = TokenNetwork.Ethereum;
        break;
      case 'Solana':
        network = TokenNetwork.Solana;
        break;
    }
    address = json['address'] ?? '';
    description = json['description'] ?? '';
  }

  Map<String, dynamic> toJson() => {
        'network': '$network'.split('.').last,
        'address': address,
        'description': description,
      };
}
