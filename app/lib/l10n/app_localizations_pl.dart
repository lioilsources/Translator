// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Tłumacz';

  @override
  String get me => 'Ja';

  @override
  String get colleague => 'Kolega';

  @override
  String get start => 'Start';

  @override
  String get modeLabel => 'Tryb';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Przytrzymaj i mów';

  @override
  String get modeStreaming => 'Ciągły';

  @override
  String get chooseLanguage => 'Wybierz język';

  @override
  String get history => 'Historia';

  @override
  String get settings => 'Ustawienia';

  @override
  String get serverUrl => 'Adres serwera';

  @override
  String get save => 'Zapisz';

  @override
  String get statusConnecting => 'Łączenie…';

  @override
  String get statusListening => 'Słucham';

  @override
  String get statusRecording => 'Słyszę cię';

  @override
  String get statusTranslating => 'Tłumaczę';

  @override
  String get statusSpeaking => 'Mówię';

  @override
  String get statusPaused => 'Wstrzymano';

  @override
  String get itWasMe => 'To byłem ja';

  @override
  String get promptAuto => 'Mówcie po kolei';

  @override
  String get promptPtt => 'Przytrzymaj i mów';

  @override
  String get pause => 'Pauza';

  @override
  String get resume => 'Wznów';

  @override
  String get soundOn => 'Dźwięk włączony';

  @override
  String get soundOff => 'Tylko tekst';

  @override
  String get endConversation => 'Zakończ';

  @override
  String get volumeHint => 'Ustaw głośność na maksimum';

  @override
  String get share => 'Udostępnij';

  @override
  String get delete => 'Usuń';

  @override
  String get noHistory => 'Brak rozmów';

  @override
  String get micDenied =>
      'Bez dostępu do mikrofonu to nie zadziała. Zezwól na niego w ustawieniach.';

  @override
  String get errorConnection => 'Utracono połączenie z serwerem';

  @override
  String get errorBackend => 'Usługa tłumaczenia jest teraz niedostępna';

  @override
  String get errorVoice => 'Głos jest niedostępny, zostaje tekst';

  @override
  String get errorBusy => 'Serwer jest pełny, spróbuj za chwilę';

  @override
  String get errorTooLong => 'Wypowiedź jest za długa';

  @override
  String get errorGeneric => 'Coś poszło nie tak';

  @override
  String get cancel => 'Anuluj';

  @override
  String get voiceLibrary => 'Moje głosy';

  @override
  String get voiceAdd => 'Nagraj głos';

  @override
  String get voiceEmpty => 'Nie ma tu jeszcze żadnego głosu.';

  @override
  String get voiceServerError => 'Głosy są teraz niedostępne';

  @override
  String get voiceDefault => 'Głos domyślny';

  @override
  String get voiceName => 'Nazwij głos';

  @override
  String get voiceConsent =>
      'Zgadzam się na zapisanie nagrania mojego głosu na serwerze i użycie go do wypowiadania tłumaczeń moim głosem. To dane biometryczne, wolno mi nagrywać tylko siebie, a zgodę cofam, usuwając głos.';

  @override
  String get voiceReadThis =>
      'Naciśnij przycisk i czytaj naturalnie przez 30 sekund:';

  @override
  String get voiceSampleText =>
      'Dzień dobry, to próbka mojego głosu. Mówię spokojnie i naturalnie, jakbym rozmawiał z kimś przy stole. Wczoraj poszedłem na spacer, po drodze spotkałem starego przyjaciela i razem wypiliśmy kawę. Opowiadał mi o swojej podróży nad morze, o pogodzie, o dobrym jedzeniu i o tym, co go czeka w pracy. Kiedy skończę czytać, spokojnie będę mówił dalej własnymi słowami, dopóki nagranie się nie zakończy.';

  @override
  String get voiceRecord => 'Nagraj 30 sekund';

  @override
  String voiceRecording(int seconds) {
    return 'Nagrywam, zostało $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Usunąć głos $name?';
  }

  @override
  String get voiceDeleteBody => 'Nagranie zostanie trwale usunięte z serwera.';

  @override
  String get serverChecking => 'sprawdzam…';

  @override
  String get serverReady => 'gotowe';

  @override
  String get serverDegraded => 'nie wszystko działa';

  @override
  String get serverOffline => 'niedostępne';

  @override
  String get serverRecheck => 'Sprawdź ponownie';

  @override
  String get deviceTier => 'To urządzenie';

  @override
  String get deviceTierPublic =>
      'Podstawowy: ograniczony czas tłumaczenia dziennie';

  @override
  String get deviceTierTester => 'Tester: dłuższe tłumaczenie i własny głos';

  @override
  String get deviceTierUnknown => 'Serwer teraz nie odpowiada';

  @override
  String get inviteCode => 'Kod zaproszenia';

  @override
  String get inviteHelp => 'Od autora aplikacji, odblokowuje testowanie';

  @override
  String get inviteWrong => 'Ten kod jest nieprawidłowy';

  @override
  String get inviteUnavailable =>
      'Kodu nie można teraz sprawdzić, spróbuj później';

  @override
  String get errorQuota =>
      'Dzisiejsze minuty tłumaczenia się skończyły, jutro znów będą';

  @override
  String get voiceNeedsInvite =>
      'Własny głos jest na razie tylko dla testerów z kodem zaproszenia';
}
