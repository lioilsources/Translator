// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Перекладач';

  @override
  String get me => 'Я';

  @override
  String get colleague => 'Колега';

  @override
  String get start => 'Старт';

  @override
  String get modeLabel => 'Режим';

  @override
  String get modeAuto => 'Авто';

  @override
  String get modePtt => 'Утримуйте й говоріть';

  @override
  String get modeStreaming => 'Безперервно';

  @override
  String get chooseLanguage => 'Виберіть мову';

  @override
  String get history => 'Історія';

  @override
  String get settings => 'Налаштування';

  @override
  String get serverUrl => 'Адреса сервера';

  @override
  String get save => 'Зберегти';

  @override
  String get statusConnecting => 'Підключення…';

  @override
  String get statusListening => 'Слухаю';

  @override
  String get statusRecording => 'Чую вас';

  @override
  String get statusTranslating => 'Перекладаю';

  @override
  String get statusSpeaking => 'Говорю';

  @override
  String get statusPaused => 'Пауза';

  @override
  String get itWasMe => 'Це був я';

  @override
  String get promptAuto => 'Говоріть по черзі';

  @override
  String get promptPtt => 'Утримуйте й говоріть';

  @override
  String get pause => 'Пауза';

  @override
  String get resume => 'Продовжити';

  @override
  String get soundOn => 'Звук увімкнено';

  @override
  String get soundOff => 'Лише текст';

  @override
  String get endConversation => 'Завершити';

  @override
  String get volumeHint => 'Поставте гучність на максимум';

  @override
  String get share => 'Поділитися';

  @override
  String get delete => 'Видалити';

  @override
  String get noHistory => 'Розмов поки немає';

  @override
  String get micDenied =>
      'Без доступу до мікрофона не вийде. Дозвольте його в налаштуваннях.';

  @override
  String get errorConnection => 'Зв\'язок із сервером втрачено';

  @override
  String get errorBackend => 'Служба перекладу зараз недоступна';

  @override
  String get errorVoice => 'Голос недоступний, залишається текст';

  @override
  String get errorBusy => 'Сервер перевантажений, спробуйте за хвилину';

  @override
  String get errorTooLong => 'Репліка надто довга';

  @override
  String get errorGeneric => 'Щось пішло не так';

  @override
  String get cancel => 'Скасувати';

  @override
  String get voiceLibrary => 'Мої голоси';

  @override
  String get voiceAdd => 'Записати голос';

  @override
  String get voiceEmpty => 'Голосів тут поки немає.';

  @override
  String get voiceServerError => 'Голоси зараз недоступні';

  @override
  String get voiceDefault => 'Голос за замовчуванням';

  @override
  String get voiceName => 'Назвіть голос';

  @override
  String get voiceConsent =>
      'Я погоджуюся на зберігання запису мого голосу на сервері та його використання для озвучення перекладів моїм голосом. Це біометричні дані, я можу записувати лише себе, а згоду відкликаю видаленням голосу.';

  @override
  String get voiceReadThis => 'Натисніть кнопку й читайте природно 30 секунд:';

  @override
  String get voiceSampleText =>
      'Добрий день, це зразок мого голосу. Я говорю спокійно й природно, наче розмовляю з кимось за столом. Учора я ходив на прогулянку, дорогою зустрів старого друга, і ми разом випили кави. Він розповів мені про свою поїздку до моря, про погоду, про смачну їжу та про те, що на нього чекає на роботі. Коли дочитаю, я просто продовжу своїми словами, доки запис не закінчиться.';

  @override
  String get voiceRecord => 'Записати 30 секунд';

  @override
  String voiceRecording(int seconds) {
    return 'Триває запис, залишилося $seconds с';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Видалити голос $name?';
  }

  @override
  String get voiceDeleteBody => 'Запис буде безповоротно видалено з сервера.';

  @override
  String get serverChecking => 'перевіряю…';

  @override
  String get serverReady => 'готово';

  @override
  String get serverDegraded => 'працює не все';

  @override
  String get serverOffline => 'недоступно';

  @override
  String get serverRecheck => 'Перевірити знову';

  @override
  String get deviceTier => 'Цей пристрій';

  @override
  String get deviceTierPublic => 'Базовий: обмежений час перекладу на день';

  @override
  String get deviceTierTester => 'Тестер: довший переклад і власний голос';

  @override
  String get deviceTierUnknown => 'Сервер зараз не відповідає';

  @override
  String get inviteCode => 'Код запрошення';

  @override
  String get inviteHelp => 'Від автора застосунку, відкриває тестування';

  @override
  String get inviteWrong => 'Цей код недійсний';

  @override
  String get inviteUnavailable =>
      'Зараз код перевірити не можна, спробуйте пізніше';

  @override
  String get errorQuota =>
      'Хвилини перекладу на сьогодні закінчилися, завтра будуть знову';

  @override
  String get voiceNeedsInvite =>
      'Власний голос поки доступний лише тестерам із кодом запрошення';
}
