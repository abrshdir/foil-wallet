// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static String m0(amount) => "不小于 ${amount}";

  static String m1(token) => "${token}金额";

  static String m2(token) => "可用的 ${token} 代币操作";

  static String m3(type) => "成为${type}";

  static String m4(token) => "买${token}";

  static String m5(some) => "${some}已复制到剪贴板";

  static String m6(type) => "使用${type}进行访问";

  static String m7(type) => "使用${type}获取OTC";

  static String m8(type) => "转到${type}";

  static String m9(cnt) => "这个ID还剩${cnt}条生命";

  static String m10(end, result) => "彩票将持续到 ${end}，彩票结果将于 ${result}日公布。";

  static String m11(startend, result) =>
      "日期：彩票销售从 ${startend} ，将在 ${result} 进行统计。";

  static String m12(date) => "${date}日公布彩票结果并兑奖金。";

  static String m13(price) => "3.每张彩票 ${price} TBCC （BEP20）。";

  static String m14(token) => "${token}不足以支付转账费";

  static String m15(token) => "${token}价格";

  static String m16(type) => "通过TBCC Wallet ${type}访问更多功能并节省更多";

  static String m17(price) => "获得${price}的完整访问权限";

  static String m18(price) => "获得${price}的完整访问权限";

  static String m19(type) => "购买${type}";

  static String m20(token) => "卖${token}";

  static String m21(date) => "订阅将于 ${date} 到期";

  static String m22(to) => "交换${to}";

  static String m23(token) => "${token}价格";

  static String m24(type) => "最新版本${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutTbcc": MessageLookupByLibrary.simpleMessage("关于TBCC"),
        "accessToVpn": MessageLookupByLibrary.simpleMessage("可用的TBCC VPN"),
        "accountExists": MessageLookupByLibrary.simpleMessage("此帐户已被添加！"),
        "accounts": MessageLookupByLibrary.simpleMessage("账户"),
        "actions": MessageLookupByLibrary.simpleMessage("操作"),
        "addAddress": MessageLookupByLibrary.simpleMessage("Add address"),
        "addChange": MessageLookupByLibrary.simpleMessage("添加/更改"),
        "addWallet": MessageLookupByLibrary.simpleMessage("添加钱包"),
        "address": MessageLookupByLibrary.simpleMessage("地址"),
        "addressBook": MessageLookupByLibrary.simpleMessage("地址簿"),
        "addressOfRecipient": MessageLookupByLibrary.simpleMessage("收件人地址"),
        "advanced": MessageLookupByLibrary.simpleMessage("高级"),
        "all": MessageLookupByLibrary.simpleMessage("所有"),
        "allFeatures": MessageLookupByLibrary.simpleMessage("所有功能"),
        "amount": MessageLookupByLibrary.simpleMessage("金额"),
        "amountMoreThan": m0,
        "amountToken": m1,
        "annually": MessageLookupByLibrary.simpleMessage("每年"),
        "attachCardText1":
            MessageLookupByLibrary.simpleMessage("如果您链接了智能卡，则只能在其帮助下登录您的帐户！"),
        "attachCardText2": MessageLookupByLibrary.simpleMessage(
            " 链接智能卡之前，建议您首先确保已将帐户中的助记词短语保存在安全的地s方，以便在丢失智能卡时可以恢复帐户。"),
        "attachSmartCard": MessageLookupByLibrary.simpleMessage("绑定智能卡"),
        "attachYourCard": MessageLookupByLibrary.simpleMessage(" 将NFC卡连接到手机背面"),
        "attachingSmartCard": MessageLookupByLibrary.simpleMessage("链接智能卡"),
        "attention": MessageLookupByLibrary.simpleMessage(" 注 意!!!"),
        "availableActions": m2,
        "awailableToSwap": MessageLookupByLibrary.simpleMessage("可供交换"),
        "backup": MessageLookupByLibrary.simpleMessage("恢复"),
        "balance": MessageLookupByLibrary.simpleMessage("余额"),
        "becomePro": m3,
        "benefitPaymentsInfo":
            MessageLookupByLibrary.simpleMessage("请在接收活动结束后的10天内付清款项。"),
        "bestAsk": MessageLookupByLibrary.simpleMessage("最优卖价"),
        "bestBid": MessageLookupByLibrary.simpleMessage("最优买价"),
        "binancePK": MessageLookupByLibrary.simpleMessage("BinanceChain私钥"),
        "biometrics": MessageLookupByLibrary.simpleMessage("生物识别"),
        "biometricsEnableAsk":
            MessageLookupByLibrary.simpleMessage("启用生物特征识别解锁？"),
        "biometricsText": MessageLookupByLibrary.simpleMessage(
            "您可以使用指纹或面部生物特征识别来代替密码输入应用程序。"),
        "biometricsUnavailable":
            MessageLookupByLibrary.simpleMessage("您的设备不支持生物特征识别。"),
        "buy": MessageLookupByLibrary.simpleMessage("买"),
        "buyInAdd": MessageLookupByLibrary.simpleMessage("购买"),
        "buyOrSwap": MessageLookupByLibrary.simpleMessage("购买或交换"),
        "buyToken": m4,
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "canceled": MessageLookupByLibrary.simpleMessage("取消"),
        "cancle": MessageLookupByLibrary.simpleMessage("取消"),
        "candlestickChart": MessageLookupByLibrary.simpleMessage("烛台图"),
        "cantBeEmpty": MessageLookupByLibrary.simpleMessage("不能为空"),
        "cardAttachedYet": MessageLookupByLibrary.simpleMessage("该卡已链接到其中一个帐户"),
        "cardNotOrderedYet": MessageLookupByLibrary.simpleMessage("您还没有订购智能卡。"),
        "cardPinText1": MessageLookupByLibrary.simpleMessage("输入卡的六位数的PIN码。"),
        "cardPinText2":
            MessageLookupByLibrary.simpleMessage(" 使用卡登录帐户时，您需要输入此PIN码"),
        "changePassword": MessageLookupByLibrary.simpleMessage("修改密码"),
        "chart": MessageLookupByLibrary.simpleMessage("图表"),
        "checkInternet": MessageLookupByLibrary.simpleMessage("检查您的网络连接"),
        "checkSavedMnemonicAll":
            MessageLookupByLibrary.simpleMessage("检查助记词是否从您的钱包中保存"),
        "checkSavedMnemonicSingle":
            MessageLookupByLibrary.simpleMessage("检查是否从该钱包中保存了助记词"),
        "checkingIntegrity": MessageLookupByLibrary.simpleMessage("检查文件完整性"),
        "chooseWallet": MessageLookupByLibrary.simpleMessage("选择一个钱包"),
        "clear": MessageLookupByLibrary.simpleMessage("放入"),
        "clearCache": MessageLookupByLibrary.simpleMessage("清除缓存"),
        "closedOrders": MessageLookupByLibrary.simpleMessage("关闭"),
        "cloudDialogDescription": MessageLookupByLibrary.simpleMessage(
            "已⁠激⁠活PRO帐⁠户⁠的⁠客⁠户⁠将⁠优⁠先⁠进⁠入 Binance Cloud ⁠交⁠易⁠所，很⁠快⁠您⁠就⁠可⁠以⁠在⁠ TBCC & Binance 交⁠易⁠所⁠进⁠行⁠交⁠易⁠了⁠。我⁠们⁠祝⁠您⁠在⁠新⁠的⁠一⁠年⁠里⁠幸⁠福⁠和⁠顺⁠利！"),
        "cloudVoteDesc": MessageLookupByLibrary.simpleMessage(
            "币安云.\n\n您可以使用我们的交易所在世界任何地方随时交易加密货币。 我们易于使用的界面将帮助您尽可能方便地进行加密货币体验。\n我们的交易所将在币安云上运行，并为其用户提供世界上最大的流动资金。 这将使您能够交易世界上最好的和领先的数字资产。"),
        "coin": MessageLookupByLibrary.simpleMessage("硬币"),
        "community": MessageLookupByLibrary.simpleMessage("社区"),
        "confirm": MessageLookupByLibrary.simpleMessage("确认"),
        "confirmAction": MessageLookupByLibrary.simpleMessage("确认动作"),
        "confirmPhrase1": MessageLookupByLibrary.simpleMessage("我确认同意"),
        "confirmPhrase2": MessageLookupByLibrary.simpleMessage("用户协议条款"),
        "confirmSwap": MessageLookupByLibrary.simpleMessage("确认交换"),
        "confirmTransfer": MessageLookupByLibrary.simpleMessage("确认交易"),
        "confirmations": MessageLookupByLibrary.simpleMessage("确认数"),
        "continue_": MessageLookupByLibrary.simpleMessage("继续"),
        "copiedToClipboard": m5,
        "copy": MessageLookupByLibrary.simpleMessage("复制"),
        "createWallet": MessageLookupByLibrary.simpleMessage("创建新的钱包"),
        "currency": MessageLookupByLibrary.simpleMessage("货币"),
        "currentPrice": MessageLookupByLibrary.simpleMessage("目前的价格"),
        "currentSession": MessageLookupByLibrary.simpleMessage("当前会话"),
        "currentStatus": MessageLookupByLibrary.simpleMessage("当前状态"),
        "darkMode": MessageLookupByLibrary.simpleMessage("黑暗主题"),
        "details": MessageLookupByLibrary.simpleMessage("更多细节"),
        "disable": MessageLookupByLibrary.simpleMessage("关闭"),
        "disconnect": MessageLookupByLibrary.simpleMessage("断开"),
        "download": MessageLookupByLibrary.simpleMessage("下载"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "emailSupport": MessageLookupByLibrary.simpleMessage("联系客服"),
        "enable": MessageLookupByLibrary.simpleMessage("启用"),
        "endInvestDate": MessageLookupByLibrary.simpleMessage("接受资金的结束日期："),
        "enterPin": MessageLookupByLibrary.simpleMessage("输入密码"),
        "error": MessageLookupByLibrary.simpleMessage("错误"),
        "ethereumPK": MessageLookupByLibrary.simpleMessage("以太坊私钥"),
        "exchange": MessageLookupByLibrary.simpleMessage("交易所"),
        "faceDetection": MessageLookupByLibrary.simpleMessage("人脸检测"),
        "fast": MessageLookupByLibrary.simpleMessage("快速"),
        "fee": MessageLookupByLibrary.simpleMessage("费用"),
        "fileDamaged": MessageLookupByLibrary.simpleMessage("文件损坏，再试一次"),
        "fingerprint": MessageLookupByLibrary.simpleMessage("指纹"),
        "fingerprintAuthentication":
            MessageLookupByLibrary.simpleMessage("指纹认证"),
        "forceUpdate":
            MessageLookupByLibrary.simpleMessage("重要的应用更新已可用。 要继续，您需要下载并安装它。"),
        "from": MessageLookupByLibrary.simpleMessage("由于"),
        "gasLimit": MessageLookupByLibrary.simpleMessage("Gas限制"),
        "gasPrice": MessageLookupByLibrary.simpleMessage("Gas价格"),
        "getAccessWithPro": m6,
        "getOTCWithPro": m7,
        "goBack": MessageLookupByLibrary.simpleMessage("回去"),
        "goForward": MessageLookupByLibrary.simpleMessage("直走"),
        "goPro": m8,
        "goToWebsite": MessageLookupByLibrary.simpleMessage("前往网站"),
        "history": MessageLookupByLibrary.simpleMessage("历史"),
        "iUnderstood": MessageLookupByLibrary.simpleMessage("我明白了"),
        "incorrectPassword": MessageLookupByLibrary.simpleMessage("密码错误"),
        "insertPromoCode":
            MessageLookupByLibrary.simpleMessage("输入代码(如果您没有，则无需输入)"),
        "installUpdate": MessageLookupByLibrary.simpleMessage("安装"),
        "invalidMnemonic": MessageLookupByLibrary.simpleMessage("不正确的短语"),
        "invalidOrder": MessageLookupByLibrary.simpleMessage("顺序错误"),
        "invest": MessageLookupByLibrary.simpleMessage("投资"),
        "investAttention": MessageLookupByLibrary.simpleMessage(
            "一个账户可以投资一次，您可以在一台设备上最多创建5个帐户。 使用TBCC bep2代币支付利息，投票的用户将额外获得0.5％奖励。已激活PRO帐户的客户将首先收到付款"),
        "investment": MessageLookupByLibrary.simpleMessage("投资额"),
        "joinCommunity": MessageLookupByLibrary.simpleMessage("加入社群"),
        "jump_boughtCodes": MessageLookupByLibrary.simpleMessage("购买的代码："),
        "jump_buyLives": MessageLookupByLibrary.simpleMessage("购买TBCC Jump生命"),
        "jump_codesLeft": m9,
        "jump_writeID": MessageLookupByLibrary.simpleMessage("输入您的游戏内ID"),
        "knowledgeBase": MessageLookupByLibrary.simpleMessage("知识库"),
        "language": MessageLookupByLibrary.simpleMessage("程序语言"),
        "logIn": MessageLookupByLibrary.simpleMessage("登录"),
        "logInWithCard": MessageLookupByLibrary.simpleMessage("使用智能卡登录。"),
        "logOut": MessageLookupByLibrary.simpleMessage("退出"),
        "logOutAllQuestion": MessageLookupByLibrary.simpleMessage("退出所有帐户？"),
        "logOutQuestion": MessageLookupByLibrary.simpleMessage("注销？"),
        "lookCamera": MessageLookupByLibrary.simpleMessage("看相机"),
        "lottery": MessageLookupByLibrary.simpleMessage("抽奖 TBCC"),
        "lotteryAccept": MessageLookupByLibrary.simpleMessage("参与"),
        "lotteryAccepted": MessageLookupByLibrary.simpleMessage("您已经参加了。期待结果。"),
        "lotteryDesc1":
            MessageLookupByLibrary.simpleMessage("参加抽奖活动，并有机会赢得奖金！"),
        "lotteryDesc2": m10,
        "lotteryDesc3": m11,
        "lotteryDesc4": m12,
        "lotteryRule1":
            MessageLookupByLibrary.simpleMessage("大家好\n\n1.可以参加不限地址数量的彩票。"),
        "lotteryRule2":
            MessageLookupByLibrary.simpleMessage("2.通过购买彩票，增加中奖的机率。"),
        "lotteryRule3": m13,
        "lotteryRule4":
            MessageLookupByLibrary.simpleMessage("4.只有PRO和PREMIUM帐户持有人可以领取彩票。"),
        "lotteryWinners": MessageLookupByLibrary.simpleMessage("获奖者名单"),
        "lotteryWinnersDesc1": MessageLookupByLibrary.simpleMessage(
            "如果您在获奖者名单中，您的帐户地址将在下面的列表中突出显示"),
        "lotteryWinnersDesc2":
            MessageLookupByLibrary.simpleMessage("所有获奖者将自动获得TBCC令牌。"),
        "market": MessageLookupByLibrary.simpleMessage("市场"),
        "marketDepth": MessageLookupByLibrary.simpleMessage("市场分析"),
        "marketPairs": MessageLookupByLibrary.simpleMessage("币对"),
        "memoInfoDialogHeader":
            MessageLookupByLibrary.simpleMessage("汇出标明付款目的的资金吗？"),
        "memoInfoDialogText":
            MessageLookupByLibrary.simpleMessage("如果收件人不需要，请将该字段留空。"),
        "mnemonicDescription1": MessageLookupByLibrary.simpleMessage("您看见"),
        "mnemonicDescription2": MessageLookupByLibrary.simpleMessage("12个字，"),
        "mnemonicDescription3":
            MessageLookupByLibrary.simpleMessage("这将允许您恢复钱包"),
        "mnemonicDescription4":
            MessageLookupByLibrary.simpleMessage("将它们存放在安全的地方并保密。"),
        "mnemonicPhrase": MessageLookupByLibrary.simpleMessage("助记词"),
        "mnemonicWarning":
            MessageLookupByLibrary.simpleMessage("我了解，如果我忘记了助记词，我将无法使用我的钱包"),
        "mnemonicWrite": MessageLookupByLibrary.simpleMessage("输入助记词"),
        "mobileOsVoteDesc": MessageLookupByLibrary.simpleMessage(
            ".移动TBCC操作系统\n\nTBCC开始开发自己的手机操作系统。 系统的Alpha版已经由我们的专家进行测试。 所有TBCC产品将直接在移动设备上运行，保护货币的安全性将变得更加安全，基础设施将确保高可用性。  TBCC每天都在变得越来越强大。"),
        "multiWallet": MessageLookupByLibrary.simpleMessage("多钱包"),
        "myOrders": MessageLookupByLibrary.simpleMessage("我的订单"),
        "myVpnKeys": MessageLookupByLibrary.simpleMessage("我的 VPN 密钥"),
        "networkFee": MessageLookupByLibrary.simpleMessage("网络费"),
        "newAccountName": MessageLookupByLibrary.simpleMessage("新帐户名称"),
        "news": MessageLookupByLibrary.simpleMessage("消息"),
        "next": MessageLookupByLibrary.simpleMessage("下一步"),
        "nfcUnavailable":
            MessageLookupByLibrary.simpleMessage("NFC已禁用或不可用。 请检查NFC模式是否已启用。"),
        "nft": MessageLookupByLibrary.simpleMessage("NFT"),
        "noActions": MessageLookupByLibrary.simpleMessage("无可用操作"),
        "noClosedOrders": MessageLookupByLibrary.simpleMessage("没有关闭的订单"),
        "noOpenOrders": MessageLookupByLibrary.simpleMessage("没有未结订单"),
        "noTransactions": MessageLookupByLibrary.simpleMessage("没有交易记录"),
        "noValidAddrFound": MessageLookupByLibrary.simpleMessage("找不到有效的地址。"),
        "noValidMnemonic": MessageLookupByLibrary.simpleMessage("找不到有效的助记词"),
        "notEnoughTokens": MessageLookupByLibrary.simpleMessage("余额不足。"),
        "notEnoughTokensFee": m14,
        "oneTimePayment": MessageLookupByLibrary.simpleMessage("一次性支付"),
        "openOrders": MessageLookupByLibrary.simpleMessage("打开"),
        "optional": MessageLookupByLibrary.simpleMessage("可选的"),
        "orderBook": MessageLookupByLibrary.simpleMessage("交易数据"),
        "orderFinishTime": MessageLookupByLibrary.simpleMessage("完成"),
        "orderPlaced": MessageLookupByLibrary.simpleMessage("订单已下"),
        "orderSmartCard": MessageLookupByLibrary.simpleMessage("预订智能卡"),
        "orderSmartCardConfirmation":
            MessageLookupByLibrary.simpleMessage("您确认预定智能卡吗？"),
        "orderStartTime": MessageLookupByLibrary.simpleMessage("开始"),
        "orderType": MessageLookupByLibrary.simpleMessage("类型"),
        "password": MessageLookupByLibrary.simpleMessage("输入密码"),
        "passwordDoNotMatch": MessageLookupByLibrary.simpleMessage("密码不匹配"),
        "passwordInfo":
            MessageLookupByLibrary.simpleMessage("该密码将用于解锁您的钱包并使用加密货币"),
        "passwordSymbolAmount":
            MessageLookupByLibrary.simpleMessage("太短了 最少8个字符"),
        "paste": MessageLookupByLibrary.simpleMessage("清楚"),
        "pinCodesNotMatch": MessageLookupByLibrary.simpleMessage("PIN码不匹配"),
        "premDiscount":
            MessageLookupByLibrary.simpleMessage("当您再次更新您的高级帐户时，您将获得10％的折扣"),
        "price": MessageLookupByLibrary.simpleMessage("价钱"),
        "priceToken": m15,
        "privateKeys": MessageLookupByLibrary.simpleMessage("私钥"),
        "proDesc0": m16,
        "proDesc1": m17,
        "proDesc12": m18,
        "proDesc2": MessageLookupByLibrary.simpleMessage(
            "这些是由一个用户创建的帐户。 帐户之间的便捷切换。 您将在一台设备上最多创建3个帐户。"),
        "proDesc2h": MessageLookupByLibrary.simpleMessage("多账户"),
        "proDesc3": MessageLookupByLibrary.simpleMessage(
            "结束OTC交易不需要在交易前夕预留资金，因为交易的参与者直接结算。 通常，场外交易以递延结算方式进行。"),
        "proDesc3h": MessageLookupByLibrary.simpleMessage("OTC交易"),
        "proDesc4": MessageLookupByLibrary.simpleMessage(
            "为交易和加密货币交易支付更少的钱。 所有交易将以最低价格进行。"),
        "proDesc4h": MessageLookupByLibrary.simpleMessage("减少佣金"),
        "proDesc5": MessageLookupByLibrary.simpleMessage(
            "从一开始就获取最新更新。 新技术将立即出现在您的钱包中。"),
        "proDesc5h": MessageLookupByLibrary.simpleMessage("最新项目"),
        "proDesc6":
            MessageLookupByLibrary.simpleMessage("我们将回答您的任何问题。 我们将帮助您解决任何问题。"),
        "proDesc6h": MessageLookupByLibrary.simpleMessage("个人技术支持"),
        "proDiscount":
            MessageLookupByLibrary.simpleMessage("Pro 账户续订时，有 15% 的折扣"),
        "proVpnDialog":
            MessageLookupByLibrary.simpleMessage("恭喜您 您已获得免费体验三个月的VPN使用权限。"),
        "purchaseDate": MessageLookupByLibrary.simpleMessage("购买日期"),
        "purchasePro": m19,
        "purchaseVpn": MessageLookupByLibrary.simpleMessage("购买VPN"),
        "purchased": MessageLookupByLibrary.simpleMessage("已购买"),
        "receive": MessageLookupByLibrary.simpleMessage("获得令牌"),
        "received": MessageLookupByLibrary.simpleMessage("已收到"),
        "recommended": MessageLookupByLibrary.simpleMessage("推荐"),
        "refresh": MessageLookupByLibrary.simpleMessage("余额更新"),
        "reload": MessageLookupByLibrary.simpleMessage("重新加载"),
        "rename": MessageLookupByLibrary.simpleMessage("改名"),
        "renewPremium": MessageLookupByLibrary.simpleMessage("更新您的高级帐户"),
        "renewPro": MessageLookupByLibrary.simpleMessage("扩展专业账户"),
        "repeatPassword": MessageLookupByLibrary.simpleMessage("再次输入密码"),
        "repeatPin": MessageLookupByLibrary.simpleMessage("重复PIN码"),
        "restoreWallet": MessageLookupByLibrary.simpleMessage("恢复钱包"),
        "scanNewQR": MessageLookupByLibrary.simpleMessage("扫描新的二维码"),
        "securityCenter": MessageLookupByLibrary.simpleMessage("安全"),
        "sell": MessageLookupByLibrary.simpleMessage("卖"),
        "sellToken": m20,
        "send": MessageLookupByLibrary.simpleMessage("发送"),
        "sent": MessageLookupByLibrary.simpleMessage("已发送"),
        "serviceUnavailable": MessageLookupByLibrary.simpleMessage("暂时无法使用的服务"),
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "share": MessageLookupByLibrary.simpleMessage("分享"),
        "show": MessageLookupByLibrary.simpleMessage("显示"),
        "showTransactions": MessageLookupByLibrary.simpleMessage("显示交易"),
        "showVpnKey": MessageLookupByLibrary.simpleMessage("显示序列号"),
        "signTx": MessageLookupByLibrary.simpleMessage("签署交易"),
        "sixDigitsNeeded": MessageLookupByLibrary.simpleMessage("需要6位数字"),
        "slow": MessageLookupByLibrary.simpleMessage("缓慢"),
        "smartCard": MessageLookupByLibrary.simpleMessage("智能卡"),
        "smartCardMarketText1":
            MessageLookupByLibrary.simpleMessage("智能卡旨在安全地存储您的资金"),
        "smartCardMarketText2":
            MessageLookupByLibrary.simpleMessage("要访问钱包，必须使用NFC将智能卡连接到手机背面。"),
        "smartCardMarketText3":
            MessageLookupByLibrary.simpleMessage("该卡提供双因素授权。"),
        "smartCardMarketText4":
            MessageLookupByLibrary.simpleMessage("注册激活卡后，您将获得13 TBCC。"),
        "smartCardOrdered":
            MessageLookupByLibrary.simpleMessage("恭喜你！您已经订购了智能卡。"),
        "smartContractCall": MessageLookupByLibrary.simpleMessage("调用智能合约"),
        "start": MessageLookupByLibrary.simpleMessage("开始"),
        "startupText0":
            MessageLookupByLibrary.simpleMessage("TBCC钱包-\n所有人的区块链钱包"),
        "startupText1":
            MessageLookupByLibrary.simpleMessage("使用便捷的钱包购买，存储，发送，交换您的加密货币"),
        "subExpires": MessageLookupByLibrary.simpleMessage("订阅即将到期"),
        "subExpiresDate": m21,
        "success": MessageLookupByLibrary.simpleMessage("成功"),
        "supportCenter": MessageLookupByLibrary.simpleMessage("帮助"),
        "swap": MessageLookupByLibrary.simpleMessage("交换"),
        "swapBep2":
            MessageLookupByLibrary.simpleMessage("将TBCC(BEP2)换成TBCC(BEP8)"),
        "swapBep8":
            MessageLookupByLibrary.simpleMessage("将TBCC(BEP8)换成TBCC(BEP2)"),
        "swapStandardSent": MessageLookupByLibrary.simpleMessage(
            "交换请求已成功发送。 如果成功，资金将在5分钟内记入贷方。"),
        "swapTo": m22,
        "target": MessageLookupByLibrary.simpleMessage("投票"),
        "tbcc_exchange": MessageLookupByLibrary.simpleMessage(
            "TBCC团队推出基于Binance的交易平台 - TBCC.COM\n以数字资产为导向的交易平台TBCC.COM的开发者已经宣布其启动，并积极执行作为路线图一部分的任务。\n围绕该交易所已经形成了一个庞大的社区。加密货币社区的成员被TBCC.COM的大型流动性池所吸引，同时也被交易平台列出的steaking 和farming 的硬币可用性所吸引，适合各种口味。\n项目组介绍了作者的交易培训系统。同时，初学者可以通过与TBCC.COM社区有经验的用户交流学习。交易平台的额外优势包括运营支持服务和作者的交易信号系统。\n该项目基于Binance CLOUD的技术解决方案，2020年2月由Binance加密货币的团队提出。这些工具帮助开发者创建了一个高科技、安全的交易平台TBCC.COM。\nBinance CLOUD技术解决方案允许推出加密交易所，符合Binance的标准--根据CoinMarketCap资源，Binance是最受欢迎的数字资产交易平台之一，在总交易量方面是市场领导者。\n\n下载TBCC Exchange手机应用程序:"),
        "thirdPartyApp":
            MessageLookupByLibrary.simpleMessage("第三方应用。确认交易前检查数据。"),
        "to": MessageLookupByLibrary.simpleMessage("位置"),
        "toPay": MessageLookupByLibrary.simpleMessage("支付"),
        "tokenPrice": m23,
        "total": MessageLookupByLibrary.simpleMessage("总计"),
        "totalFundBal": MessageLookupByLibrary.simpleMessage("资金余额："),
        "touchSensor": MessageLookupByLibrary.simpleMessage("触摸传感器"),
        "transactions": MessageLookupByLibrary.simpleMessage("交易记录"),
        "transferSuccessText":
            MessageLookupByLibrary.simpleMessage("交易在处理中。 并可在交易记录中查询。"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("请再试一遍。"),
        "txTime": MessageLookupByLibrary.simpleMessage("交易时间"),
        "typeCorrectAmount": MessageLookupByLibrary.simpleMessage("输入正确的金额"),
        "typeCorrectPrice": MessageLookupByLibrary.simpleMessage(""),
        "updateAvailable": MessageLookupByLibrary.simpleMessage("可用更新"),
        "updateDownloading": MessageLookupByLibrary.simpleMessage("下载更新..."),
        "updateDownlodaded": MessageLookupByLibrary.simpleMessage("更新加载"),
        "useBiometrics": MessageLookupByLibrary.simpleMessage("使用生物识别"),
        "usedFunds": MessageLookupByLibrary.simpleMessage("使用资金："),
        "verifyMnemonic":
            MessageLookupByLibrary.simpleMessage("按正确的顺序按助记符\n中的单词"),
        "vote": MessageLookupByLibrary.simpleMessage("投票"),
        "voting": MessageLookupByLibrary.simpleMessage("投票"),
        "vpnDescription": MessageLookupByLibrary.simpleMessage(
            "请开始使用第一个去中心化的区块链VPN。 甚至超级计算机也无法访问您的数据。"),
        "waitingConfirmation": MessageLookupByLibrary.simpleMessage("等待确认中"),
        "wallet": MessageLookupByLibrary.simpleMessage("投资组合"),
        "wantToBuy": MessageLookupByLibrary.simpleMessage("想购买"),
        "wantToSwap": MessageLookupByLibrary.simpleMessage("我想交换"),
        "whatsNew": MessageLookupByLibrary.simpleMessage("新产品"),
        "withdraw": MessageLookupByLibrary.simpleMessage("提款"),
        "writeSmartCard": MessageLookupByLibrary.simpleMessage(" 刻录智能卡"),
        "wrongAddr": MessageLookupByLibrary.simpleMessage("地址错误。"),
        "wrongPin": MessageLookupByLibrary.simpleMessage("PIN码错误"),
        "youAttachedCard": MessageLookupByLibrary.simpleMessage("您已链接智能卡"),
        "youPay": MessageLookupByLibrary.simpleMessage("您将支付"),
        "youProNow": m24,
        "youReceive": MessageLookupByLibrary.simpleMessage("实际到账"),
        "yourBalance": MessageLookupByLibrary.simpleMessage("余额")
      };
}
