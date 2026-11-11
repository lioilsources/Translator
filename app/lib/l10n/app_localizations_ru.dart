// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Переводчик';

  @override
  String get me => 'Я';

  @override
  String get colleague => 'Коллега';

  @override
  String get start => 'Старт';

  @override
  String get modeLabel => 'Режим';

  @override
  String get modeAuto => 'Авто';

  @override
  String get modePtt => 'Удерживайте и говорите';

  @override
  String get modeStreaming => 'Непрерывно';

  @override
  String get chooseLanguage => 'Выберите язык';

  @override
  String get history => 'История';

  @override
  String get settings => 'Настройки';

  @override
  String get serverUrl => 'Адрес сервера';

  @override
  String get save => 'Сохранить';

  @override
  String get statusConnecting => 'Подключение…';

  @override
  String get statusListening => 'Слушаю';

  @override
  String get statusRecording => 'Слышу вас';

  @override
  String get statusTranslating => 'Перевожу';

  @override
  String get statusSpeaking => 'Говорю';

  @override
  String get statusPaused => 'Пауза';

  @override
  String get itWasMe => 'Это был я';

  @override
  String get promptAuto => 'Говорите по очереди';

  @override
  String get promptPtt => 'Удерживайте и говорите';

  @override
  String get pause => 'Пауза';

  @override
  String get resume => 'Продолжить';

  @override
  String get soundOn => 'Звук включён';

  @override
  String get soundOff => 'Только текст';

  @override
  String get endConversation => 'Завершить';

  @override
  String get volumeHint => 'Поставьте громкость на максимум';

  @override
  String get share => 'Поделиться';

  @override
  String get delete => 'Удалить';

  @override
  String get noHistory => 'Разговоров пока нет';

  @override
  String get micDenied =>
      'Без доступа к микрофону не получится. Разрешите его в настройках.';

  @override
  String get errorConnection => 'Связь с сервером потеряна';

  @override
  String get errorBackend => 'Служба перевода сейчас недоступна';

  @override
  String get errorVoice => 'Голос недоступен, остаётся текст';

  @override
  String get errorBusy => 'Сервер перегружен, попробуйте через минуту';

  @override
  String get errorTooLong => 'Реплика слишком длинная';

  @override
  String get errorGeneric => 'Что-то пошло не так';

  @override
  String get cancel => 'Отмена';

  @override
  String get voiceLibrary => 'Мои голоса';

  @override
  String get voiceAdd => 'Записать голос';

  @override
  String get voiceEmpty => 'Голосов здесь пока нет.';

  @override
  String get voiceServerError => 'Голоса сейчас недоступны';

  @override
  String get voiceDefault => 'Голос по умолчанию';

  @override
  String get voiceName => 'Назовите голос';

  @override
  String get voiceConsent =>
      'Я согласен на хранение записи моего голоса на сервере и её использование для озвучивания переводов моим голосом. Это биометрические данные, я могу записывать только себя, а согласие отзываю удалением голоса.';

  @override
  String get voiceReadThis => 'Нажмите кнопку и читайте естественно 30 секунд:';

  @override
  String get voiceSampleText =>
      'Добрый день, это образец моего голоса. Я говорю спокойно и естественно, как будто беседую с кем-то за столом. Вчера я ходил гулять, по дороге встретил старого друга, и мы вместе выпили кофе. Он рассказал мне о своей поездке к морю, о погоде, о вкусной еде и о том, что его ждёт на работе. Когда я дочитаю, я просто продолжу своими словами, пока запись не закончится.';

  @override
  String get voiceRecord => 'Записать 30 секунд';

  @override
  String voiceRecording(int seconds) {
    return 'Идёт запись, осталось $seconds с';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Удалить голос $name?';
  }

  @override
  String get voiceDeleteBody => 'Запись будет безвозвратно удалена с сервера.';

  @override
  String get serverChecking => 'проверяю…';

  @override
  String get serverReady => 'готово';

  @override
  String get serverDegraded => 'работает не всё';

  @override
  String get serverOffline => 'недоступно';

  @override
  String get serverRecheck => 'Проверить снова';

  @override
  String get deviceTier => 'Это устройство';

  @override
  String get deviceTierPublic => 'Базовый: ограниченное время перевода в день';

  @override
  String get deviceTierTester =>
      'Тестер: более длинный перевод и собственный голос';

  @override
  String get deviceTierUnknown => 'Сервер сейчас не отвечает';

  @override
  String get inviteCode => 'Код приглашения';

  @override
  String get inviteHelp => 'От автора приложения, открывает тестирование';

  @override
  String get inviteWrong => 'Этот код недействителен';

  @override
  String get inviteUnavailable =>
      'Сейчас код проверить нельзя, попробуйте позже';

  @override
  String get errorQuota =>
      'Минуты перевода на сегодня закончились, завтра будут снова';

  @override
  String get voiceNeedsInvite =>
      'Собственный голос пока доступен только тестерам с кодом приглашения';
}
