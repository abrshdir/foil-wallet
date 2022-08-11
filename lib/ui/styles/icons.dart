import 'package:flutter_svg/flutter_svg.dart';
import 'package:voola/shared.dart';

import 'AppTheme.dart';

String _pathBase = 'assets/images';
String _iconsPathBase = '$_pathBase/vector/icons';

class AppIcons {
  static Map<String, String> paths = {
    'logo': '$_iconsPathBase/logo.svg',
    'arrow': '$_iconsPathBase/arrow.svg',
    'arrow_income': '$_iconsPathBase/arrow_income.svg',
    'arrow_outcome': '$_iconsPathBase/arrow_outcome.svg',
    'book-open': '$_iconsPathBase/book-open.svg',
    'chart': '$_iconsPathBase/chart.svg',
    'chevron': '$_iconsPathBase/chevron.svg',
    'copy': '$_iconsPathBase/copy.svg',
    'credit-card': '$_iconsPathBase/credit-card.svg',
    'crown': '$_iconsPathBase/crown.svg',
    'dapp': '$_iconsPathBase/dapp.svg',
    'download_cloud': '$_iconsPathBase/download_cloud.svg',
    'email': '$_iconsPathBase/email.svg',
    'face-detection': '$_iconsPathBase/face-detection.svg',
    'filter': '$_iconsPathBase/filter.svg',
    'fingerprint-scan': '$_iconsPathBase/fingerprint-scan.svg',
    'globe': '$_iconsPathBase/globe.svg',
    'idea': '$_iconsPathBase/idea.svg',
    'info': '$_iconsPathBase/info.svg',
    'key': '$_iconsPathBase/key.svg',
    'market': '$_iconsPathBase/market.svg',
    'message': '$_iconsPathBase/message.svg',
    'minus': '$_iconsPathBase/minus.svg',
    'notification_bell': '$_iconsPathBase/notification_bell.svg',
    'notification_bell_active': '$_iconsPathBase/notification_bell_active.svg',
    'password': '$_iconsPathBase/password.svg',
    'pending': '$_iconsPathBase/pending.svg',
    'person-add': '$_iconsPathBase/person-add.svg',
    'plus-circle': '$_iconsPathBase/plus-circle.svg',
    'plus': '$_iconsPathBase/plus.svg',
    'purchase': '$_iconsPathBase/purchase.svg',
    'reorder': '$_iconsPathBase/reorder.svg',
    'qr-code': '$_iconsPathBase/qr-code.svg',
    'qr-code-scan': '$_iconsPathBase/qr-code-scan.svg',
    'search': '$_iconsPathBase/search.svg',
    'settings': '$_iconsPathBase/settings.svg',
    'smart contract': '$_iconsPathBase/smart-contract.svg',
    'support': '$_iconsPathBase/support.svg',
    'telegram': '$_iconsPathBase/telegram.svg',
    'transaction': '$_iconsPathBase/transaction.svg',
    'twitter': '$_iconsPathBase/twitter.svg',
    'verified': '$_iconsPathBase/verified.svg',
    'vpn': '$_iconsPathBase/vpn.svg',
    'wallet': '$_iconsPathBase/wallet.svg',
    'walletconnect': '$_iconsPathBase/walletconnect.svg',
    's': '$_iconsPathBase/s.svg',
    'g': '$_iconsPathBase/g.svg',
    'close_circle': '$_iconsPathBase/close_circle.svg',
    'arrow_out_corner': '$_iconsPathBase/arrow_out_corner.svg'
  };
  static SvgPicture _pic(String path, double size, Color? color) =>
      SvgPicture.asset(path, width: size, color: color);

  static SvgPicture token_ic(String symbol, double size, [Color? color]) =>
      SvgPicture.asset(
          '$_pathBase/vector/tokens/ic_${symbol.split('-').first}.svg',
          width: size,
          color: color);

  static SvgPicture logo(double size, [Color? color]) =>
      _pic(paths['logo']!, size, color);
  static SvgPicture arrow(double size, [Color? color]) =>
      _pic(paths['arrow']!, size, color);
  static SvgPicture arrow_income(double size, [Color? color]) =>
      _pic(paths['arrow_income']!, size, color);
  static SvgPicture arrow_outcome(double size, [Color? color]) =>
      _pic(paths['arrow_outcome']!, size, color);
  static SvgPicture book_open(double size, [Color? color]) =>
      _pic(paths['book-open']!, size, color);
  static SvgPicture chart(double size, [Color? color]) =>
      _pic(paths['chart']!, size, color);
  static SvgPicture chevron(double size, [Color? color]) =>
      _pic(paths['chevron']!, size, color);
  static SvgPicture copy(double size, [Color? color]) =>
      _pic(paths['copy']!, size, color);
  static SvgPicture credit_card(double size, [Color? color]) =>
      _pic(paths['credit-card']!, size, color);
  static SvgPicture crown(double size, [Color? color]) =>
      _pic(paths['crown']!, size, color);
  static SvgPicture dapp(double size, [Color? color]) =>
      _pic(paths['dapp']!, size, color);
  static SvgPicture download_cloud(double size, [Color? color]) =>
      _pic(paths['download_cloud']!, size, color);
  static SvgPicture email(double size, [Color? color]) =>
      _pic(paths['email']!, size, color);
  static SvgPicture face_detection(double size, [Color? color]) =>
      _pic(paths['face-detection']!, size, color);
  static SvgPicture filter(double size, [Color? color]) =>
      _pic(paths['filter']!, size, color);
  static SvgPicture fingerprint_scan(double size, [Color? color]) =>
      _pic(paths['fingerprint-scan']!, size, color);
  static SvgPicture globe(double size, [Color? color]) =>
      _pic(paths['globe']!, size, color);
  static SvgPicture idea(double size, [Color? color]) =>
      _pic(paths['idea']!, size, color);
  static SvgPicture info(double size, [Color? color]) =>
      _pic(paths['info']!, size, color);
  static SvgPicture key(double size, [Color? color]) =>
      _pic(paths['key']!, size, color);
  static SvgPicture market(double size, [Color? color]) =>
      _pic(paths['market']!, size, color);
  static SvgPicture message(double size, [Color? color]) =>
      _pic(paths['message']!, size, color);
  static SvgPicture minus(double size, [Color? color]) =>
      _pic(paths['minus']!, size, color);
  static SvgPicture notification_bell(double size, [Color? color]) =>
      _pic(paths['notification_bell']!, size, color);
  static SvgPicture notification_bell_active(double size, [Color? color]) =>
      _pic(paths['notification_bell_active']!, size, color);
  static SvgPicture password(double size, [Color? color]) =>
      _pic(paths['password']!, size, color);
  static SvgPicture pending(double size, [Color? color]) =>
      _pic(paths['pending']!, size, color);
  static SvgPicture person_add(double size, [Color? color]) =>
      _pic(paths['person-add']!, size, color);
  static SvgPicture plus_circle(double size, [Color? color]) =>
      _pic(paths['plus-circle']!, size, color);
  static SvgPicture plus(double size, [Color? color]) =>
      _pic(paths['plus']!, size, color);
  static SvgPicture purchase(double size, [Color? color]) =>
      _pic(paths['purchase']!, size, color);
  static SvgPicture reorder(double size, [Color? color]) =>
      _pic(paths['reorder']!, size, color);
  static SvgPicture qr_code(double size, [Color? color]) =>
      _pic(paths['qr-code']!, size, color);
  static SvgPicture qr_code_scan(double size, [Color? color]) =>
      _pic(paths['qr-code-scan']!, size, color);
  static SvgPicture search(double size, [Color? color]) =>
      _pic(paths['search']!, size, color);
  static SvgPicture settings(double size, [Color? color]) =>
      _pic(paths['settings']!, size, color);
  static SvgPicture smart_contract(double size, [Color? color]) =>
      _pic(paths['smart contract']!, size, color);
  static SvgPicture support(double size, [Color? color]) =>
      _pic(paths['support']!, size, color);
  static SvgPicture telegram(double size, [Color? color]) =>
      _pic(paths['telegram']!, size, color);
  static SvgPicture transaction(double size, [Color? color]) =>
      _pic(paths['transaction']!, size, color);
  static SvgPicture twitter(double size, [Color? color]) =>
      _pic(paths['twitter']!, size, color);
  static SvgPicture verified(double size, [Color? color]) =>
      _pic(paths['verified']!, size, color);
  static SvgPicture vpn(double size, [Color? color]) =>
      _pic(paths['vpn']!, size, color);
  static SvgPicture wallet(double size, [Color? color]) =>
      _pic(paths['wallet']!, size, color);
  static SvgPicture walletconnect(double size, [Color? color]) =>
      _pic(paths['walletconnect']!, size, color);
  static SvgPicture s(double size, [Color? color]) =>
      _pic(paths['s']!, size, color);
  static SvgPicture g(double size, [Color? color]) =>
      _pic(paths['g']!, size, color);
  static SvgPicture closeCircle(double size, [Color? color]) =>
      _pic(paths['close_circle']!, size, color);
  static SvgPicture arrowOutCorner(double size, [Color? color]) =>
      _pic(paths['arrow_out_corner']!, size, color);
}
