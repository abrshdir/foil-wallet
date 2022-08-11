import 'dart:convert';

import 'package:voola/core/api/tbcc/models/Update.dart';
import 'package:voola/core/storage/SecureStorage.dart';
import 'package:voola/global_env.dart';
import 'package:voola/locator.dart';
import 'package:voola/shared.dart';

class UserSettings {
  bool initNetworkFailed = false;
  int? lastNewsRedId;
  final storage = locator<Storage>();
  late bool loggedIn = false;

  bool canCheckBiometrics = false;
  bool biometricsEnabled = false;

  bool accountCarouselExpanded = true;
  late ThemeMode themeMode;
  Locale? language;
  late String versionName;
  late String versionCode;
  late String packageName;
  late String appName;
  late String currencySymbol;
  late String sentFirstRunVer;
  late InnerUpdate update;

  UserSettings();

  void fillfromJson(Map<String, dynamic> json) {
    loggedIn = json['hasLoggedIn'] ?? false;
    biometricsEnabled = json['biometricsEnabled'] ?? false;
    sentFirstRunVer = json['sentFirstRunVer'] ?? '0';
    accountCarouselExpanded = json['accountCarouselExpanded'] ?? true;
    lastNewsRedId = json['lastNewsRedId'] ?? 0;

    ///
    currencySymbol = json['currencySymbol'] ?? 'USD';
    FIAT_CURRENCY_SYMBOL = currencySymbol;
    var lit = getFiatLiteral(currencySymbol);
    FIAT_CURRENCY_LITERAL = lit.length == 3 ? '$lit ' : lit;

    var loc = json['locale'] as String?;
    if (loc != null) {
      var tags = loc.split('-');
      language = Locale(tags[0]);
    }

    switch (json['darkThemeEnabled']) {
      case null:
        themeMode = ThemeMode.system;
        break;
      case '1':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.light;
        break;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'hasLoggedIn': loggedIn,
      'sentFirstRunVer': sentFirstRunVer,
      'locale': language?.toLanguageTag(),
      'biometricsEnabled': biometricsEnabled,
      'currencySymbol': currencySymbol,
      'accountCarouselExpanded': accountCarouselExpanded,
      'darkThemeEnabled': () {
        switch (themeMode) {
          case ThemeMode.system:
            return null;
          case ThemeMode.dark:
            return '1';
          default:
            return '2';
        }
      }(),
    };
  }

  Future<void> save() async {
    return storage.writeUserSettings(json.encode(toJson()));
  }
}
