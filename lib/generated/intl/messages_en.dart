// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(amount) => "Amount should be ≥${amount}";

  static String m1(token) => "Amount ${token}";

  static String m2(token) => "Available actions with ${token}";

  static String m3(type) => "Become ${type}";

  static String m4(token) => "Buy ${token}";

  static String m5(some) => "${some} Copied to clipboard";

  static String m6(type) => "Get access with ${type}";

  static String m7(type) => "Get OTC with ${type}";

  static String m8(type) => "Go ${type}";

  static String m9(cnt) => "There are ${cnt} codes left for this ID";

  static String m10(end, result) =>
      "The lottery will last until ${end} and the results of the lottery will be announced on ${result}";

  static String m11(startend, result) =>
      "Dates: ticket sales from ${startend}, counting will be made ${result}";

  static String m12(date) =>
      "Announcement of the lottery results and payment of winnings on ${date}";

  static String m13(price) =>
      "3. The cost of one ticket is ${price} TBCC (BEP20).";

  static String m14(token) => "Not enough ${token} to pay fee";

  static String m15(token) => "Price ${token}";

  static String m16(type) =>
      "Get access to more features and more savings with TBCC Wallet ${type}";

  static String m17(price) => "Get full access for ${price}";

  static String m18(price) => "Get access for ${price}";

  static String m19(type) => "Purchase ${type}";

  static String m20(token) => "Sell ${token}";

  static String m21(date) => "Subscription expires ${date}";

  static String m22(to) => "Swap to ${to}";

  static String m23(token) => "${token} Price";

  static String m24(type) => "You ${type} now";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutTbcc": MessageLookupByLibrary.simpleMessage("About TBCC"),
        "accessToVpn":
            MessageLookupByLibrary.simpleMessage("Access to TBCC VPN"),
        "accountExists": MessageLookupByLibrary.simpleMessage(
            "Such account is already added"),
        "accounts": MessageLookupByLibrary.simpleMessage("Accounts"),
        "actions": MessageLookupByLibrary.simpleMessage("Actions"),
        "addAddress": MessageLookupByLibrary.simpleMessage("Add address"),
        "addChange": MessageLookupByLibrary.simpleMessage("Add a new card"),
        "addWallet": MessageLookupByLibrary.simpleMessage("Add Wallet"),
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "addressBook": MessageLookupByLibrary.simpleMessage("Address book"),
        "addressOfRecipient":
            MessageLookupByLibrary.simpleMessage("Address of the recipient"),
        "advanced": MessageLookupByLibrary.simpleMessage("Advanced"),
        "all": MessageLookupByLibrary.simpleMessage("All"),
        "allFeatures": MessageLookupByLibrary.simpleMessage("All features"),
        "amount": MessageLookupByLibrary.simpleMessage("Amount"),
        "amountMoreThan": m0,
        "amountToken": m1,
        "annually": MessageLookupByLibrary.simpleMessage("Annually"),
        "attachCardText1": MessageLookupByLibrary.simpleMessage(
            "If you attach your smart card, you will be able to enter account ONLY with card!"),
        "attachCardText2": MessageLookupByLibrary.simpleMessage(
            "Before attaching smart card we are recommending to make sure that you have saved your mnemonic passphrase in solid/safe place so that if you lose your smart card, you can restore your account. "),
        "attachSmartCard":
            MessageLookupByLibrary.simpleMessage("Attach smart card"),
        "attachYourCard": MessageLookupByLibrary.simpleMessage(
            "Attach your NFC crad to the back of your phone."),
        "attachingSmartCard":
            MessageLookupByLibrary.simpleMessage("Smart card attachment"),
        "attention": MessageLookupByLibrary.simpleMessage("Attention!"),
        "availableActions": m2,
        "awailableToSwap":
            MessageLookupByLibrary.simpleMessage("Available for swap:"),
        "backup": MessageLookupByLibrary.simpleMessage("Restore"),
        "balance": MessageLookupByLibrary.simpleMessage("Balance"),
        "becomePro": m3,
        "benefitPaymentsInfo": MessageLookupByLibrary.simpleMessage(
            "Payments will be made 10 days after the end of receiving funds."),
        "bestAsk": MessageLookupByLibrary.simpleMessage("Best Ask"),
        "bestBid": MessageLookupByLibrary.simpleMessage("Best Bid"),
        "binancePK":
            MessageLookupByLibrary.simpleMessage("BinanceChain PrivateKey"),
        "biometrics": MessageLookupByLibrary.simpleMessage("Biometrics"),
        "biometricsEnableAsk":
            MessageLookupByLibrary.simpleMessage("Enable biometric unlock?"),
        "biometricsText": MessageLookupByLibrary.simpleMessage(
            "You can enable Fingerprint / Face ID instead of using the password to log in"),
        "biometricsUnavailable": MessageLookupByLibrary.simpleMessage(
            "Your device does not support biometric authentication"),
        "buy": MessageLookupByLibrary.simpleMessage("Buy"),
        "buyInAdd": MessageLookupByLibrary.simpleMessage("Buy"),
        "buyOrSwap": MessageLookupByLibrary.simpleMessage("Buy or swap"),
        "buyToken": m4,
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "canceled": MessageLookupByLibrary.simpleMessage("Canceled"),
        "cancle": MessageLookupByLibrary.simpleMessage("Cancle"),
        "candlestickChart":
            MessageLookupByLibrary.simpleMessage("Candlestick chart"),
        "cantBeEmpty": MessageLookupByLibrary.simpleMessage("Can\'t be empty"),
        "cardAttachedYet": MessageLookupByLibrary.simpleMessage(
            "The card has been already attached to one of the accounts"),
        "cardNotOrderedYet": MessageLookupByLibrary.simpleMessage(
            "You have not ordered a smart card yet"),
        "cardPinText1": MessageLookupByLibrary.simpleMessage(
            "Enter 6-digit PIN-code for your card."),
        "cardPinText2": MessageLookupByLibrary.simpleMessage(
            "When entering account using a card, you will need to enter this PIN-code."),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Change Password"),
        "chart": MessageLookupByLibrary.simpleMessage("Chart"),
        "check": MessageLookupByLibrary.simpleMessage("Check"),
        "checkInternet": MessageLookupByLibrary.simpleMessage(
            "Check Your Internet connection"),
        "checkSavedMnemonicAll": MessageLookupByLibrary.simpleMessage(
            "Check if mnemonic phrases are saved from your wallets"),
        "checkSavedMnemonicSingle": MessageLookupByLibrary.simpleMessage(
            "Check if the mnemonic phrase is saved from this wallet"),
        "checkingIntegrity":
            MessageLookupByLibrary.simpleMessage("File integrity check..."),
        "chooseWallet": MessageLookupByLibrary.simpleMessage("Choose a wallet"),
        "clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "clearCache": MessageLookupByLibrary.simpleMessage("Clear cache"),
        "closedOrders": MessageLookupByLibrary.simpleMessage("Closed"),
        "cloudDialogDescription": MessageLookupByLibrary.simpleMessage(
            "Customers who have activated PRO accounts will be given priority to enter the Binance Cloud exchange, and soon you will be able to trade on TBCC & Binance exchange. We wish you happiness and success in the new year!"),
        "cloudVoteDesc": MessageLookupByLibrary.simpleMessage(
            "You can trade cryptocurrency anywhere in the world and at any time using our exchange. Our easy-to-use interface will help you make your cryptocurrency experience as convenient as possible. Our exchange will operate on the Binance Cloud and offer its users one of the largest liquidity pools in the world. Trade the world\'s leading digital assets!"),
        "coin": MessageLookupByLibrary.simpleMessage("Coin"),
        "community": MessageLookupByLibrary.simpleMessage("Community"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmAction": MessageLookupByLibrary.simpleMessage("Confirm action"),
        "confirmPhrase1":
            MessageLookupByLibrary.simpleMessage("I confirm my consent to the"),
        "confirmPhrase2":
            MessageLookupByLibrary.simpleMessage("terms of the user agreement"),
        "confirmSwap": MessageLookupByLibrary.simpleMessage("Confirm swap"),
        "confirmTransfer":
            MessageLookupByLibrary.simpleMessage("Confrim transfer"),
        "confirmations": MessageLookupByLibrary.simpleMessage("Confirmations"),
        "continue_": MessageLookupByLibrary.simpleMessage("Continue"),
        "copiedToClipboard": m5,
        "copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "createWallet":
            MessageLookupByLibrary.simpleMessage("Create new wallet"),
        "currency": MessageLookupByLibrary.simpleMessage("Currency"),
        "currentPrice": MessageLookupByLibrary.simpleMessage("Current price"),
        "currentSession":
            MessageLookupByLibrary.simpleMessage("Current session"),
        "currentStatus":
            MessageLookupByLibrary.simpleMessage("Current status:"),
        "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
        "details": MessageLookupByLibrary.simpleMessage("Details"),
        "disable": MessageLookupByLibrary.simpleMessage("Disable"),
        "disconnect": MessageLookupByLibrary.simpleMessage("Disconnect"),
        "download": MessageLookupByLibrary.simpleMessage("Download"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "emailSupport": MessageLookupByLibrary.simpleMessage("Email Support"),
        "enable": MessageLookupByLibrary.simpleMessage("Enable"),
        "endInvestDate": MessageLookupByLibrary.simpleMessage(
            "End date for accepting funds:"),
        "enterPin": MessageLookupByLibrary.simpleMessage("Enter PIN-code"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "ethereumPK":
            MessageLookupByLibrary.simpleMessage("Ethereum PrivateKey"),
        "exchange": MessageLookupByLibrary.simpleMessage("Exchange"),
        "faceDetection": MessageLookupByLibrary.simpleMessage("Face Detection"),
        "fast": MessageLookupByLibrary.simpleMessage("Fast"),
        "fee": MessageLookupByLibrary.simpleMessage("Fee"),
        "fileDamaged": MessageLookupByLibrary.simpleMessage(
            "The file is damaged. Try it again"),
        "fingerprint": MessageLookupByLibrary.simpleMessage("Fingerprint"),
        "fingerprintAuthentication":
            MessageLookupByLibrary.simpleMessage("Fingerprint Authentication"),
        "forceUpdate": MessageLookupByLibrary.simpleMessage(
            "An important app update is available. To continue, you need to download and install it."),
        "from": MessageLookupByLibrary.simpleMessage("From"),
        "gasLimit": MessageLookupByLibrary.simpleMessage("Gas Limit"),
        "gasPrice": MessageLookupByLibrary.simpleMessage("Gas Price"),
        "getAccessWithPro": m6,
        "getOTCWithPro": m7,
        "goBack": MessageLookupByLibrary.simpleMessage("Go back"),
        "goForward": MessageLookupByLibrary.simpleMessage("Go forward"),
        "goPro": m8,
        "goToWebsite": MessageLookupByLibrary.simpleMessage("Go to Website"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "iUnderstood": MessageLookupByLibrary.simpleMessage("I understood"),
        "incorrectPassword":
            MessageLookupByLibrary.simpleMessage("Incorrect Password"),
        "insertPromoCode": MessageLookupByLibrary.simpleMessage(
            "Paste promocode (if you have)"),
        "installUpdate": MessageLookupByLibrary.simpleMessage("Install"),
        "invalidMnemonic":
            MessageLookupByLibrary.simpleMessage("Invalid Mnemonic"),
        "invalidOrder": MessageLookupByLibrary.simpleMessage("Wrong order"),
        "invest": MessageLookupByLibrary.simpleMessage("Invest"),
        "investAttention": MessageLookupByLibrary.simpleMessage(
            "It is possible to invest once from one account. You have the ability to create up to 5 accounts on one device. Interest is paid in TBCC bep2 tokens. Users who vote will receive an additional 0.5%."),
        "investment": MessageLookupByLibrary.simpleMessage("Investments"),
        "joinCommunity": MessageLookupByLibrary.simpleMessage("Join Community"),
        "jump_boughtCodes":
            MessageLookupByLibrary.simpleMessage("Bought codes"),
        "jump_buyLives":
            MessageLookupByLibrary.simpleMessage("Buy lives TBCC Jump"),
        "jump_codesLeft": m9,
        "jump_writeID":
            MessageLookupByLibrary.simpleMessage("Write your in-game ID"),
        "knowledgeBase": MessageLookupByLibrary.simpleMessage("Knowledge Base"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "logIn": MessageLookupByLibrary.simpleMessage("Log In"),
        "logInWithCard":
            MessageLookupByLibrary.simpleMessage("Log in with a smart card."),
        "logOut": MessageLookupByLibrary.simpleMessage("Log out"),
        "logOutAllQuestion":
            MessageLookupByLibrary.simpleMessage("Log out of all accounts?"),
        "logOutQuestion": MessageLookupByLibrary.simpleMessage("Log out?"),
        "lookCamera": MessageLookupByLibrary.simpleMessage("Look at Camera"),
        "lottery": MessageLookupByLibrary.simpleMessage("TBCC Lottery"),
        "lotteryAccept": MessageLookupByLibrary.simpleMessage("Buy Ticket"),
        "lotteryAccepted":
            MessageLookupByLibrary.simpleMessage("Bought Tickets:"),
        "lotteryDesc1": MessageLookupByLibrary.simpleMessage(
            "Take part in the lottery and get a chance to win prize!"),
        "lotteryDesc2": m10,
        "lotteryDesc3": m11,
        "lotteryDesc4": m12,
        "lotteryRule1": MessageLookupByLibrary.simpleMessage(
            "1. An unlimited number of addresses can participate in the lottery."),
        "lotteryRule2": MessageLookupByLibrary.simpleMessage(
            "2. By buying tickets, you increase your chances of winning the lottery."),
        "lotteryRule3": m13,
        "lotteryRule4": MessageLookupByLibrary.simpleMessage(
            "4. The lottery can only be accepted by owners of PRO and PREMIUM accounts"),
        "lotteryWinners":
            MessageLookupByLibrary.simpleMessage("List of winners"),
        "lotteryWinnersDesc1": MessageLookupByLibrary.simpleMessage(
            "If you are on the list of winners, then your account address will be highlighted in the list below"),
        "lotteryWinnersDesc2": MessageLookupByLibrary.simpleMessage(
            "All winners will automatically receive TBCC tokens as a prize."),
        "market": MessageLookupByLibrary.simpleMessage("Market"),
        "marketDepth": MessageLookupByLibrary.simpleMessage("Market Depth"),
        "marketPairs": MessageLookupByLibrary.simpleMessage("Pairs"),
        "memoInfoDialogHeader": MessageLookupByLibrary.simpleMessage(
            "Send funds indicating the purpose of payment?"),
        "memoInfoDialogText": MessageLookupByLibrary.simpleMessage(
            "Leave the field blank if not required by the recipient"),
        "mnemonicDescription1": MessageLookupByLibrary.simpleMessage("You see"),
        "mnemonicDescription2":
            MessageLookupByLibrary.simpleMessage("12 words"),
        "mnemonicDescription3": MessageLookupByLibrary.simpleMessage(
            "that will allow you to restore the wallet"),
        "mnemonicDescription4": MessageLookupByLibrary.simpleMessage(
            "Store them in a safe place and keep them secret."),
        "mnemonicPhrase":
            MessageLookupByLibrary.simpleMessage("Mnemonic Phrase"),
        "mnemonicWarning": MessageLookupByLibrary.simpleMessage(
            "I understand that if I lose my passphrase I will lose access to my wallet"),
        "mnemonicWrite": MessageLookupByLibrary.simpleMessage(
            "Write words from your mnemonic phrase"),
        "mobileOsVoteDesc": MessageLookupByLibrary.simpleMessage(
            "TBCC started developing its own operating system for mobile phones. The alpha version of the system is already being tested by our specialists. All TBCC products will be directly on the mobile device. Keeping cyptocurrency will become even safer. Our own infrastructure will ensure high availability. TBCC is getting stronger every day!"),
        "multiWallet": MessageLookupByLibrary.simpleMessage("Multi-wallet"),
        "myOrders": MessageLookupByLibrary.simpleMessage("My Orders"),
        "myVpnKeys": MessageLookupByLibrary.simpleMessage("My VPN keys"),
        "networkFee": MessageLookupByLibrary.simpleMessage("Network Fee"),
        "newAccountName":
            MessageLookupByLibrary.simpleMessage("New account name"),
        "news": MessageLookupByLibrary.simpleMessage("News"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "nfcUnavailable": MessageLookupByLibrary.simpleMessage(
            "NFC is off or not avaliable. Please, check if the NFC module is enabled."),
        "nft": MessageLookupByLibrary.simpleMessage("NFT"),
        "noActions":
            MessageLookupByLibrary.simpleMessage("No actions available"),
        "noClosedOrders":
            MessageLookupByLibrary.simpleMessage("No closed orders yet"),
        "noOpenOrders":
            MessageLookupByLibrary.simpleMessage("No open orders yet"),
        "noTransactions": MessageLookupByLibrary.simpleMessage(
            "No transactions at the moment"),
        "noValidAddrFound":
            MessageLookupByLibrary.simpleMessage("No valid address found"),
        "noValidMnemonic": MessageLookupByLibrary.simpleMessage(
            "No valid mnemonic phrase found"),
        "notEnoughTokens":
            MessageLookupByLibrary.simpleMessage("Not enough tokens"),
        "notEnoughTokensFee": m14,
        "oneTimePayment": MessageLookupByLibrary.simpleMessage("One-time"),
        "openOrders": MessageLookupByLibrary.simpleMessage("Open"),
        "optional": MessageLookupByLibrary.simpleMessage("Optional"),
        "orderBook": MessageLookupByLibrary.simpleMessage("Order Book"),
        "orderFinishTime": MessageLookupByLibrary.simpleMessage("Finish"),
        "orderPlaced":
            MessageLookupByLibrary.simpleMessage("Order placed successfully"),
        "orderSmartCard":
            MessageLookupByLibrary.simpleMessage("Order Smart Card"),
        "orderSmartCardConfirmation": MessageLookupByLibrary.simpleMessage(
            "Do you confirm the order of a smart card?"),
        "orderStartTime": MessageLookupByLibrary.simpleMessage("Start"),
        "orderType": MessageLookupByLibrary.simpleMessage("Type"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordDoNotMatch":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "passwordInfo": MessageLookupByLibrary.simpleMessage(
            "This password will be used to unlock your wallet & use cryptocurrency"),
        "passwordSymbolAmount": MessageLookupByLibrary.simpleMessage(
            "Password need at least 8 symbols"),
        "paste": MessageLookupByLibrary.simpleMessage("Paste"),
        "pinCodesNotMatch":
            MessageLookupByLibrary.simpleMessage("PIN-codes do not match"),
        "premDiscount": MessageLookupByLibrary.simpleMessage(
            "10% discount on renewing your Premium account"),
        "price": MessageLookupByLibrary.simpleMessage("Price"),
        "priceToken": m15,
        "privateKeys": MessageLookupByLibrary.simpleMessage("Private Keys"),
        "proDesc0": m16,
        "proDesc1": m17,
        "proDesc12": m18,
        "proDesc2": MessageLookupByLibrary.simpleMessage(
            "These are accounts that are created by one user. Convenient switching between accounts. It will be possible to create up to 3 accounts on one device."),
        "proDesc2h": MessageLookupByLibrary.simpleMessage("Multi-account"),
        "proDesc3": MessageLookupByLibrary.simpleMessage(
            "For the conclusion of OTC transactions, you do not need to reserve funds on the eve of trading, since the participants in transactions are settled directly. As a rule, OTC transactions are concluded with deferred settlements."),
        "proDesc3h": MessageLookupByLibrary.simpleMessage("OTC transactions"),
        "proDesc4": MessageLookupByLibrary.simpleMessage(
            "Pay less for transactions and cryptocurrency exchanges. All transactions will take place at the lowest prices."),
        "proDesc4h":
            MessageLookupByLibrary.simpleMessage("Reduced commissions"),
        "proDesc5": MessageLookupByLibrary.simpleMessage(
            "Get the latest updates from the very first. New technologies will be immediately in your wallet."),
        "proDesc5h": MessageLookupByLibrary.simpleMessage("Latest news"),
        "proDesc6": MessageLookupByLibrary.simpleMessage(
            "We will answer any of your questions. We will help you solve any of your problems."),
        "proDesc6h": MessageLookupByLibrary.simpleMessage(
            "Individual technical support"),
        "proDiscount": MessageLookupByLibrary.simpleMessage(
            "15% discount on renewing your PRO account"),
        "proVpnDialog": MessageLookupByLibrary.simpleMessage(
            "Congratulations, you got a three month free VPN trial."),
        "purchaseDate":
            MessageLookupByLibrary.simpleMessage("Date of purchase"),
        "purchasePro": m19,
        "purchaseVpn": MessageLookupByLibrary.simpleMessage("Buy VPN"),
        "purchased": MessageLookupByLibrary.simpleMessage("Purchased"),
        "receive": MessageLookupByLibrary.simpleMessage("Receive"),
        "received": MessageLookupByLibrary.simpleMessage("Received"),
        "recommended": MessageLookupByLibrary.simpleMessage("Recommended"),
        "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
        "reload": MessageLookupByLibrary.simpleMessage("Reload"),
        "rename": MessageLookupByLibrary.simpleMessage("Rename"),
        "renewPremium":
            MessageLookupByLibrary.simpleMessage("Renew your Premium"),
        "renewPro": MessageLookupByLibrary.simpleMessage("Renew your PRO"),
        "repeatPassword":
            MessageLookupByLibrary.simpleMessage("Repeat Password"),
        "repeatPin": MessageLookupByLibrary.simpleMessage("Repeat PIN-code."),
        "restoreWallet": MessageLookupByLibrary.simpleMessage("Restore Wallet"),
        "scanNewQR": MessageLookupByLibrary.simpleMessage("Scan new QR"),
        "securityCenter":
            MessageLookupByLibrary.simpleMessage("Security Center"),
        "sell": MessageLookupByLibrary.simpleMessage("Sell"),
        "sellToken": m20,
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "sent": MessageLookupByLibrary.simpleMessage("Sent"),
        "serviceUnavailable": MessageLookupByLibrary.simpleMessage(
            "Service is temporarily unavailable"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "share": MessageLookupByLibrary.simpleMessage("Share"),
        "show": MessageLookupByLibrary.simpleMessage("Show"),
        "showTransactions":
            MessageLookupByLibrary.simpleMessage("Show transactions"),
        "showVpnKey": MessageLookupByLibrary.simpleMessage("Show Serial key"),
        "signTx": MessageLookupByLibrary.simpleMessage("Sign the transaction"),
        "sixDigitsNeeded":
            MessageLookupByLibrary.simpleMessage("6 digits required."),
        "slow": MessageLookupByLibrary.simpleMessage("Slow"),
        "smartCard": MessageLookupByLibrary.simpleMessage("Smart Card"),
        "smartCardMarketText1": MessageLookupByLibrary.simpleMessage(
            "A smart card is designed to safely store your funds."),
        "smartCardMarketText2": MessageLookupByLibrary.simpleMessage(
            "To access the wallet, the smart card must be attached to the back of the phone with NFC."),
        "smartCardMarketText3": MessageLookupByLibrary.simpleMessage(
            "The card provides two-factor authorization."),
        "smartCardMarketText4": MessageLookupByLibrary.simpleMessage(
            "When you order a card, you will be credited 13 TBCC."),
        "smartCardOrdered": MessageLookupByLibrary.simpleMessage(
            "Congratulations! You have ordered a smart card."),
        "smartContractCall":
            MessageLookupByLibrary.simpleMessage("Smart Contract call"),
        "start": MessageLookupByLibrary.simpleMessage("Let\'s start"),
        "startupText0": MessageLookupByLibrary.simpleMessage(
            "TBCC Wallet - blockchain\nwallet for everyone"),
        "startupText1": MessageLookupByLibrary.simpleMessage(
            "Buy, store, send, exchange your cryptocurrency with an easy-to-use and convinient wallet"),
        "subExpires":
            MessageLookupByLibrary.simpleMessage("Subscription expires"),
        "subExpiresDate": m21,
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "supportCenter": MessageLookupByLibrary.simpleMessage("Support Center"),
        "swap": MessageLookupByLibrary.simpleMessage("Swap"),
        "swapBep2": MessageLookupByLibrary.simpleMessage(
            "Swap TBCC(BEP2) with TBCC(BEP8)"),
        "swapBep8": MessageLookupByLibrary.simpleMessage(
            "Swap TBCC(BEP8) with TBCC(BEP2)"),
        "swapStandardSent": MessageLookupByLibrary.simpleMessage(
            "The swap request was sent successfully. If successful, funds will be credited within 5-10 minutes."),
        "swapTo": m22,
        "target": MessageLookupByLibrary.simpleMessage("Target"),
        "tbcc_exchange": MessageLookupByLibrary.simpleMessage(
            "TBCC team launches Binance-powered trading platform - TBCC.COM\nThe developers of the digital asset-oriented trading platform TBCC.COM announced its launch and active implementation of tasks within the framework of the road map.\nA large community has already formed around the exchange. Crypto community members were attracted by the large pool of liquidity TBCC.COM, as well as the listing of the trading platform with coins for staking and pharming for every taste.\nThe project team presented the author\'s trading training system. Also, beginners can gain knowledge through communication with experienced users in the TBCC.COM community. Among the additional advantages of the trading platform, one can single out the operational support service and the presence of the author\'s trading signal system.\nThe project is built on the basis of Binance CLOUD technical solutions, which were presented by the Binance crypto exchange team in February 2020. The tools helped the developers create a high-tech, secure trading platform TBCC.COM.\nBinance CLOUD technical solutions allow you to launch crypto exchanges in accordance with the standards of Binance - one of the most popular platforms for trading digital assets, the market leader in terms of total trading volume, according to the CoinMarketCap resource.\n\nDownload TBCC Exchange mobile app:"),
        "thirdPartyApp": MessageLookupByLibrary.simpleMessage(
            "Third party application. Verify data before confirming transactions"),
        "to": MessageLookupByLibrary.simpleMessage("To"),
        "toPay": MessageLookupByLibrary.simpleMessage("To pay"),
        "tokenPrice": m23,
        "total": MessageLookupByLibrary.simpleMessage("Total"),
        "totalFundBal":
            MessageLookupByLibrary.simpleMessage("Total Fund balance"),
        "touchSensor": MessageLookupByLibrary.simpleMessage("Touch Sensor"),
        "transactions": MessageLookupByLibrary.simpleMessage("Transactions"),
        "transferSuccessText": MessageLookupByLibrary.simpleMessage(
            "Transaction sent to processing. Will appear in the history soon."),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Please try again."),
        "txTime": MessageLookupByLibrary.simpleMessage("Transaction time"),
        "typeCorrectAmount":
            MessageLookupByLibrary.simpleMessage("Type correct amount!"),
        "typeCorrectPrice":
            MessageLookupByLibrary.simpleMessage("Type correct price!"),
        "updateAvailable":
            MessageLookupByLibrary.simpleMessage("Update available"),
        "updateDownloading":
            MessageLookupByLibrary.simpleMessage("Downloading..."),
        "updateDownlodaded":
            MessageLookupByLibrary.simpleMessage("Update downloaded"),
        "useBiometrics": MessageLookupByLibrary.simpleMessage("Use biometrics"),
        "usedFunds": MessageLookupByLibrary.simpleMessage("Used funds"),
        "verifyMnemonic": MessageLookupByLibrary.simpleMessage(
            "Tap the words from your secret key"),
        "vote": MessageLookupByLibrary.simpleMessage("Vote"),
        "voting": MessageLookupByLibrary.simpleMessage("Voting"),
        "vpnDescription": MessageLookupByLibrary.simpleMessage(
            "Try the first decentralized blockchain-based VPN. Even a supercomputer will not get an acсessto your data."),
        "waitingConfirmation":
            MessageLookupByLibrary.simpleMessage("Waiting for confirmation"),
        "wallet": MessageLookupByLibrary.simpleMessage("Wallet"),
        "wantToBuy": MessageLookupByLibrary.simpleMessage("Want to buy"),
        "wantToSwap": MessageLookupByLibrary.simpleMessage("Want to swap"),
        "whatsNew": MessageLookupByLibrary.simpleMessage("What\'s new"),
        "withdraw": MessageLookupByLibrary.simpleMessage("Withdraw"),
        "writeSmartCard":
            MessageLookupByLibrary.simpleMessage("Write smart card"),
        "wrongAddr": MessageLookupByLibrary.simpleMessage("Wrong address"),
        "wrongPin": MessageLookupByLibrary.simpleMessage("Wrong PIN"),
        "youAttachedCard": MessageLookupByLibrary.simpleMessage(
            "You have successfully attached your smart card."),
        "youPay": MessageLookupByLibrary.simpleMessage("You pay"),
        "youProNow": m24,
        "youReceive": MessageLookupByLibrary.simpleMessage("You receive"),
        "yourBalance": MessageLookupByLibrary.simpleMessage("Your balance")
      };
}
