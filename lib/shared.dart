import 'dart:math' show pow;

import 'package:binance_chain/binance_chain.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:voola/core/token/utils.dart';
import 'package:voola/locator.dart';
import 'package:voola/ui/views/wallet/transactions/binance_smart_chain/bsc_Transfer.dart';
import 'package:voola/ui/views/wallet/transactions/ethereum/eth_Transfer.dart';
import 'package:web3dart/web3dart.dart';

import 'core/balance/WalletBalance.dart';
import 'global_env.dart';
import 'ui/views/wallet/transactions/binance_chain/bc_Transfer.dart';
import 'ui/views/wallet/transactions/solana/sol_Transfer.dart';

export 'package:decimal/decimal.dart';
export 'package:flutter/material.dart';
export 'package:page_transition/page_transition.dart';
export 'package:voola/core/balance/WalletBalance.dart';
export 'package:voola/core/token/WalletToken.dart';
export 'package:voola/generated/l10n.dart';
export 'package:voola/ui/BaseView.dart';
export 'package:voola/ui/BaseViewModel.dart';
export 'package:voola/ui/styles/AppTheme.dart';
export 'package:voola/ui/styles/icons.dart';
export 'package:voola/ui/widgets/SharedWidgets.dart';
export 'package:web3dart/src/crypto/formatting.dart';
export 'package:web3dart/web3dart.dart' show Web3Client, EthereumAddress;

enum ViewState { Busy, Idle }

void routeToTransfer(
    WalletBalance tokenBalance, BuildContext context, int accountFrom) {
  var result;
  switch (tokenBalance.token.standard) {
    case 'BEP20':
      result = BSCTransferScreen(tokenBalance, accountFrom);
      break;

    case 'ERC20':
      result = ETHTransferScreen(tokenBalance, accountFrom);
      break;

    case 'BEP2':
      result = BCTransferScreen(tokenBalance, accountFrom);
      break;
    case 'BEP8':
      result = BCTransferScreen(tokenBalance, accountFrom);

      break;

    case 'Native':
      switch (tokenBalance.token.network) {
        case TokenNetwork.BinanceSmartChain:
          result = BSCTransferScreen(tokenBalance, accountFrom);
          break;
        case TokenNetwork.Ethereum:
          result = ETHTransferScreen(tokenBalance, accountFrom);
          break;
        case TokenNetwork.Solana:
          result = SOLTransferScreen(tokenBalance, accountFrom);
          break;
        default:
      }
      break;
  }
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => result));
}

String getFiatLiteral(String symbol) =>
    FIAT_CURRENCIES_LITERALS[symbol] ?? symbol;
String shortFmtAddr(String addr) {
  return '${addr.substring(0, 10)}...${addr.substring(addr.length - 8, addr.length)}';
}

extension SetExt<T> on Set<T> {
  Set<T> differenceWhere(Set<Object> other,
      bool Function(T elementOfThis, Object elementOfOther) test) {
    Set<T> result = toSet();
    var otherList = other.toList();

    for (T element in this) {
      if (otherList.containsWhere((otherObj) => test(element, otherObj)))
        result.remove(element);
    }
    return result;
  }
}

Iterable<int> range(int start, int stop, [int step = 1]) sync* {
  if (start > stop && step > 0)
    throw ArgumentError('if start>stop, step must be negative');
  for (int i = start; start > stop ? i > stop : i < stop; i += step) yield i;
}

extension ExtendedIterable<E> on Iterable<E> {
  void forEachIndexed(void Function(E e, int i) f) {
    var i = 0;
    forEach((e) => f(e, i++));
  }

  Iterable<List<dynamic>> indexed() sync* {
    int index = 0;
    for (var e in this) {
      yield [index, e];
      index += 1;
    }
  }

  E? firstWhereMaybe(bool test(E element), {E? orElse()?}) {
    for (E element in this) {
      if (test(element)) return element;
    }
    if (orElse != null) return orElse();
    throw StateError('No element');
  }

  List<T> separate<T>(T separator) {
    Iterator<E> iterator = this.iterator;
    if (!iterator.moveNext()) return [];
    List<T> buffer = <T>[];

    buffer.add(iterator.current as T);
    while (iterator.moveNext()) {
      buffer.add(separator);
      buffer.add(iterator.current as T);
    }

    return buffer;
  }
}

extension DecimalExt on Decimal {
  static Decimal fromNum(num from) {
    return Decimal.tryParse(from.toString())!;
  }

  static final weiDecimal = Decimal.parse('1000000000000000000');
  static final gweiDecimal = Decimal.fromInt(1000000000);

  static Decimal? fromBigInt(BigInt from) {
    return Decimal.tryParse(from.toString())!;
  }

  static Decimal parseFromEtherAmount(String from, [int decimals = 18]) {
    var parsed = Decimal.tryParse(from);
    if (parsed != null) {
      return parsed / Decimal.fromInt(pow(10, decimals) as int);
    } else
      return Decimal.zero;
  }

  Decimal gweiToEther() {
    return this / DecimalExt.gweiDecimal;
  }

  String toStringWithFractionDigits(int fractionDigits,
      {bool shrinkZeros = false}) {
    var splitted = toString().split('.');
    if (this.isInteger) {
      if (shrinkZeros) {
        return splitted.first;
      } else {
        return '${splitted.first}.${'0' * fractionDigits}';
      }
    } else {
      String intPart = splitted.first;
      String fractionalPart = splitted.last;
      fractionalPart = fractionalPart.substring(
          0,
          fractionalPart.length <= fractionDigits
              ? fractionalPart.length
              : fractionDigits);

      if (shrinkZeros) {
        int i;
        for (i = fractionalPart.length - 1; i >= 0; i--) {
          if (fractionalPart != '0') break;
        }
        fractionalPart = fractionalPart.substring(0, i + 1);
      }
      return '$intPart.$fractionalPart';
    }
  }

  EtherAmount toEtherAmount([int decimals = 18]) {
    return EtherAmount.inWei(
        BigInt.parse((this * Decimal.fromInt(10).pow(decimals)).toString()));
  }
}

extension DoubleExt on double {
  String toStringWithFractionDigits(int fractionDigits,
      {bool shrinkZeros = false}) {
    var splitted = toString().split('.');

    String intPart = splitted.first;
    String fractionalPart = splitted.last;
    fractionalPart = fractionalPart.substring(
        0,
        fractionalPart.length <= fractionDigits
            ? fractionalPart.length
            : fractionDigits);

    if (shrinkZeros) {
      int i;
      for (i = fractionalPart.length - 1; i >= 0; i--) {
        if (fractionalPart != '0') break;
      }
      fractionalPart = fractionalPart.substring(0, i + 1);
    }
    return '$intPart.$fractionalPart';
  }
}

extension EtherAmountExt on EtherAmount {
  Decimal weiToDecimalEther(int decimals) {
    var parsed = DecimalExt.fromBigInt(getInWei);
    if (parsed != null) {
      return parsed / Decimal.fromInt(pow(10, decimals) as int);
    } else
      return Decimal.zero;
  }

  Decimal weiToDecimalGwei() {
    var parsed = DecimalExt.fromBigInt(getInWei);
    if (parsed != null) {
      return parsed / DecimalExt.gweiDecimal;
    } else
      return Decimal.zero;
  }
}

extension SolAmountExt on int {
  Decimal lamportsToDecimal(int decimals) {
    var parsed = Decimal.fromInt(this);
    return parsed / Decimal.fromInt(pow(10, decimals) as int);
  }
}

extension ListContains<T> on List<T> {
  bool containsWhere(bool Function(T e) test) {
    for (T item in this) {
      if (test(item)) return true;
    }
    return false;
  }

  List<int> allIndexesWhere(bool Function(T e) test) {
    List<int> indexes = <int>[];
    for (int i in List<int>.generate(this.length, (index) => index)) {
      if (test(this[i])) indexes.add(i);
    }
    return indexes;
  }
}

extension OrderDataModelAdaptor on Order {
  static Order fromWsModel(OrdersData other) {
    var order = Order()
      ..orderId = other.orderID
      ..lastExecutedPrice = other.lastExecutedPrice
      ..lastExecutedQuantity = other.lastExecutedQuantity
      ..side = other.side
      ..quantity = other.quantity
      ..cumulateQuantity = other.cumulativeFilledQuantity
      ..price = other.price
      ..orderCreateTime =
          DateTime.fromMicrosecondsSinceEpoch(other.orderCreationTime! ~/ 1000)
              .toIso8601String()
      ..transactionTime =
          DateTime.fromMicrosecondsSinceEpoch(other.transactionTime! ~/ 1000)
              .toIso8601String()
      ..symbol = other.symbol
      ..status = other.orderStatus
      ..type = other.orderType;

    return order;
  }
}

extension DateTimeConverters on DateTime {
  String toStringDMYT(DateTime date) {
    return DateFormat('EEEE M MMMM y HH:MM', 'ru').format(date);
  }

  String toStringDMY([String dsep = '.', String tsep = ':']) {
    return '${this.day < 10 ? '0' : ''}${this.day}$dsep${this.month < 10 ? '0' : ''}${this.month}$dsep${this.year < 10 ? '0' : ''}${this.year}';
  }

  String toStringDMY_hm(
      [String dsep = '.', String tsep = ':', String dtsep = ', ']) {
    return '${this.day < 10 ? '0' : ''}${this.day}$dsep${this.month < 10 ? '0' : ''}${this.month}$dsep${this.year < 10 ? '0' : ''}${this.year}$dtsep${this.hour < 10 ? '0' : ''}${this.hour}$tsep${this.minute < 10 ? '0' : ''}${this.minute}';
  }

  String toStringDMY_hms(
      [String dsep = '.', String tsep = ':', String dtsep = ', ']) {
    return '${this.day < 10 ? '0' : ''}${this.day}$dsep${this.month < 10 ? '0' : ''}${this.month}$dsep${this.year < 10 ? '0' : ''}${this.year}$dtsep${this.hour < 10 ? '0' : ''}${this.hour}$tsep${this.minute < 10 ? '0' : ''}${this.minute}$tsep${this.second < 10 ? '0' : ''}${this.second}';
  }

  String toStringhm_YMD(
      [String dsep = '.', String tsep = ':', String dtsep = ', ']) {
    return '${this.hour < 10 ? '0' : ''}${this.hour}$tsep${this.minute < 10 ? '0' : ''}${this.minute}$dtsep${this.day < 10 ? '0' : ''}${this.day}$dsep${this.month < 10 ? '0' : ''}${this.month}$dsep${this.year < 10 ? '0' : ''}${this.year}';
  }

  String toStringYMD_hm(
      [String dsep = '.', String tsep = ':', String dtsep = ', ']) {
    return '${this.year < 10 ? '0' : ''}${this.year}$dsep${this.month < 10 ? '0' : ''}${this.month}$dsep${this.day < 10 ? '0' : ''}${this.day}$dtsep${this.hour < 10 ? '0' : ''}${this.hour}$tsep${this.minute < 10 ? '0' : ''}${this.minute}';
  }

  String toStringYMD_hms(
      [String dsep = '.', String tsep = ':', String dtsep = ', ']) {
    return '${this.year < 10 ? '0' : ''}${this.year}$dsep${this.month < 10 ? '0' : ''}${this.month}$dsep${this.day < 10 ? '0' : ''}${this.day}$dtsep${this.hour < 10 ? '0' : ''}${this.hour}$tsep${this.minute < 10 ? '0' : ''}${this.minute}$tsep${this.second < 10 ? '0' : ''}${this.second}';
  }
}

String dividedStringNum(Object? number) {
  var str = number.toString();
  var dotSplitted = str.split('.');
  var intSplitted = dotSplitted[0].split('').reversed.toList();
  var divided = <String>[];
  var i = 0;
  while (true) {
    try {
      var endIndex = i * 3 + 3;
      if (endIndex < intSplitted.length) {
        divided = [
          ' ',
          ...intSplitted.getRange(i * 3, endIndex).toList().reversed,
          ...divided
        ];
      } else {
        divided = [
          ...intSplitted.getRange(i * 3, intSplitted.length).toList().reversed,
          ...divided
        ];
        break;
      }
      i += 1;
    } catch (_) {
      break;
    }
  }
  return dotSplitted.length > 1
      ? [divided.join(''), dotSplitted[1]].join('.')
      : divided.join('');
}

Future<dynamic> showConfirmationDialog(String title, String description,
    {String cancelTitle = 'Cancel',
    String confirmationTitle = 'Confirm'}) async {
  var _service = locator<DialogService>();

  var result = await _service.showConfirmationDialog(
    title: title,
    cancelTitle: cancelTitle,
    confirmationTitle: confirmationTitle,
    description: description,
    barrierDismissible: false,
  );
  return result;
}
