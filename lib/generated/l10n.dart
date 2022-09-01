// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `My VPN keys`
  String get myVpnKeys {
    return Intl.message(
      'My VPN keys',
      name: 'myVpnKeys',
      desc: '',
      args: [],
    );
  }

  /// `Date of purchase`
  String get purchaseDate {
    return Intl.message(
      'Date of purchase',
      name: 'purchaseDate',
      desc: '',
      args: [],
    );
  }

  /// `Address book`
  String get addressBook {
    return Intl.message(
      'Address book',
      name: 'addressBook',
      desc: '',
      args: [],
    );
  }

  /// `Add a new card`
  String get addChange {
    return Intl.message(
      'Add a new card',
      name: 'addChange',
      desc: '',
      args: [],
    );
  }

  /// `Add address`
  String get addAddress {
    return Intl.message(
      'Add address',
      name: 'addAddress',
      desc: '',
      args: [],
    );
  }

  /// `Clear cache`
  String get clearCache {
    return Intl.message(
      'Clear cache',
      name: 'clearCache',
      desc: '',
      args: [],
    );
  }

  /// `Go forward`
  String get goForward {
    return Intl.message(
      'Go forward',
      name: 'goForward',
      desc: '',
      args: [],
    );
  }

  /// `Go back`
  String get goBack {
    return Intl.message(
      'Go back',
      name: 'goBack',
      desc: '',
      args: [],
    );
  }

  /// `Reload`
  String get reload {
    return Intl.message(
      'Reload',
      name: 'reload',
      desc: '',
      args: [],
    );
  }

  /// `Sign the transaction`
  String get signTx {
    return Intl.message(
      'Sign the transaction',
      name: 'signTx',
      desc: '',
      args: [],
    );
  }

  /// `Third party application. Verify data before confirming transactions`
  String get thirdPartyApp {
    return Intl.message(
      'Third party application. Verify data before confirming transactions',
      name: 'thirdPartyApp',
      desc: '',
      args: [],
    );
  }

  /// `Slow`
  String get slow {
    return Intl.message(
      'Slow',
      name: 'slow',
      desc: '',
      args: [],
    );
  }

  /// `Recommended`
  String get recommended {
    return Intl.message(
      'Recommended',
      name: 'recommended',
      desc: '',
      args: [],
    );
  }

  /// `Fast`
  String get fast {
    return Intl.message(
      'Fast',
      name: 'fast',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message(
      'Currency',
      name: 'currency',
      desc: '',
      args: [],
    );
  }

  /// `{token} Price`
  String tokenPrice(Object token) {
    return Intl.message(
      '$token Price',
      name: 'tokenPrice',
      desc: '',
      args: [token],
    );
  }

  /// `About TBCC`
  String get aboutTbcc {
    return Intl.message(
      'About TBCC',
      name: 'aboutTbcc',
      desc: '',
      args: [],
    );
  }

  /// `Access to TBCC VPN`
  String get accessToVpn {
    return Intl.message(
      'Access to TBCC VPN',
      name: 'accessToVpn',
      desc: '',
      args: [],
    );
  }

  /// `Such account is already added`
  String get accountExists {
    return Intl.message(
      'Such account is already added',
      name: 'accountExists',
      desc: '',
      args: [],
    );
  }

  /// `Accounts`
  String get accounts {
    return Intl.message(
      'Accounts',
      name: 'accounts',
      desc: '',
      args: [],
    );
  }

  /// `Actions`
  String get actions {
    return Intl.message(
      'Actions',
      name: 'actions',
      desc: '',
      args: [],
    );
  }

  /// `Add Wallet`
  String get addWallet {
    return Intl.message(
      'Add Wallet',
      name: 'addWallet',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Address of the recipient`
  String get addressOfRecipient {
    return Intl.message(
      'Address of the recipient',
      name: 'addressOfRecipient',
      desc: '',
      args: [],
    );
  }

  /// `Advanced`
  String get advanced {
    return Intl.message(
      'Advanced',
      name: 'advanced',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `All features`
  String get allFeatures {
    return Intl.message(
      'All features',
      name: 'allFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Amount should be ≥{amount}`
  String amountMoreThan(Object amount) {
    return Intl.message(
      'Amount should be ≥$amount',
      name: 'amountMoreThan',
      desc: '',
      args: [amount],
    );
  }

  /// `Amount {token}`
  String amountToken(Object token) {
    return Intl.message(
      'Amount $token',
      name: 'amountToken',
      desc: '',
      args: [token],
    );
  }

  /// `Annually`
  String get annually {
    return Intl.message(
      'Annually',
      name: 'annually',
      desc: '',
      args: [],
    );
  }

  /// `If you attach your smart card, you will be able to enter account ONLY with card!`
  String get attachCardText1 {
    return Intl.message(
      'If you attach your smart card, you will be able to enter account ONLY with card!',
      name: 'attachCardText1',
      desc: '',
      args: [],
    );
  }

  /// `Before attaching smart card we are recommending to make sure that you have saved your mnemonic passphrase in solid/safe place so that if you lose your smart card, you can restore your account. `
  String get attachCardText2 {
    return Intl.message(
      'Before attaching smart card we are recommending to make sure that you have saved your mnemonic passphrase in solid/safe place so that if you lose your smart card, you can restore your account. ',
      name: 'attachCardText2',
      desc: '',
      args: [],
    );
  }

  /// `Attach smart card`
  String get attachSmartCard {
    return Intl.message(
      'Attach smart card',
      name: 'attachSmartCard',
      desc: '',
      args: [],
    );
  }

  /// `Attach your NFC crad to the back of your phone.`
  String get attachYourCard {
    return Intl.message(
      'Attach your NFC crad to the back of your phone.',
      name: 'attachYourCard',
      desc: '',
      args: [],
    );
  }

  /// `Smart card attachment`
  String get attachingSmartCard {
    return Intl.message(
      'Smart card attachment',
      name: 'attachingSmartCard',
      desc: '',
      args: [],
    );
  }

  /// `Attention!`
  String get attention {
    return Intl.message(
      'Attention!',
      name: 'attention',
      desc: '',
      args: [],
    );
  }

  /// `Available actions with {token}`
  String availableActions(Object token) {
    return Intl.message(
      'Available actions with $token',
      name: 'availableActions',
      desc: '',
      args: [token],
    );
  }

  /// `Available for swap:`
  String get awailableToSwap {
    return Intl.message(
      'Available for swap:',
      name: 'awailableToSwap',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get backup {
    return Intl.message(
      'Restore',
      name: 'backup',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message(
      'Balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Become {type}`
  String becomePro(Object type) {
    return Intl.message(
      'Become $type',
      name: 'becomePro',
      desc: '',
      args: [type],
    );
  }

  /// `Payments will be made 10 days after the end of receiving funds.`
  String get benefitPaymentsInfo {
    return Intl.message(
      'Payments will be made 10 days after the end of receiving funds.',
      name: 'benefitPaymentsInfo',
      desc: '',
      args: [],
    );
  }

  /// `Best Ask`
  String get bestAsk {
    return Intl.message(
      'Best Ask',
      name: 'bestAsk',
      desc: '',
      args: [],
    );
  }

  /// `Best Bid`
  String get bestBid {
    return Intl.message(
      'Best Bid',
      name: 'bestBid',
      desc: '',
      args: [],
    );
  }

  /// `BinanceChain PrivateKey`
  String get binancePK {
    return Intl.message(
      'BinanceChain PrivateKey',
      name: 'binancePK',
      desc: '',
      args: [],
    );
  }

  /// `Biometrics`
  String get biometrics {
    return Intl.message(
      'Biometrics',
      name: 'biometrics',
      desc: '',
      args: [],
    );
  }

  /// `Enable biometric unlock?`
  String get biometricsEnableAsk {
    return Intl.message(
      'Enable biometric unlock?',
      name: 'biometricsEnableAsk',
      desc: '',
      args: [],
    );
  }

  /// `You can enable Fingerprint / Face ID instead of using the password to log in`
  String get biometricsText {
    return Intl.message(
      'You can enable Fingerprint / Face ID instead of using the password to log in',
      name: 'biometricsText',
      desc: '',
      args: [],
    );
  }

  /// `Your device does not support biometric authentication`
  String get biometricsUnavailable {
    return Intl.message(
      'Your device does not support biometric authentication',
      name: 'biometricsUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get buy {
    return Intl.message(
      'Buy',
      name: 'buy',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get buyInAdd {
    return Intl.message(
      'Buy',
      name: 'buyInAdd',
      desc: '',
      args: [],
    );
  }

  /// `Buy or swap`
  String get buyOrSwap {
    return Intl.message(
      'Buy or swap',
      name: 'buyOrSwap',
      desc: '',
      args: [],
    );
  }

  /// `Buy {token}`
  String buyToken(Object token) {
    return Intl.message(
      'Buy $token',
      name: 'buyToken',
      desc: '',
      args: [token],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get canceled {
    return Intl.message(
      'Canceled',
      name: 'canceled',
      desc: '',
      args: [],
    );
  }

  /// `Candlestick chart`
  String get candlestickChart {
    return Intl.message(
      'Candlestick chart',
      name: 'candlestickChart',
      desc: '',
      args: [],
    );
  }

  /// `Can't be empty`
  String get cantBeEmpty {
    return Intl.message(
      'Can\'t be empty',
      name: 'cantBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `The card has been already attached to one of the accounts`
  String get cardAttachedYet {
    return Intl.message(
      'The card has been already attached to one of the accounts',
      name: 'cardAttachedYet',
      desc: '',
      args: [],
    );
  }

  /// `You have not ordered a smart card yet`
  String get cardNotOrderedYet {
    return Intl.message(
      'You have not ordered a smart card yet',
      name: 'cardNotOrderedYet',
      desc: '',
      args: [],
    );
  }

  /// `Enter 6-digit PIN-code for your card.`
  String get cardPinText1 {
    return Intl.message(
      'Enter 6-digit PIN-code for your card.',
      name: 'cardPinText1',
      desc: '',
      args: [],
    );
  }

  /// `When entering account using a card, you will need to enter this PIN-code.`
  String get cardPinText2 {
    return Intl.message(
      'When entering account using a card, you will need to enter this PIN-code.',
      name: 'cardPinText2',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Chart`
  String get chart {
    return Intl.message(
      'Chart',
      name: 'chart',
      desc: '',
      args: [],
    );
  }

  /// `Check Your Internet connection`
  String get checkInternet {
    return Intl.message(
      'Check Your Internet connection',
      name: 'checkInternet',
      desc: '',
      args: [],
    );
  }

  /// `Check if mnemonic phrases are saved from your wallets`
  String get checkSavedMnemonicAll {
    return Intl.message(
      'Check if mnemonic phrases are saved from your wallets',
      name: 'checkSavedMnemonicAll',
      desc: '',
      args: [],
    );
  }

  /// `Check if the mnemonic phrase is saved from this wallet`
  String get checkSavedMnemonicSingle {
    return Intl.message(
      'Check if the mnemonic phrase is saved from this wallet',
      name: 'checkSavedMnemonicSingle',
      desc: '',
      args: [],
    );
  }

  /// `File integrity check...`
  String get checkingIntegrity {
    return Intl.message(
      'File integrity check...',
      name: 'checkingIntegrity',
      desc: '',
      args: [],
    );
  }

  /// `Choose a wallet`
  String get chooseWallet {
    return Intl.message(
      'Choose a wallet',
      name: 'chooseWallet',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get closedOrders {
    return Intl.message(
      'Closed',
      name: 'closedOrders',
      desc: '',
      args: [],
    );
  }

  /// `Customers who have activated PRO accounts will be given priority to enter the Binance Cloud exchange, and soon you will be able to trade on TBCC & Binance exchange. We wish you happiness and success in the new year!`
  String get cloudDialogDescription {
    return Intl.message(
      'Customers who have activated PRO accounts will be given priority to enter the Binance Cloud exchange, and soon you will be able to trade on TBCC & Binance exchange. We wish you happiness and success in the new year!',
      name: 'cloudDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `You can trade cryptocurrency anywhere in the world and at any time using our exchange. Our easy-to-use interface will help you make your cryptocurrency experience as convenient as possible. Our exchange will operate on the Binance Cloud and offer its users one of the largest liquidity pools in the world. Trade the world's leading digital assets!`
  String get cloudVoteDesc {
    return Intl.message(
      'You can trade cryptocurrency anywhere in the world and at any time using our exchange. Our easy-to-use interface will help you make your cryptocurrency experience as convenient as possible. Our exchange will operate on the Binance Cloud and offer its users one of the largest liquidity pools in the world. Trade the world\'s leading digital assets!',
      name: 'cloudVoteDesc',
      desc: '',
      args: [],
    );
  }

  /// `Coin`
  String get coin {
    return Intl.message(
      'Coin',
      name: 'coin',
      desc: '',
      args: [],
    );
  }

  /// `NFT`
  String get nft {
    return Intl.message(
      'NFT',
      name: 'nft',
      desc: '',
      args: [],
    );
  }

  /// `Community`
  String get community {
    return Intl.message(
      'Community',
      name: 'community',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Confirm action`
  String get confirmAction {
    return Intl.message(
      'Confirm action',
      name: 'confirmAction',
      desc: '',
      args: [],
    );
  }

  /// `I confirm my consent to the`
  String get confirmPhrase1 {
    return Intl.message(
      'I confirm my consent to the',
      name: 'confirmPhrase1',
      desc: '',
      args: [],
    );
  }

  /// `terms of the user agreement`
  String get confirmPhrase2 {
    return Intl.message(
      'terms of the user agreement',
      name: 'confirmPhrase2',
      desc: '',
      args: [],
    );
  }

  /// `Confirm swap`
  String get confirmSwap {
    return Intl.message(
      'Confirm swap',
      name: 'confirmSwap',
      desc: '',
      args: [],
    );
  }

  /// `Confrim transfer`
  String get confirmTransfer {
    return Intl.message(
      'Confrim transfer',
      name: 'confirmTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Confirmations`
  String get confirmations {
    return Intl.message(
      'Confirmations',
      name: 'confirmations',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_ {
    return Intl.message(
      'Continue',
      name: 'continue_',
      desc: '',
      args: [],
    );
  }

  /// `{some} Copied to clipboard`
  String copiedToClipboard(Object some) {
    return Intl.message(
      '$some Copied to clipboard',
      name: 'copiedToClipboard',
      desc: '',
      args: [some],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Create new wallet`
  String get createWallet {
    return Intl.message(
      'Create new wallet',
      name: 'createWallet',
      desc: '',
      args: [],
    );
  }

  /// `Current price`
  String get currentPrice {
    return Intl.message(
      'Current price',
      name: 'currentPrice',
      desc: '',
      args: [],
    );
  }

  /// `Current session`
  String get currentSession {
    return Intl.message(
      'Current session',
      name: 'currentSession',
      desc: '',
      args: [],
    );
  }

  /// `Current status:`
  String get currentStatus {
    return Intl.message(
      'Current status:',
      name: 'currentStatus',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message(
      'Dark Mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Disable`
  String get disable {
    return Intl.message(
      'Disable',
      name: 'disable',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect`
  String get disconnect {
    return Intl.message(
      'Disconnect',
      name: 'disconnect',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Email Support`
  String get emailSupport {
    return Intl.message(
      'Email Support',
      name: 'emailSupport',
      desc: '',
      args: [],
    );
  }

  /// `Enable`
  String get enable {
    return Intl.message(
      'Enable',
      name: 'enable',
      desc: '',
      args: [],
    );
  }

  /// `End date for accepting funds:`
  String get endInvestDate {
    return Intl.message(
      'End date for accepting funds:',
      name: 'endInvestDate',
      desc: '',
      args: [],
    );
  }

  /// `Enter PIN-code`
  String get enterPin {
    return Intl.message(
      'Enter PIN-code',
      name: 'enterPin',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Ethereum PrivateKey`
  String get ethereumPK {
    return Intl.message(
      'Ethereum PrivateKey',
      name: 'ethereumPK',
      desc: '',
      args: [],
    );
  }

  /// `Exchange`
  String get exchange {
    return Intl.message(
      'Exchange',
      name: 'exchange',
      desc: '',
      args: [],
    );
  }

  /// `Fee`
  String get fee {
    return Intl.message(
      'Fee',
      name: 'fee',
      desc: '',
      args: [],
    );
  }

  /// `The file is damaged. Try it again`
  String get fileDamaged {
    return Intl.message(
      'The file is damaged. Try it again',
      name: 'fileDamaged',
      desc: '',
      args: [],
    );
  }

  /// `Fingerprint`
  String get fingerprint {
    return Intl.message(
      'Fingerprint',
      name: 'fingerprint',
      desc: '',
      args: [],
    );
  }


  /// `Foil coin PrivateKey`
  String get foilPk {
    return Intl.message(
      'Foil PrivateKey',
      name: 'foilPK',
      desc: '',
      args: [],
    );
  }

  /// `An important app update is available. To continue, you need to download and install it.`
  String get forceUpdate {
    return Intl.message(
      'An important app update is available. To continue, you need to download and install it.',
      name: 'forceUpdate',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `Gas Limit`
  String get gasLimit {
    return Intl.message(
      'Gas Limit',
      name: 'gasLimit',
      desc: '',
      args: [],
    );
  }

  /// `Gas Price`
  String get gasPrice {
    return Intl.message(
      'Gas Price',
      name: 'gasPrice',
      desc: '',
      args: [],
    );
  }

  /// `Get access with {type}`
  String getAccessWithPro(Object type) {
    return Intl.message(
      'Get access with $type',
      name: 'getAccessWithPro',
      desc: '',
      args: [type],
    );
  }

  /// `Get OTC with {type}`
  String getOTCWithPro(Object type) {
    return Intl.message(
      'Get OTC with $type',
      name: 'getOTCWithPro',
      desc: '',
      args: [type],
    );
  }

  /// `Go {type}`
  String goPro(Object type) {
    return Intl.message(
      'Go $type',
      name: 'goPro',
      desc: '',
      args: [type],
    );
  }

  /// `Go to Website`
  String get goToWebsite {
    return Intl.message(
      'Go to Website',
      name: 'goToWebsite',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `I understood`
  String get iUnderstood {
    return Intl.message(
      'I understood',
      name: 'iUnderstood',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect Password`
  String get incorrectPassword {
    return Intl.message(
      'Incorrect Password',
      name: 'incorrectPassword',
      desc: '',
      args: [],
    );
  }

  /// `Paste promocode (if you have)`
  String get insertPromoCode {
    return Intl.message(
      'Paste promocode (if you have)',
      name: 'insertPromoCode',
      desc: '',
      args: [],
    );
  }

  /// `Install`
  String get installUpdate {
    return Intl.message(
      'Install',
      name: 'installUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Mnemonic`
  String get invalidMnemonic {
    return Intl.message(
      'Invalid Mnemonic',
      name: 'invalidMnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Wrong order`
  String get invalidOrder {
    return Intl.message(
      'Wrong order',
      name: 'invalidOrder',
      desc: '',
      args: [],
    );
  }

  /// `Invest`
  String get invest {
    return Intl.message(
      'Invest',
      name: 'invest',
      desc: '',
      args: [],
    );
  }

  /// `It is possible to invest once from one account. You have the ability to create up to 5 accounts on one device. Interest is paid in TBCC bep2 tokens. Users who vote will receive an additional 0.5%.`
  String get investAttention {
    return Intl.message(
      'It is possible to invest once from one account. You have the ability to create up to 5 accounts on one device. Interest is paid in TBCC bep2 tokens. Users who vote will receive an additional 0.5%.',
      name: 'investAttention',
      desc: '',
      args: [],
    );
  }

  /// `Investments`
  String get investment {
    return Intl.message(
      'Investments',
      name: 'investment',
      desc: '',
      args: [],
    );
  }

  /// `Join Community`
  String get joinCommunity {
    return Intl.message(
      'Join Community',
      name: 'joinCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Bought codes`
  String get jump_boughtCodes {
    return Intl.message(
      'Bought codes',
      name: 'jump_boughtCodes',
      desc: '',
      args: [],
    );
  }

  /// `Buy lives TBCC Jump`
  String get jump_buyLives {
    return Intl.message(
      'Buy lives TBCC Jump',
      name: 'jump_buyLives',
      desc: '',
      args: [],
    );
  }

  /// `There are {cnt} codes left for this ID`
  String jump_codesLeft(Object cnt) {
    return Intl.message(
      'There are $cnt codes left for this ID',
      name: 'jump_codesLeft',
      desc: '',
      args: [cnt],
    );
  }

  /// `Write your in-game ID`
  String get jump_writeID {
    return Intl.message(
      'Write your in-game ID',
      name: 'jump_writeID',
      desc: '',
      args: [],
    );
  }

  /// `Knowledge Base`
  String get knowledgeBase {
    return Intl.message(
      'Knowledge Base',
      name: 'knowledgeBase',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get logIn {
    return Intl.message(
      'Log In',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Log in with a smart card.`
  String get logInWithCard {
    return Intl.message(
      'Log in with a smart card.',
      name: 'logInWithCard',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Log out of all accounts?`
  String get logOutAllQuestion {
    return Intl.message(
      'Log out of all accounts?',
      name: 'logOutAllQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Log out?`
  String get logOutQuestion {
    return Intl.message(
      'Log out?',
      name: 'logOutQuestion',
      desc: '',
      args: [],
    );
  }

  /// `TBCC Lottery`
  String get lottery {
    return Intl.message(
      'TBCC Lottery',
      name: 'lottery',
      desc: '',
      args: [],
    );
  }

  /// `Buy Ticket`
  String get lotteryAccept {
    return Intl.message(
      'Buy Ticket',
      name: 'lotteryAccept',
      desc: '',
      args: [],
    );
  }

  /// `Bought Tickets:`
  String get lotteryAccepted {
    return Intl.message(
      'Bought Tickets:',
      name: 'lotteryAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Take part in the lottery and get a chance to win prize!`
  String get lotteryDesc1 {
    return Intl.message(
      'Take part in the lottery and get a chance to win prize!',
      name: 'lotteryDesc1',
      desc: '',
      args: [],
    );
  }

  /// `The lottery will last until {end} and the results of the lottery will be announced on {result}`
  String lotteryDesc2(Object end, Object result) {
    return Intl.message(
      'The lottery will last until $end and the results of the lottery will be announced on $result',
      name: 'lotteryDesc2',
      desc: '',
      args: [end, result],
    );
  }

  /// `Dates: ticket sales from {startend}, counting will be made {result}`
  String lotteryDesc3(Object startend, Object result) {
    return Intl.message(
      'Dates: ticket sales from $startend, counting will be made $result',
      name: 'lotteryDesc3',
      desc: '',
      args: [startend, result],
    );
  }

  /// `Announcement of the lottery results and payment of winnings on {date}`
  String lotteryDesc4(Object date) {
    return Intl.message(
      'Announcement of the lottery results and payment of winnings on $date',
      name: 'lotteryDesc4',
      desc: '',
      args: [date],
    );
  }

  /// `1. An unlimited number of addresses can participate in the lottery.`
  String get lotteryRule1 {
    return Intl.message(
      '1. An unlimited number of addresses can participate in the lottery.',
      name: 'lotteryRule1',
      desc: '',
      args: [],
    );
  }

  /// `2. By buying tickets, you increase your chances of winning the lottery.`
  String get lotteryRule2 {
    return Intl.message(
      '2. By buying tickets, you increase your chances of winning the lottery.',
      name: 'lotteryRule2',
      desc: '',
      args: [],
    );
  }

  /// `3. The cost of one ticket is {price} TBCC (BEP20).`
  String lotteryRule3(Object price) {
    return Intl.message(
      '3. The cost of one ticket is $price TBCC (BEP20).',
      name: 'lotteryRule3',
      desc: '',
      args: [price],
    );
  }

  /// `4. The lottery can only be accepted by owners of PRO and PREMIUM accounts`
  String get lotteryRule4 {
    return Intl.message(
      '4. The lottery can only be accepted by owners of PRO and PREMIUM accounts',
      name: 'lotteryRule4',
      desc: '',
      args: [],
    );
  }

  /// `List of winners`
  String get lotteryWinners {
    return Intl.message(
      'List of winners',
      name: 'lotteryWinners',
      desc: '',
      args: [],
    );
  }

  /// `If you are on the list of winners, then your account address will be highlighted in the list below`
  String get lotteryWinnersDesc1 {
    return Intl.message(
      'If you are on the list of winners, then your account address will be highlighted in the list below',
      name: 'lotteryWinnersDesc1',
      desc: '',
      args: [],
    );
  }

  /// `All winners will automatically receive TBCC tokens as a prize.`
  String get lotteryWinnersDesc2 {
    return Intl.message(
      'All winners will automatically receive TBCC tokens as a prize.',
      name: 'lotteryWinnersDesc2',
      desc: '',
      args: [],
    );
  }

  /// `Market`
  String get market {
    return Intl.message(
      'Market',
      name: 'market',
      desc: '',
      args: [],
    );
  }

  /// `Market Depth`
  String get marketDepth {
    return Intl.message(
      'Market Depth',
      name: 'marketDepth',
      desc: '',
      args: [],
    );
  }

  /// `Pairs`
  String get marketPairs {
    return Intl.message(
      'Pairs',
      name: 'marketPairs',
      desc: '',
      args: [],
    );
  }

  /// `Send funds indicating the purpose of payment?`
  String get memoInfoDialogHeader {
    return Intl.message(
      'Send funds indicating the purpose of payment?',
      name: 'memoInfoDialogHeader',
      desc: '',
      args: [],
    );
  }

  /// `Leave the field blank if not required by the recipient`
  String get memoInfoDialogText {
    return Intl.message(
      'Leave the field blank if not required by the recipient',
      name: 'memoInfoDialogText',
      desc: '',
      args: [],
    );
  }

  /// `You see`
  String get mnemonicDescription1 {
    return Intl.message(
      'You see',
      name: 'mnemonicDescription1',
      desc: '',
      args: [],
    );
  }

  /// `12 words`
  String get mnemonicDescription2 {
    return Intl.message(
      '12 words',
      name: 'mnemonicDescription2',
      desc: '',
      args: [],
    );
  }

  /// `that will allow you to restore the wallet`
  String get mnemonicDescription3 {
    return Intl.message(
      'that will allow you to restore the wallet',
      name: 'mnemonicDescription3',
      desc: '',
      args: [],
    );
  }

  /// `Store them in a safe place and keep them secret.`
  String get mnemonicDescription4 {
    return Intl.message(
      'Store them in a safe place and keep them secret.',
      name: 'mnemonicDescription4',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic Phrase`
  String get mnemonicPhrase {
    return Intl.message(
      'Mnemonic Phrase',
      name: 'mnemonicPhrase',
      desc: '',
      args: [],
    );
  }

  /// `I understand that if I lose my passphrase I will lose access to my wallet`
  String get mnemonicWarning {
    return Intl.message(
      'I understand that if I lose my passphrase I will lose access to my wallet',
      name: 'mnemonicWarning',
      desc: '',
      args: [],
    );
  }

  /// `Write words from your mnemonic phrase`
  String get mnemonicWrite {
    return Intl.message(
      'Write words from your mnemonic phrase',
      name: 'mnemonicWrite',
      desc: '',
      args: [],
    );
  }

  /// `TBCC started developing its own operating system for mobile phones. The alpha version of the system is already being tested by our specialists. All TBCC products will be directly on the mobile device. Keeping cyptocurrency will become even safer. Our own infrastructure will ensure high availability. TBCC is getting stronger every day!`
  String get mobileOsVoteDesc {
    return Intl.message(
      'TBCC started developing its own operating system for mobile phones. The alpha version of the system is already being tested by our specialists. All TBCC products will be directly on the mobile device. Keeping cyptocurrency will become even safer. Our own infrastructure will ensure high availability. TBCC is getting stronger every day!',
      name: 'mobileOsVoteDesc',
      desc: '',
      args: [],
    );
  }

  /// `Multi-wallet`
  String get multiWallet {
    return Intl.message(
      'Multi-wallet',
      name: 'multiWallet',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get myOrders {
    return Intl.message(
      'My Orders',
      name: 'myOrders',
      desc: '',
      args: [],
    );
  }

  /// `Network Fee`
  String get networkFee {
    return Intl.message(
      'Network Fee',
      name: 'networkFee',
      desc: '',
      args: [],
    );
  }

  /// `New account name`
  String get newAccountName {
    return Intl.message(
      'New account name',
      name: 'newAccountName',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `News`
  String get news {
    return Intl.message(
      'News',
      name: 'news',
      desc: '',
      args: [],
    );
  }

  /// `NFC is off or not avaliable. Please, check if the NFC module is enabled.`
  String get nfcUnavailable {
    return Intl.message(
      'NFC is off or not avaliable. Please, check if the NFC module is enabled.',
      name: 'nfcUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `No actions available`
  String get noActions {
    return Intl.message(
      'No actions available',
      name: 'noActions',
      desc: '',
      args: [],
    );
  }

  /// `No closed orders yet`
  String get noClosedOrders {
    return Intl.message(
      'No closed orders yet',
      name: 'noClosedOrders',
      desc: '',
      args: [],
    );
  }

  /// `No open orders yet`
  String get noOpenOrders {
    return Intl.message(
      'No open orders yet',
      name: 'noOpenOrders',
      desc: '',
      args: [],
    );
  }

  /// `No transactions at the moment`
  String get noTransactions {
    return Intl.message(
      'No transactions at the moment',
      name: 'noTransactions',
      desc: '',
      args: [],
    );
  }

  /// `No valid address found`
  String get noValidAddrFound {
    return Intl.message(
      'No valid address found',
      name: 'noValidAddrFound',
      desc: '',
      args: [],
    );
  }

  /// `No valid mnemonic phrase found`
  String get noValidMnemonic {
    return Intl.message(
      'No valid mnemonic phrase found',
      name: 'noValidMnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Not enough tokens`
  String get notEnoughTokens {
    return Intl.message(
      'Not enough tokens',
      name: 'notEnoughTokens',
      desc: '',
      args: [],
    );
  }

  /// `Not enough {token} to pay fee`
  String notEnoughTokensFee(Object token) {
    return Intl.message(
      'Not enough $token to pay fee',
      name: 'notEnoughTokensFee',
      desc: '',
      args: [token],
    );
  }

  /// `One-time`
  String get oneTimePayment {
    return Intl.message(
      'One-time',
      name: 'oneTimePayment',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get openOrders {
    return Intl.message(
      'Open',
      name: 'openOrders',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optional {
    return Intl.message(
      'Optional',
      name: 'optional',
      desc: '',
      args: [],
    );
  }

  /// `Order Book`
  String get orderBook {
    return Intl.message(
      'Order Book',
      name: 'orderBook',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get orderFinishTime {
    return Intl.message(
      'Finish',
      name: 'orderFinishTime',
      desc: '',
      args: [],
    );
  }

  /// `Order placed successfully`
  String get orderPlaced {
    return Intl.message(
      'Order placed successfully',
      name: 'orderPlaced',
      desc: '',
      args: [],
    );
  }

  /// `Order Smart Card`
  String get orderSmartCard {
    return Intl.message(
      'Order Smart Card',
      name: 'orderSmartCard',
      desc: '',
      args: [],
    );
  }

  /// `Do you confirm the order of a smart card?`
  String get orderSmartCardConfirmation {
    return Intl.message(
      'Do you confirm the order of a smart card?',
      name: 'orderSmartCardConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get orderStartTime {
    return Intl.message(
      'Start',
      name: 'orderStartTime',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get orderType {
    return Intl.message(
      'Type',
      name: 'orderType',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `This password will be used to unlock your wallet & use cryptocurrency`
  String get passwordInfo {
    return Intl.message(
      'This password will be used to unlock your wallet & use cryptocurrency',
      name: 'passwordInfo',
      desc: '',
      args: [],
    );
  }

  /// `Password need at least 8 symbols`
  String get passwordSymbolAmount {
    return Intl.message(
      'Password need at least 8 symbols',
      name: 'passwordSymbolAmount',
      desc: '',
      args: [],
    );
  }

  /// `Paste`
  String get paste {
    return Intl.message(
      'Paste',
      name: 'paste',
      desc: '',
      args: [],
    );
  }

  /// `PIN-codes do not match`
  String get pinCodesNotMatch {
    return Intl.message(
      'PIN-codes do not match',
      name: 'pinCodesNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `10% discount on renewing your Premium account`
  String get premDiscount {
    return Intl.message(
      '10% discount on renewing your Premium account',
      name: 'premDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Price {token}`
  String priceToken(Object token) {
    return Intl.message(
      'Price $token',
      name: 'priceToken',
      desc: '',
      args: [token],
    );
  }

  /// `Private Keys`
  String get privateKeys {
    return Intl.message(
      'Private Keys',
      name: 'privateKeys',
      desc: '',
      args: [],
    );
  }

  /// `Get access to more features and more savings with TBCC Wallet {type}`
  String proDesc0(Object type) {
    return Intl.message(
      'Get access to more features and more savings with TBCC Wallet $type',
      name: 'proDesc0',
      desc: '',
      args: [type],
    );
  }

  /// `Get full access for {price}`
  String proDesc1(Object price) {
    return Intl.message(
      'Get full access for $price',
      name: 'proDesc1',
      desc: '',
      args: [price],
    );
  }

  /// `Get access for {price}`
  String proDesc12(Object price) {
    return Intl.message(
      'Get access for $price',
      name: 'proDesc12',
      desc: '',
      args: [price],
    );
  }

  /// `These are accounts that are created by one user. Convenient switching between accounts. It will be possible to create up to 3 accounts on one device.`
  String get proDesc2 {
    return Intl.message(
      'These are accounts that are created by one user. Convenient switching between accounts. It will be possible to create up to 3 accounts on one device.',
      name: 'proDesc2',
      desc: '',
      args: [],
    );
  }

  /// `Multi-account`
  String get proDesc2h {
    return Intl.message(
      'Multi-account',
      name: 'proDesc2h',
      desc: '',
      args: [],
    );
  }

  /// `For the conclusion of OTC transactions, you do not need to reserve funds on the eve of trading, since the participants in transactions are settled directly. As a rule, OTC transactions are concluded with deferred settlements.`
  String get proDesc3 {
    return Intl.message(
      'For the conclusion of OTC transactions, you do not need to reserve funds on the eve of trading, since the participants in transactions are settled directly. As a rule, OTC transactions are concluded with deferred settlements.',
      name: 'proDesc3',
      desc: '',
      args: [],
    );
  }

  /// `OTC transactions`
  String get proDesc3h {
    return Intl.message(
      'OTC transactions',
      name: 'proDesc3h',
      desc: '',
      args: [],
    );
  }

  /// `Pay less for transactions and cryptocurrency exchanges. All transactions will take place at the lowest prices.`
  String get proDesc4 {
    return Intl.message(
      'Pay less for transactions and cryptocurrency exchanges. All transactions will take place at the lowest prices.',
      name: 'proDesc4',
      desc: '',
      args: [],
    );
  }

  /// `Reduced commissions`
  String get proDesc4h {
    return Intl.message(
      'Reduced commissions',
      name: 'proDesc4h',
      desc: '',
      args: [],
    );
  }

  /// `Get the latest updates from the very first. New technologies will be immediately in your wallet.`
  String get proDesc5 {
    return Intl.message(
      'Get the latest updates from the very first. New technologies will be immediately in your wallet.',
      name: 'proDesc5',
      desc: '',
      args: [],
    );
  }

  /// `Latest news`
  String get proDesc5h {
    return Intl.message(
      'Latest news',
      name: 'proDesc5h',
      desc: '',
      args: [],
    );
  }

  /// `We will answer any of your questions. We will help you solve any of your problems.`
  String get proDesc6 {
    return Intl.message(
      'We will answer any of your questions. We will help you solve any of your problems.',
      name: 'proDesc6',
      desc: '',
      args: [],
    );
  }

  /// `Individual technical support`
  String get proDesc6h {
    return Intl.message(
      'Individual technical support',
      name: 'proDesc6h',
      desc: '',
      args: [],
    );
  }

  /// `15% discount on renewing your PRO account`
  String get proDiscount {
    return Intl.message(
      '15% discount on renewing your PRO account',
      name: 'proDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations, you got a three month free VPN trial.`
  String get proVpnDialog {
    return Intl.message(
      'Congratulations, you got a three month free VPN trial.',
      name: 'proVpnDialog',
      desc: '',
      args: [],
    );
  }

  /// `Purchase {type}`
  String purchasePro(Object type) {
    return Intl.message(
      'Purchase $type',
      name: 'purchasePro',
      desc: '',
      args: [type],
    );
  }

  /// `Buy VPN`
  String get purchaseVpn {
    return Intl.message(
      'Buy VPN',
      name: 'purchaseVpn',
      desc: '',
      args: [],
    );
  }

  /// `Purchased`
  String get purchased {
    return Intl.message(
      'Purchased',
      name: 'purchased',
      desc: '',
      args: [],
    );
  }

  /// `Receive`
  String get receive {
    return Intl.message(
      'Receive',
      name: 'receive',
      desc: '',
      args: [],
    );
  }

  /// `Received`
  String get received {
    return Intl.message(
      'Received',
      name: 'received',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Rename`
  String get rename {
    return Intl.message(
      'Rename',
      name: 'rename',
      desc: '',
      args: [],
    );
  }

  /// `Renew your Premium`
  String get renewPremium {
    return Intl.message(
      'Renew your Premium',
      name: 'renewPremium',
      desc: '',
      args: [],
    );
  }

  /// `Renew your PRO`
  String get renewPro {
    return Intl.message(
      'Renew your PRO',
      name: 'renewPro',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Password`
  String get repeatPassword {
    return Intl.message(
      'Repeat Password',
      name: 'repeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Repeat PIN-code.`
  String get repeatPin {
    return Intl.message(
      'Repeat PIN-code.',
      name: 'repeatPin',
      desc: '',
      args: [],
    );
  }

  /// `Restore Wallet`
  String get restoreWallet {
    return Intl.message(
      'Restore Wallet',
      name: 'restoreWallet',
      desc: '',
      args: [],
    );
  }

  /// `Scan new QR`
  String get scanNewQR {
    return Intl.message(
      'Scan new QR',
      name: 'scanNewQR',
      desc: '',
      args: [],
    );
  }

  /// `Security Center`
  String get securityCenter {
    return Intl.message(
      'Security Center',
      name: 'securityCenter',
      desc: '',
      args: [],
    );
  }

  /// `Sell`
  String get sell {
    return Intl.message(
      'Sell',
      name: 'sell',
      desc: '',
      args: [],
    );
  }

  /// `Sell {token}`
  String sellToken(Object token) {
    return Intl.message(
      'Sell $token',
      name: 'sellToken',
      desc: '',
      args: [token],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Sent`
  String get sent {
    return Intl.message(
      'Sent',
      name: 'sent',
      desc: '',
      args: [],
    );
  }

  /// `Service is temporarily unavailable`
  String get serviceUnavailable {
    return Intl.message(
      'Service is temporarily unavailable',
      name: 'serviceUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Show`
  String get show {
    return Intl.message(
      'Show',
      name: 'show',
      desc: '',
      args: [],
    );
  }

  /// `Show transactions`
  String get showTransactions {
    return Intl.message(
      'Show transactions',
      name: 'showTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Show Serial key`
  String get showVpnKey {
    return Intl.message(
      'Show Serial key',
      name: 'showVpnKey',
      desc: '',
      args: [],
    );
  }

  /// `6 digits required.`
  String get sixDigitsNeeded {
    return Intl.message(
      '6 digits required.',
      name: 'sixDigitsNeeded',
      desc: '',
      args: [],
    );
  }

  /// `Smart Card`
  String get smartCard {
    return Intl.message(
      'Smart Card',
      name: 'smartCard',
      desc: '',
      args: [],
    );
  }

  /// `A smart card is designed to safely store your funds.`
  String get smartCardMarketText1 {
    return Intl.message(
      'A smart card is designed to safely store your funds.',
      name: 'smartCardMarketText1',
      desc: '',
      args: [],
    );
  }

  /// `To access the wallet, the smart card must be attached to the back of the phone with NFC.`
  String get smartCardMarketText2 {
    return Intl.message(
      'To access the wallet, the smart card must be attached to the back of the phone with NFC.',
      name: 'smartCardMarketText2',
      desc: '',
      args: [],
    );
  }

  /// `The card provides two-factor authorization.`
  String get smartCardMarketText3 {
    return Intl.message(
      'The card provides two-factor authorization.',
      name: 'smartCardMarketText3',
      desc: '',
      args: [],
    );
  }

  /// `When you order a card, you will be credited 13 TBCC.`
  String get smartCardMarketText4 {
    return Intl.message(
      'When you order a card, you will be credited 13 TBCC.',
      name: 'smartCardMarketText4',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations! You have ordered a smart card.`
  String get smartCardOrdered {
    return Intl.message(
      'Congratulations! You have ordered a smart card.',
      name: 'smartCardOrdered',
      desc: '',
      args: [],
    );
  }

  /// `Smart Contract call`
  String get smartContractCall {
    return Intl.message(
      'Smart Contract call',
      name: 'smartContractCall',
      desc: '',
      args: [],
    );
  }

  /// `Let's start`
  String get start {
    return Intl.message(
      'Let\'s start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `TBCC Wallet - blockchain\nwallet for everyone`
  String get startupText0 {
    return Intl.message(
      'TBCC Wallet - blockchain\nwallet for everyone',
      name: 'startupText0',
      desc: '',
      args: [],
    );
  }

  /// `Buy, store, send, exchange your cryptocurrency with an easy-to-use and convinient wallet`
  String get startupText1 {
    return Intl.message(
      'Buy, store, send, exchange your cryptocurrency with an easy-to-use and convinient wallet',
      name: 'startupText1',
      desc: '',
      args: [],
    );
  }

  /// `Subscription expires`
  String get subExpires {
    return Intl.message(
      'Subscription expires',
      name: 'subExpires',
      desc: '',
      args: [],
    );
  }

  /// `Subscription expires {date}`
  String subExpiresDate(Object date) {
    return Intl.message(
      'Subscription expires $date',
      name: 'subExpiresDate',
      desc: '',
      args: [date],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Support Center`
  String get supportCenter {
    return Intl.message(
      'Support Center',
      name: 'supportCenter',
      desc: '',
      args: [],
    );
  }

  /// `Swap`
  String get swap {
    return Intl.message(
      'Swap',
      name: 'swap',
      desc: '',
      args: [],
    );
  }

  /// `Swap TBCC(BEP2) with TBCC(BEP8)`
  String get swapBep2 {
    return Intl.message(
      'Swap TBCC(BEP2) with TBCC(BEP8)',
      name: 'swapBep2',
      desc: '',
      args: [],
    );
  }

  /// `Swap TBCC(BEP8) with TBCC(BEP2)`
  String get swapBep8 {
    return Intl.message(
      'Swap TBCC(BEP8) with TBCC(BEP2)',
      name: 'swapBep8',
      desc: '',
      args: [],
    );
  }

  /// `The swap request was sent successfully. If successful, funds will be credited within 5-10 minutes.`
  String get swapStandardSent {
    return Intl.message(
      'The swap request was sent successfully. If successful, funds will be credited within 5-10 minutes.',
      name: 'swapStandardSent',
      desc: '',
      args: [],
    );
  }

  /// `Swap to {to}`
  String swapTo(Object to) {
    return Intl.message(
      'Swap to $to',
      name: 'swapTo',
      desc: '',
      args: [to],
    );
  }

  /// `Target`
  String get target {
    return Intl.message(
      'Target',
      name: 'target',
      desc: '',
      args: [],
    );
  }

  /// `TBCC team launches Binance-powered trading platform - TBCC.COM\nThe developers of the digital asset-oriented trading platform TBCC.COM announced its launch and active implementation of tasks within the framework of the road map.\nA large community has already formed around the exchange. Crypto community members were attracted by the large pool of liquidity TBCC.COM, as well as the listing of the trading platform with coins for staking and pharming for every taste.\nThe project team presented the author's trading training system. Also, beginners can gain knowledge through communication with experienced users in the TBCC.COM community. Among the additional advantages of the trading platform, one can single out the operational support service and the presence of the author's trading signal system.\nThe project is built on the basis of Binance CLOUD technical solutions, which were presented by the Binance crypto exchange team in February 2020. The tools helped the developers create a high-tech, secure trading platform TBCC.COM.\nBinance CLOUD technical solutions allow you to launch crypto exchanges in accordance with the standards of Binance - one of the most popular platforms for trading digital assets, the market leader in terms of total trading volume, according to the CoinMarketCap resource.\n\nDownload TBCC Exchange mobile app:`
  String get tbcc_exchange {
    return Intl.message(
      'TBCC team launches Binance-powered trading platform - TBCC.COM\nThe developers of the digital asset-oriented trading platform TBCC.COM announced its launch and active implementation of tasks within the framework of the road map.\nA large community has already formed around the exchange. Crypto community members were attracted by the large pool of liquidity TBCC.COM, as well as the listing of the trading platform with coins for staking and pharming for every taste.\nThe project team presented the author\'s trading training system. Also, beginners can gain knowledge through communication with experienced users in the TBCC.COM community. Among the additional advantages of the trading platform, one can single out the operational support service and the presence of the author\'s trading signal system.\nThe project is built on the basis of Binance CLOUD technical solutions, which were presented by the Binance crypto exchange team in February 2020. The tools helped the developers create a high-tech, secure trading platform TBCC.COM.\nBinance CLOUD technical solutions allow you to launch crypto exchanges in accordance with the standards of Binance - one of the most popular platforms for trading digital assets, the market leader in terms of total trading volume, according to the CoinMarketCap resource.\n\nDownload TBCC Exchange mobile app:',
      name: 'tbcc_exchange',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `To pay`
  String get toPay {
    return Intl.message(
      'To pay',
      name: 'toPay',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Total Fund balance`
  String get totalFundBal {
    return Intl.message(
      'Total Fund balance',
      name: 'totalFundBal',
      desc: '',
      args: [],
    );
  }

  /// `Transactions`
  String get transactions {
    return Intl.message(
      'Transactions',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `Transaction sent to processing. Will appear in the history soon.`
  String get transferSuccessText {
    return Intl.message(
      'Transaction sent to processing. Will appear in the history soon.',
      name: 'transferSuccessText',
      desc: '',
      args: [],
    );
  }

  /// `Please try again.`
  String get tryAgain {
    return Intl.message(
      'Please try again.',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Transaction time`
  String get txTime {
    return Intl.message(
      'Transaction time',
      name: 'txTime',
      desc: '',
      args: [],
    );
  }

  /// `Type correct amount!`
  String get typeCorrectAmount {
    return Intl.message(
      'Type correct amount!',
      name: 'typeCorrectAmount',
      desc: '',
      args: [],
    );
  }

  /// `Type correct price!`
  String get typeCorrectPrice {
    return Intl.message(
      'Type correct price!',
      name: 'typeCorrectPrice',
      desc: '',
      args: [],
    );
  }

  /// `Update available`
  String get updateAvailable {
    return Intl.message(
      'Update available',
      name: 'updateAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Downloading...`
  String get updateDownloading {
    return Intl.message(
      'Downloading...',
      name: 'updateDownloading',
      desc: '',
      args: [],
    );
  }

  /// `Update downloaded`
  String get updateDownlodaded {
    return Intl.message(
      'Update downloaded',
      name: 'updateDownlodaded',
      desc: '',
      args: [],
    );
  }

  /// `Use biometrics`
  String get useBiometrics {
    return Intl.message(
      'Use biometrics',
      name: 'useBiometrics',
      desc: '',
      args: [],
    );
  }

  /// `Used funds`
  String get usedFunds {
    return Intl.message(
      'Used funds',
      name: 'usedFunds',
      desc: '',
      args: [],
    );
  }

  /// `Tap the words from your secret key`
  String get verifyMnemonic {
    return Intl.message(
      'Tap the words from your secret key',
      name: 'verifyMnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Vote`
  String get vote {
    return Intl.message(
      'Vote',
      name: 'vote',
      desc: '',
      args: [],
    );
  }

  /// `Voting`
  String get voting {
    return Intl.message(
      'Voting',
      name: 'voting',
      desc: '',
      args: [],
    );
  }

  /// `Try the first decentralized blockchain-based VPN. Even a supercomputer will not get an acсessto your data.`
  String get vpnDescription {
    return Intl.message(
      'Try the first decentralized blockchain-based VPN. Even a supercomputer will not get an acсessto your data.',
      name: 'vpnDescription',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for confirmation`
  String get waitingConfirmation {
    return Intl.message(
      'Waiting for confirmation',
      name: 'waitingConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get wallet {
    return Intl.message(
      'Wallet',
      name: 'wallet',
      desc: '',
      args: [],
    );
  }

  /// `Want to buy`
  String get wantToBuy {
    return Intl.message(
      'Want to buy',
      name: 'wantToBuy',
      desc: '',
      args: [],
    );
  }

  /// `Want to swap`
  String get wantToSwap {
    return Intl.message(
      'Want to swap',
      name: 'wantToSwap',
      desc: '',
      args: [],
    );
  }

  /// `What's new`
  String get whatsNew {
    return Intl.message(
      'What\'s new',
      name: 'whatsNew',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get withdraw {
    return Intl.message(
      'Withdraw',
      name: 'withdraw',
      desc: '',
      args: [],
    );
  }

  /// `Write smart card`
  String get writeSmartCard {
    return Intl.message(
      'Write smart card',
      name: 'writeSmartCard',
      desc: '',
      args: [],
    );
  }

  /// `Wrong address`
  String get wrongAddr {
    return Intl.message(
      'Wrong address',
      name: 'wrongAddr',
      desc: '',
      args: [],
    );
  }

  /// `Wrong PIN`
  String get wrongPin {
    return Intl.message(
      'Wrong PIN',
      name: 'wrongPin',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully attached your smart card.`
  String get youAttachedCard {
    return Intl.message(
      'You have successfully attached your smart card.',
      name: 'youAttachedCard',
      desc: '',
      args: [],
    );
  }

  /// `You pay`
  String get youPay {
    return Intl.message(
      'You pay',
      name: 'youPay',
      desc: '',
      args: [],
    );
  }

  /// `You {type} now`
  String youProNow(Object type) {
    return Intl.message(
      'You $type now',
      name: 'youProNow',
      desc: '',
      args: [type],
    );
  }

  /// `You receive`
  String get youReceive {
    return Intl.message(
      'You receive',
      name: 'youReceive',
      desc: '',
      args: [],
    );
  }

  /// `Your balance`
  String get yourBalance {
    return Intl.message(
      'Your balance',
      name: 'yourBalance',
      desc: '',
      args: [],
    );
  }

  /// `Check`
  String get check {
    return Intl.message(
      'Check',
      name: 'check',
      desc: '',
      args: [],
    );
  }

  /// `Cancle`
  String get cancle {
    return Intl.message(
      'Cancle',
      name: 'cancle',
      desc: '',
      args: [],
    );
  }

  /// `Fingerprint Authentication`
  String get fingerprintAuthentication {
    return Intl.message(
      'Fingerprint Authentication',
      name: 'fingerprintAuthentication',
      desc: '',
      args: [],
    );
  }

  /// `Face Detection`
  String get faceDetection {
    return Intl.message(
      'Face Detection',
      name: 'faceDetection',
      desc: '',
      args: [],
    );
  }

  /// `Look at Camera`
  String get lookCamera {
    return Intl.message(
      'Look at Camera',
      name: 'lookCamera',
      desc: '',
      args: [],
    );
  }

  /// `Touch Sensor`
  String get touchSensor {
    return Intl.message(
      'Touch Sensor',
      name: 'touchSensor',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
