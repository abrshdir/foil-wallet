import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:voola/shared.dart';

class Storage {
  final _secureStorage = FlutterSecureStorage();

  Future<void> writeNewPassword(String passwordHash) async {
    return _secureStorage.write(key: 'passwordHash', value: passwordHash);
  }

  Future<String?> readPassword() async {
    return await _secureStorage.read(key: 'passwordHash');
  }

  ///{
  ///   hasLoggedIn         : bool
  ///   locale              : string
  ///   biometricsEnabled   : string
  ///   binanceProxyEnabled : bool
  ///   darkThemeEnabled    : bool
  ///   sentFirstRun        : string
  ///}
  Future<String> readUserSettings() async {
    return await _secureStorage.read(key: 'userSettings') ?? '{}';
  }

  Future<void> writeUserSettings(String settings) async {
    return _secureStorage.write(key: 'userSettings', value: settings);
  }

  Future<String> readUserAccounts() async {
    return await _secureStorage.read(key: 'user_accounts') ?? '[]';
  }

  Future<void> writeUserAccounts(String accountsData) async {
    return _secureStorage.write(key: 'user_accounts', value: accountsData);
  }

  Future<void> resetAll() async {
    return _secureStorage.deleteAll();
  }

  Future<void> migrateStorage() async {
    var migrated = await Future.wait([
      _secureStorage.read(key: 'storageMigrated'),
      _secureStorage.read(key: 'hasLoggedIn')
    ]);
    if (migrated[0] == '1' || migrated[1] != '1') {
      return;
    } else {
      var settings = await Future.wait([
        _secureStorage.read(key: 'password'),
        _secureStorage.read(key: 'sentFirstRun'),
        _secureStorage.read(key: 'biometricsEnabled'),
        _secureStorage.read(key: 'locale'),
        _secureStorage.read(key: 'darkThemeEnabled'),
      ]);
      var settingsJson = <String, dynamic>{};
      if (settings[0] != null) {
        var passwordHash = bytesToHex(
            SHA256Digest().process(Uint8List.fromList(settings[0]!.codeUnits)));
        await writeNewPassword(passwordHash);
      }
      if (settings[1] != null) {
        settingsJson['sentFirstRunVer'] = settings[1];
      }
      if (settings[2] != null) {
        settingsJson['biometricsEnabled'] = settings[2] == '1';
      }
      if (settings[3] != null) {
        settingsJson['locale'] = settings[3];
      }
      if (settings[4] != null) {
        settingsJson['darkThemeEnabled'] = settings[4];
      }
      if (migrated[1] != null) {
        settingsJson['hasLoggedIn'] = migrated[1] == '1';
      }
      await Future.wait([
        _secureStorage.delete(key: 'password'),
        _secureStorage.delete(key: 'sentFirstRun'),
        _secureStorage.delete(key: 'biometricsEnabled'),
        _secureStorage.delete(key: 'locale'),
        _secureStorage.delete(key: 'darkThemeEnabled'),
        _secureStorage.delete(key: 'hasLoggedIn'),
        writeUserSettings(json.encode(settingsJson)),
        _secureStorage.write(key: 'migrated', value: '1'),
      ]);
    }
  }

  Future<String> readAddressBook() async {
    return await _secureStorage.read(key: 'addressBook') ?? '[]';
  }

  Future<void> saveAddressBook(String str) async {
    return _secureStorage.write(key: 'addressBook', value: str);
  }
}
