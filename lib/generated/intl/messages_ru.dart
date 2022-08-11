// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static String m0(amount) => "Количество должно быть ≥${amount}";

  static String m1(token) => "Кол-во ${token}";

  static String m2(token) => "Доступные действия с токеном ${token}";

  static String m3(type) => "Стать ${type}";

  static String m4(token) => "Купить ${token}";

  static String m5(some) => "${some} Скопировано в буфер обмена";

  static String m6(type) => "Получить с ${type}";

  static String m7(type) => "Получить OTC с ${type}";

  static String m8(type) => "Стань ${type}";

  static String m9(cnt) => "Для этого ID осталось ${cnt} жизней";

  static String m10(end, result) =>
      "Лотерея продлится до ${end} Итоги лотереи будут известны ${result}";

  static String m11(startend, result) =>
      "Сроки проведения: продажа билетов ${startend}, подсчёт будет производиться ${result}";

  static String m12(date) =>
      "Оглашение результатов лотереи и выплата выигрыша ${date}";

  static String m13(price) =>
      "3.Стоимость одного билета ${price} TBCC (BEP20).";

  static String m14(token) => "Недостаточно ${token} для оплаты комиссии";

  static String m15(token) => "Цена ${token}";

  static String m16(type) =>
      "Получите доступ к большему количеству функций и большей экономии с TBCC Wallet ${type}";

  static String m17(price) => "Получите полный доступ за ${price}";

  static String m18(price) => "Получите доступ за ${price}";

  static String m19(type) => "Купить ${type}";

  static String m20(token) => "Продать ${token}";

  static String m21(date) => "Подписка истекает ${date}";

  static String m22(to) => "Обменять на ${to}";

  static String m23(token) => "${token} Цена";

  static String m24(type) => "Вы уже ${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutTbcc": MessageLookupByLibrary.simpleMessage("Про TBCC"),
        "accessToVpn":
            MessageLookupByLibrary.simpleMessage("Доступ к TBCC VPN"),
        "accountExists":
            MessageLookupByLibrary.simpleMessage("Такой аккаунт уже добавлен!"),
        "accounts": MessageLookupByLibrary.simpleMessage("Аккаунты"),
        "actions": MessageLookupByLibrary.simpleMessage("Действия"),
        "addAddress": MessageLookupByLibrary.simpleMessage("Добавить адрес"),
        "addChange":
            MessageLookupByLibrary.simpleMessage("Добавить новую карту"),
        "addWallet": MessageLookupByLibrary.simpleMessage("Добавить кошелёк"),
        "address": MessageLookupByLibrary.simpleMessage("Адрес"),
        "addressBook": MessageLookupByLibrary.simpleMessage("Адресная книга"),
        "addressOfRecipient":
            MessageLookupByLibrary.simpleMessage("Адрес получателя"),
        "advanced": MessageLookupByLibrary.simpleMessage("Продвинутый"),
        "all": MessageLookupByLibrary.simpleMessage("Все"),
        "allFeatures": MessageLookupByLibrary.simpleMessage("Все возможности"),
        "amount": MessageLookupByLibrary.simpleMessage("Кол-во"),
        "amountMoreThan": m0,
        "amountToken": m1,
        "annually": MessageLookupByLibrary.simpleMessage("Ежегодно"),
        "attachCardText1": MessageLookupByLibrary.simpleMessage(
            "Если Вы привяжете свою смарт-карту, то войти в аккаунт сможете ТОЛЬКО с ее помощью!"),
        "attachCardText2": MessageLookupByLibrary.simpleMessage(
            "Перед привязкой смарт-карты рекомендуем сначала удостовериться, что Вы сохранили мнемоническую фразу от аккаунта в надежном месте, чтобы в случае утери смарт-карты Вы могли восстановить аккаунт."),
        "attachSmartCard":
            MessageLookupByLibrary.simpleMessage("Привязать Смарт-карту"),
        "attachYourCard": MessageLookupByLibrary.simpleMessage(
            "Приложите Вашу NFC-карту к задней части телефона"),
        "attachingSmartCard":
            MessageLookupByLibrary.simpleMessage("Привязка Смарт-карты"),
        "attention": MessageLookupByLibrary.simpleMessage("Внимание"),
        "availableActions": m2,
        "awailableToSwap":
            MessageLookupByLibrary.simpleMessage("Доступно к обмену"),
        "backup": MessageLookupByLibrary.simpleMessage("Восстановить"),
        "balance": MessageLookupByLibrary.simpleMessage("Баланс"),
        "becomePro": m3,
        "benefitPaymentsInfo": MessageLookupByLibrary.simpleMessage(
            "Выплаты будут произведены через 10 дней после окончания приёма средств."),
        "bestAsk": MessageLookupByLibrary.simpleMessage("Лучший запрос"),
        "bestBid": MessageLookupByLibrary.simpleMessage("Лучшая ставка"),
        "binancePK":
            MessageLookupByLibrary.simpleMessage("Приватный ключ BinanceChain"),
        "biometrics": MessageLookupByLibrary.simpleMessage("Биометрия"),
        "biometricsEnableAsk": MessageLookupByLibrary.simpleMessage(
            "Включить биометрическую разблокировку?"),
        "biometricsText": MessageLookupByLibrary.simpleMessage(
            "Вы можете использовать отпечаток пальца или Face ID вместо пароля для входа в приложение."),
        "biometricsUnavailable": MessageLookupByLibrary.simpleMessage(
            "Ваше устройство не поддерживает биометрическую аутентификацию"),
        "buy": MessageLookupByLibrary.simpleMessage("Купить"),
        "buyInAdd": MessageLookupByLibrary.simpleMessage("Докупить"),
        "buyOrSwap":
            MessageLookupByLibrary.simpleMessage("Купить или обменять"),
        "buyToken": m4,
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "canceled": MessageLookupByLibrary.simpleMessage("Отменён"),
        "cancle": MessageLookupByLibrary.simpleMessage("Отменить"),
        "candlestickChart":
            MessageLookupByLibrary.simpleMessage("Свечной график"),
        "cantBeEmpty":
            MessageLookupByLibrary.simpleMessage("Не может быть пустым"),
        "cardAttachedYet": MessageLookupByLibrary.simpleMessage(
            "Карта уже привязана к одному из аккаунтов"),
        "cardNotOrderedYet": MessageLookupByLibrary.simpleMessage(
            "Вы еще не заказали смарт-карту"),
        "cardPinText1": MessageLookupByLibrary.simpleMessage(
            "Введите шестизначный PIN-код для карты."),
        "cardPinText2": MessageLookupByLibrary.simpleMessage(
            "При входе в аккаунт с использованием карты Вам необходимо будет ввести этот PIN-код"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Изменить пароль"),
        "chart": MessageLookupByLibrary.simpleMessage("График"),
        "check": MessageLookupByLibrary.simpleMessage("Проверить"),
        "checkInternet": MessageLookupByLibrary.simpleMessage(
            "Проверьте интернет-соединение"),
        "checkSavedMnemonicAll": MessageLookupByLibrary.simpleMessage(
            "Проверьте, сохранены ли мнемонические фразы от ваших кошельков"),
        "checkSavedMnemonicSingle": MessageLookupByLibrary.simpleMessage(
            "Проверьте, сохранена ли мнемоническая фраза от этого кошелька"),
        "checkingIntegrity":
            MessageLookupByLibrary.simpleMessage("Проверка целостности файла"),
        "chooseWallet": MessageLookupByLibrary.simpleMessage("Выбрать кошелёк"),
        "clear": MessageLookupByLibrary.simpleMessage("Очистить"),
        "clearCache": MessageLookupByLibrary.simpleMessage("Очистить кэш"),
        "closedOrders": MessageLookupByLibrary.simpleMessage("Закрытые"),
        "cloudDialogDescription": MessageLookupByLibrary.simpleMessage(
            "Клиенты, которые активировали учетные записи PRO, получат приоритет при входе на биржу Binance Cloud, и вскоре вы сможете торговать на бирже TBCC и Binance. Желаем счастья и успехов в новом году!"),
        "cloudVoteDesc": MessageLookupByLibrary.simpleMessage(
            "Вы сможете торговать криптовалютой в любой точке мира и в любое время с помощью нашей биржи. Наш простой в использовании интерфейс поможет вам сделать вашу работу с криптовалютой максимально удобной. Наша биржа будет работать на базе Binance Cloud и предлагает своим пользователям один из крупнейших пулов ликвидности в мире. Торгуйте ведущими цифровыми активами в мире!"),
        "coin": MessageLookupByLibrary.simpleMessage("Монеты"),
        "community": MessageLookupByLibrary.simpleMessage("Сообщество"),
        "confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
        "confirmAction":
            MessageLookupByLibrary.simpleMessage("Подтвердите действие"),
        "confirmPhrase1":
            MessageLookupByLibrary.simpleMessage("Подтверждаю свое согласие с"),
        "confirmPhrase2": MessageLookupByLibrary.simpleMessage(
            "условиями пользовательского соглашения"),
        "confirmSwap":
            MessageLookupByLibrary.simpleMessage("Подтвердить обмен"),
        "confirmTransfer":
            MessageLookupByLibrary.simpleMessage("Подтвердить трансфер"),
        "continue_": MessageLookupByLibrary.simpleMessage("Продолжить"),
        "copiedToClipboard": m5,
        "copy": MessageLookupByLibrary.simpleMessage("Копировать"),
        "createWallet":
            MessageLookupByLibrary.simpleMessage("Создать новый кошелек"),
        "currency": MessageLookupByLibrary.simpleMessage("Валюта"),
        "currentPrice": MessageLookupByLibrary.simpleMessage("Текущая цена"),
        "currentSession":
            MessageLookupByLibrary.simpleMessage("Текущая сессия"),
        "currentStatus":
            MessageLookupByLibrary.simpleMessage("Текущий статус:"),
        "darkMode": MessageLookupByLibrary.simpleMessage("Темный режим"),
        "details": MessageLookupByLibrary.simpleMessage("Детальнее"),
        "disable": MessageLookupByLibrary.simpleMessage("Выключить"),
        "disconnect": MessageLookupByLibrary.simpleMessage("Отключиться"),
        "download": MessageLookupByLibrary.simpleMessage("Скачать"),
        "edit": MessageLookupByLibrary.simpleMessage("Редактировать"),
        "emailSupport":
            MessageLookupByLibrary.simpleMessage("Написать в поддержку"),
        "enable": MessageLookupByLibrary.simpleMessage("Включить"),
        "endInvestDate": MessageLookupByLibrary.simpleMessage(
            "Дата окончания приёма средств:"),
        "enterPin": MessageLookupByLibrary.simpleMessage("Введите PIN-код"),
        "error": MessageLookupByLibrary.simpleMessage("Ошибка"),
        "ethereumPK":
            MessageLookupByLibrary.simpleMessage("Приватный ключ Ethereum"),
        "exchange": MessageLookupByLibrary.simpleMessage("Биржа"),
        "faceDetection":
            MessageLookupByLibrary.simpleMessage("Распознавание лиц"),
        "fast": MessageLookupByLibrary.simpleMessage("Быстро"),
        "fee": MessageLookupByLibrary.simpleMessage("Комиссия"),
        "fileDamaged": MessageLookupByLibrary.simpleMessage(
            "Файл поврежден. Попробуйте снова."),
        "fingerprint": MessageLookupByLibrary.simpleMessage("Отпечаток пальца"),
        "fingerprintAuthentication": MessageLookupByLibrary.simpleMessage(
            "Аутентификация по отпечатку пальца"),
        "forceUpdate": MessageLookupByLibrary.simpleMessage(
            "Доступно важное обновление приложения. Для продолжения необходимо его скачать и установить."),
        "from": MessageLookupByLibrary.simpleMessage("От"),
        "gasLimit": MessageLookupByLibrary.simpleMessage("Gas Limit"),
        "gasPrice": MessageLookupByLibrary.simpleMessage("Gas Price"),
        "getAccessWithPro": m6,
        "getOTCWithPro": m7,
        "goBack": MessageLookupByLibrary.simpleMessage("Назад"),
        "goForward": MessageLookupByLibrary.simpleMessage("Вперед"),
        "goPro": m8,
        "goToWebsite": MessageLookupByLibrary.simpleMessage("Перейти на сайт"),
        "history": MessageLookupByLibrary.simpleMessage("История"),
        "iUnderstood": MessageLookupByLibrary.simpleMessage("Я понял"),
        "insertPromoCode": MessageLookupByLibrary.simpleMessage(
            "Вставьте промокод (если есть)"),
        "installUpdate": MessageLookupByLibrary.simpleMessage("Установить"),
        "invalidMnemonic":
            MessageLookupByLibrary.simpleMessage("Некорректная фраза"),
        "invalidOrder":
            MessageLookupByLibrary.simpleMessage("Неправильный порядок"),
        "invest": MessageLookupByLibrary.simpleMessage("Вложить"),
        "investAttention": MessageLookupByLibrary.simpleMessage(
            "Инвестировать возможно один раз с одного аккаунта. У вас есть возможность создать до 5 аккаунтов на одном устройстве. Проценты выплачиваются в токенах TBCC bep2. Пользователи, которые участвуют в голосовании, получат дополнительно 0.5%."),
        "investment": MessageLookupByLibrary.simpleMessage("Инвестиции"),
        "joinCommunity":
            MessageLookupByLibrary.simpleMessage("Присоединиться к сообществу"),
        "jump_boughtCodes":
            MessageLookupByLibrary.simpleMessage("Купленные коды:"),
        "jump_buyLives":
            MessageLookupByLibrary.simpleMessage("Купить жизни TBCC Jump"),
        "jump_codesLeft": m9,
        "jump_writeID": MessageLookupByLibrary.simpleMessage(
            "Введите свой внутриигровой ID"),
        "knowledgeBase": MessageLookupByLibrary.simpleMessage("База знаний"),
        "language": MessageLookupByLibrary.simpleMessage("Язык приложения"),
        "logIn": MessageLookupByLibrary.simpleMessage("Войти"),
        "logInWithCard":
            MessageLookupByLibrary.simpleMessage("Войти со Смарт-картой"),
        "logOut": MessageLookupByLibrary.simpleMessage("Выйти"),
        "logOutAllQuestion":
            MessageLookupByLibrary.simpleMessage("Выйти из всех аккаунтов?"),
        "logOutQuestion": MessageLookupByLibrary.simpleMessage("Выйти?"),
        "lookCamera":
            MessageLookupByLibrary.simpleMessage("Посмотрите на камеру"),
        "lottery": MessageLookupByLibrary.simpleMessage("Лотерея ТBСС"),
        "lotteryAccept": MessageLookupByLibrary.simpleMessage("Купить билет"),
        "lotteryAccepted":
            MessageLookupByLibrary.simpleMessage("Билетов куплено:"),
        "lotteryDesc1": MessageLookupByLibrary.simpleMessage(
            "Примите участие в лотерее и получите шанс выиграть приз!"),
        "lotteryDesc2": m10,
        "lotteryDesc3": m11,
        "lotteryDesc4": m12,
        "lotteryRule1": MessageLookupByLibrary.simpleMessage(
            "1.В лотерее могут участвовать неограниченное количество адресов."),
        "lotteryRule2": MessageLookupByLibrary.simpleMessage(
            "2.Покупайте билеты чтоб повысить шанс выиграть"),
        "lotteryRule3": m13,
        "lotteryRule4": MessageLookupByLibrary.simpleMessage(
            "4.В лотерее могут принимать только владельцы PRO и PREMIUM аккаунтов."),
        "lotteryWinners":
            MessageLookupByLibrary.simpleMessage("Список победителей"),
        "lotteryWinnersDesc1": MessageLookupByLibrary.simpleMessage(
            "Если Вы в списке победителей, то адрес Вашего аккаунта будет выделен в списке ниже"),
        "lotteryWinnersDesc2": MessageLookupByLibrary.simpleMessage(
            "Всем победителям автоматически будут начислены призовые токены TBCC."),
        "market": MessageLookupByLibrary.simpleMessage("Маркет"),
        "marketDepth": MessageLookupByLibrary.simpleMessage("Глубина рынка"),
        "marketPairs": MessageLookupByLibrary.simpleMessage("Пары"),
        "memoInfoDialogHeader": MessageLookupByLibrary.simpleMessage(
            "Отправить средства с указанием назначения платежа?"),
        "memoInfoDialogText": MessageLookupByLibrary.simpleMessage(
            "Оставьте поле пустым, если не требуется получателем"),
        "mnemonicDescription1":
            MessageLookupByLibrary.simpleMessage("Вы видите"),
        "mnemonicDescription2":
            MessageLookupByLibrary.simpleMessage("12 слов,"),
        "mnemonicDescription3": MessageLookupByLibrary.simpleMessage(
            "которые позволят вам восстановить кошелек"),
        "mnemonicDescription4": MessageLookupByLibrary.simpleMessage(
            "Сохраните их в надежном месте и держите в тайне."),
        "mnemonicPhrase":
            MessageLookupByLibrary.simpleMessage("Мнемоническая фраза"),
        "mnemonicWarning": MessageLookupByLibrary.simpleMessage(
            "Я понимаю, что если я потеряю мнемоническую фразу, я потеряю доступ к своему кошельку"),
        "mnemonicWrite":
            MessageLookupByLibrary.simpleMessage("Введите мнемоническую фразу"),
        "mobileOsVoteDesc": MessageLookupByLibrary.simpleMessage(
            "Компания TBCC начала разработку собственной операционной системы для мобильных телефонов. Альфа версия системы уже находится на тестировании у наших специалистов. Все продукты TBCC будут находиться сразу в мобильном устройстве. Хранение киптовалюты станет еще безопаснее. Собственная инфраструктура обеспечит высокую работоспособность. С каждым днем TBCC становится все сильнее!"),
        "multiWallet": MessageLookupByLibrary.simpleMessage("Мульти-кошелёк"),
        "myOrders": MessageLookupByLibrary.simpleMessage("Мои заказы"),
        "myVpnKeys": MessageLookupByLibrary.simpleMessage("Мои ключи VPN"),
        "networkFee": MessageLookupByLibrary.simpleMessage("Комиссия сети"),
        "newAccountName":
            MessageLookupByLibrary.simpleMessage("Новое имя аккаунта"),
        "news": MessageLookupByLibrary.simpleMessage("Новости"),
        "next": MessageLookupByLibrary.simpleMessage("Далее"),
        "nfcUnavailable": MessageLookupByLibrary.simpleMessage(
            "NFC выключен или недоступен. Пожалуйста, проверьте, включен ли модуль NFC."),
        "nft": MessageLookupByLibrary.simpleMessage("NFT"),
        "noActions":
            MessageLookupByLibrary.simpleMessage("Нет доступных действий"),
        "noClosedOrders":
            MessageLookupByLibrary.simpleMessage("Закрытых ордеров нет"),
        "noOpenOrders":
            MessageLookupByLibrary.simpleMessage("Открытых ордеров нет"),
        "noTransactions": MessageLookupByLibrary.simpleMessage(
            "На данный момент транзакций нет"),
        "noValidAddrFound":
            MessageLookupByLibrary.simpleMessage("Корректный адрес не найден"),
        "noValidMnemonic": MessageLookupByLibrary.simpleMessage(
            "Не найдено корректной мнемонической фразы"),
        "notEnoughTokens":
            MessageLookupByLibrary.simpleMessage("Недостаточно средств"),
        "notEnoughTokensFee": m14,
        "oneTimePayment": MessageLookupByLibrary.simpleMessage("Разово"),
        "openOrders": MessageLookupByLibrary.simpleMessage("Открытые"),
        "optional": MessageLookupByLibrary.simpleMessage("Опционально"),
        "orderBook": MessageLookupByLibrary.simpleMessage("Стакан"),
        "orderFinishTime": MessageLookupByLibrary.simpleMessage("Финиш"),
        "orderPlaced":
            MessageLookupByLibrary.simpleMessage("Ордер размещен успешно"),
        "orderSmartCard":
            MessageLookupByLibrary.simpleMessage("Заказать смарт-карту"),
        "orderSmartCardConfirmation": MessageLookupByLibrary.simpleMessage(
            "Вы подтверждаете заказ смарт-карты?"),
        "orderStartTime": MessageLookupByLibrary.simpleMessage("Старт"),
        "orderType": MessageLookupByLibrary.simpleMessage("Тип"),
        "password": MessageLookupByLibrary.simpleMessage("Пароль"),
        "passwordDoNotMatch":
            MessageLookupByLibrary.simpleMessage("Пароли не совпадают"),
        "passwordInfo": MessageLookupByLibrary.simpleMessage(
            "Этот пароль будет использоваться для разблокировки вашего кошелька и использования криптовалюты"),
        "passwordSymbolAmount": MessageLookupByLibrary.simpleMessage(
            "Пароль должен быть не менее 8 символов"),
        "paste": MessageLookupByLibrary.simpleMessage("Вставить"),
        "pinCodesNotMatch":
            MessageLookupByLibrary.simpleMessage("PIN-коды не совпадают"),
        "premDiscount": MessageLookupByLibrary.simpleMessage(
            "Скидка 10% на продление подписки на Premium аккаунт"),
        "price": MessageLookupByLibrary.simpleMessage("Цена"),
        "priceToken": m15,
        "privateKeys": MessageLookupByLibrary.simpleMessage("Приватные ключи"),
        "proDesc0": m16,
        "proDesc1": m17,
        "proDesc12": m18,
        "proDesc2": MessageLookupByLibrary.simpleMessage(
            "Это аккаунты, которые создаются одним пользователем. Удобное переключение между аккаунтами. Будет доступно создание до 3х аккаунтов на одном устройстве."),
        "proDesc2h": MessageLookupByLibrary.simpleMessage("Мультиаккаунт"),
        "proDesc3": MessageLookupByLibrary.simpleMessage(
            "Для заключения внебиржевой сделок не требуется резервировать средства накануне торгов, так как участники сделок рассчитываются напрямую. Как правило внебиржевые сделки заключаются с отсроченными расчётами."),
        "proDesc3h": MessageLookupByLibrary.simpleMessage("OTC сделки"),
        "proDesc4": MessageLookupByLibrary.simpleMessage(
            "Платите меньше за транзакции и за обмен криптовалюты. Все операции будут проходить по самым низким ценам."),
        "proDesc4h": MessageLookupByLibrary.simpleMessage("Сниженные комиссии"),
        "proDesc5": MessageLookupByLibrary.simpleMessage(
            "Получайте последние обновления самые первые. Новые технологи будут сразу в вашем кошельке."),
        "proDesc5h": MessageLookupByLibrary.simpleMessage("Последние новинки"),
        "proDesc6": MessageLookupByLibrary.simpleMessage(
            "Мы ответим Вам на любой из вопросов. Поможем решить любую вашу проблему."),
        "proDesc6h": MessageLookupByLibrary.simpleMessage(
            "Индивидуальная техническая поддержка"),
        "proDiscount": MessageLookupByLibrary.simpleMessage(
            "Скидка 15% на продление подписки на Pro аккаунт"),
        "proVpnDialog": MessageLookupByLibrary.simpleMessage(
            "Поздравляем, вы получили бесплатную пробную версию VPN на три месяца."),
        "purchaseDate": MessageLookupByLibrary.simpleMessage("Дата покупки"),
        "purchasePro": m19,
        "purchaseVpn": MessageLookupByLibrary.simpleMessage("Купить VPN"),
        "purchased": MessageLookupByLibrary.simpleMessage("Куплено"),
        "receive": MessageLookupByLibrary.simpleMessage("Получить"),
        "received": MessageLookupByLibrary.simpleMessage("Получено"),
        "recommended": MessageLookupByLibrary.simpleMessage("Рекомендуется"),
        "refresh": MessageLookupByLibrary.simpleMessage("Обновить"),
        "reload": MessageLookupByLibrary.simpleMessage("Обновить"),
        "rename": MessageLookupByLibrary.simpleMessage("Переименовать"),
        "renewPremium":
            MessageLookupByLibrary.simpleMessage("Продлить Premium"),
        "renewPro": MessageLookupByLibrary.simpleMessage("Продлить PRO"),
        "repeatPassword":
            MessageLookupByLibrary.simpleMessage("Повторите пароль"),
        "repeatPin": MessageLookupByLibrary.simpleMessage("Повторите PIN-код"),
        "restoreWallet":
            MessageLookupByLibrary.simpleMessage("Восстановить кошелек"),
        "scanNewQR":
            MessageLookupByLibrary.simpleMessage("Сканировать новый QR"),
        "securityCenter": MessageLookupByLibrary.simpleMessage("Безопасность"),
        "sell": MessageLookupByLibrary.simpleMessage("Продать"),
        "sellToken": m20,
        "send": MessageLookupByLibrary.simpleMessage("Отправить"),
        "sent": MessageLookupByLibrary.simpleMessage("Отправлено"),
        "serviceUnavailable":
            MessageLookupByLibrary.simpleMessage("Сервис временно недоступен"),
        "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
        "share": MessageLookupByLibrary.simpleMessage("Поделиться"),
        "showTransactions":
            MessageLookupByLibrary.simpleMessage("Показать транзакции"),
        "showVpnKey": MessageLookupByLibrary.simpleMessage("Показать ключ"),
        "signTx": MessageLookupByLibrary.simpleMessage("Подписать транзакцию"),
        "sixDigitsNeeded":
            MessageLookupByLibrary.simpleMessage("Необходимо 6 цифр"),
        "slow": MessageLookupByLibrary.simpleMessage("Медленно"),
        "smartCard": MessageLookupByLibrary.simpleMessage("Смарт-карта"),
        "smartCardMarketText1": MessageLookupByLibrary.simpleMessage(
            "Смарт-карта предназначена для безопасного хранения ваших средств"),
        "smartCardMarketText2": MessageLookupByLibrary.simpleMessage(
            "Для доступа к кошельку смарт-карту надо приложить к задней стороне телефона с NFC."),
        "smartCardMarketText3": MessageLookupByLibrary.simpleMessage(
            "Карта обеспечивает двухфакторную авторизацию."),
        "smartCardMarketText4": MessageLookupByLibrary.simpleMessage(
            "При оформлении карты Вам будет начислено 13 TBCC."),
        "smartCardOrdered": MessageLookupByLibrary.simpleMessage(
            "Поздравляем! Вы уже заказали смарт-карту."),
        "smartContractCall":
            MessageLookupByLibrary.simpleMessage("Вызов смарт-контракта"),
        "start": MessageLookupByLibrary.simpleMessage("Начать"),
        "startupText0": MessageLookupByLibrary.simpleMessage(
            "TBCC Wallet - блокчейн\nкошелёк для всех"),
        "startupText1": MessageLookupByLibrary.simpleMessage(
            "Покупайте, храните, отправляйте, обменивайте свою криптовалюту с помощью простого в использовании и удобного кошелька"),
        "subExpires": MessageLookupByLibrary.simpleMessage("Подписка истекает"),
        "subExpiresDate": m21,
        "success": MessageLookupByLibrary.simpleMessage("Успешно"),
        "supportCenter": MessageLookupByLibrary.simpleMessage("Помощь"),
        "swap": MessageLookupByLibrary.simpleMessage("Обмен"),
        "swapBep2": MessageLookupByLibrary.simpleMessage(
            "Обменять TBCC(BEP2) на TBCC(BEP8)"),
        "swapBep8": MessageLookupByLibrary.simpleMessage(
            "Обменять TBCC(BEP8) на TBCC(BEP2)"),
        "swapStandardSent": MessageLookupByLibrary.simpleMessage(
            "Заявка на обмен отправлена успешно. В случае успеха средства будут начислены в течение 5 минут."),
        "swapTo": m22,
        "target": MessageLookupByLibrary.simpleMessage("Цель"),
        "tbcc_exchange": MessageLookupByLibrary.simpleMessage(
            "Команда TBCC запустила торговую платформу на базе технологий Binance – TBCC.COM\nРазработчики ориентированной на цифровые активы торговой платформы TBCC.COM объявили о ее запуске и активной реализации задач в рамках road map.\nВокруг биржи уже сформировалось большое комьюнити. Участников криптосообщества привлек большой пул ликвидности TBCC.COM, а также наличие в листинге торговой платформы монет для стейкинга и фарминга на любой вкус.\nКоманда проекта представила авторскую систему обучения трейдингу. Также новички могут почерпнуть знания через общение с опытными пользователями в комьюнити TBCC.COM. Среди дополнительных плюсов торговой платформы можно выделить оперативную службу поддержки и наличие авторской системы торговых сигналов.\nПроект построен на базе технических решений Binance CLOUD, которые в феврале 2020 года представила команда криптобиржи Binance. Инструменты помогли разработчикам создать высокотехнологичную, безопасную торговую платформу TBCC.COM.\nТехнические решения Binance CLOUD позволяют запускать криптобиржи, в соответствии со стандартами Binance – одной из самых популярных площадок для трейдинга цифровыми активами, лидера рынка по совокупному объему торгов, согласно данным ресурса CoinMarketCap.\n\nСкачать мобильное приложение TBCC Exchange:"),
        "thirdPartyApp": MessageLookupByLibrary.simpleMessage(
            "Стороннее приложение. Проверяйте данные перед подтверждением транзакций"),
        "to": MessageLookupByLibrary.simpleMessage("Кому"),
        "toPay": MessageLookupByLibrary.simpleMessage("К оплате"),
        "tokenPrice": m23,
        "total": MessageLookupByLibrary.simpleMessage("Итого"),
        "totalFundBal": MessageLookupByLibrary.simpleMessage("Баланс фонда"),
        "touchSensor": MessageLookupByLibrary.simpleMessage("Сенсорный датчик"),
        "transactions": MessageLookupByLibrary.simpleMessage("Транзакции"),
        "transferSuccessText": MessageLookupByLibrary.simpleMessage(
            "Транзакция отправлена в обработку. Скоро появится в истории."),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Попробуйте еще раз."),
        "typeCorrectAmount":
            MessageLookupByLibrary.simpleMessage("Введите корректное кол-во"),
        "typeCorrectPrice":
            MessageLookupByLibrary.simpleMessage("Введите корректную цену"),
        "updateAvailable":
            MessageLookupByLibrary.simpleMessage("Обновление доступно"),
        "updateDownloading":
            MessageLookupByLibrary.simpleMessage("Загрузка обновления..."),
        "updateDownlodaded":
            MessageLookupByLibrary.simpleMessage("Обновление загружено"),
        "useBiometrics":
            MessageLookupByLibrary.simpleMessage("Использовать биометрию"),
        "usedFunds":
            MessageLookupByLibrary.simpleMessage("Использовано средств"),
        "verifyMnemonic": MessageLookupByLibrary.simpleMessage(
            "Нажмите на слова из вашего секретного ключа"),
        "vote": MessageLookupByLibrary.simpleMessage("Голосовать"),
        "voting": MessageLookupByLibrary.simpleMessage("Голосование"),
        "vpnDescription": MessageLookupByLibrary.simpleMessage(
            "Попробуйте первый децентрализованный VPN на основе блокчейна. Даже суперкомпьютер не получит доступа к вашим данным."),
        "waitingConfirmation":
            MessageLookupByLibrary.simpleMessage("Ожидание подтверждения"),
        "wallet": MessageLookupByLibrary.simpleMessage("Кошелёк"),
        "wantToBuy": MessageLookupByLibrary.simpleMessage("Хочу купить"),
        "wantToSwap": MessageLookupByLibrary.simpleMessage("Хочу обменять"),
        "whatsNew": MessageLookupByLibrary.simpleMessage("Что нового"),
        "withdraw": MessageLookupByLibrary.simpleMessage("Вывести"),
        "writeSmartCard":
            MessageLookupByLibrary.simpleMessage("Записать смарт-карту"),
        "wrongAddr": MessageLookupByLibrary.simpleMessage("Неверный адрес"),
        "wrongPin": MessageLookupByLibrary.simpleMessage("Неправильный PIN"),
        "youAttachedCard": MessageLookupByLibrary.simpleMessage(
            "Вы привязали свою смарт-карту"),
        "youPay": MessageLookupByLibrary.simpleMessage("Вы платите"),
        "youProNow": m24,
        "youReceive": MessageLookupByLibrary.simpleMessage("Вы получите"),
        "yourBalance": MessageLookupByLibrary.simpleMessage("Ваш баланс")
      };
}
