// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Tolmács';

  @override
  String get me => 'Én';

  @override
  String get colleague => 'Kolléga';

  @override
  String get start => 'Indítás';

  @override
  String get modeLabel => 'Mód';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Tartsd nyomva és beszélj';

  @override
  String get modeStreaming => 'Folyamatos';

  @override
  String get chooseLanguage => 'Válassz nyelvet';

  @override
  String get history => 'Előzmények';

  @override
  String get settings => 'Beállítások';

  @override
  String get serverUrl => 'Szerver címe';

  @override
  String get save => 'Mentés';

  @override
  String get statusConnecting => 'Csatlakozás…';

  @override
  String get statusListening => 'Hallgatom';

  @override
  String get statusRecording => 'Hallak';

  @override
  String get statusTranslating => 'Fordítok';

  @override
  String get statusSpeaking => 'Beszélek';

  @override
  String get statusPaused => 'Szüneteltetve';

  @override
  String get itWasMe => 'Én voltam';

  @override
  String get promptAuto => 'Beszéljetek egymás után';

  @override
  String get promptPtt => 'Tartsd nyomva és beszélj';

  @override
  String get pause => 'Szünet';

  @override
  String get resume => 'Folytatás';

  @override
  String get soundOn => 'Hang be';

  @override
  String get soundOff => 'Csak szöveg';

  @override
  String get endConversation => 'Befejezés';

  @override
  String get volumeHint => 'Állítsd a hangerőt a maximumra';

  @override
  String get share => 'Megosztás';

  @override
  String get delete => 'Törlés';

  @override
  String get noHistory => 'Még nincs beszélgetés';

  @override
  String get micDenied =>
      'Mikrofonhozzáférés nélkül nem megy. Engedélyezd a beállításokban.';

  @override
  String get errorConnection => 'Megszakadt a kapcsolat a szerverrel';

  @override
  String get errorBackend => 'A fordítási szolgáltatás most nem érhető el';

  @override
  String get errorVoice => 'A hang nem érhető el, a szöveg marad';

  @override
  String get errorBusy => 'A szerver tele van, próbáld meg kicsit később';

  @override
  String get errorTooLong => 'A megszólalás túl hosszú';

  @override
  String get errorGeneric => 'Valami elromlott';

  @override
  String get cancel => 'Mégse';

  @override
  String get voiceLibrary => 'Hangjaim';

  @override
  String get voiceAdd => 'Hang felvétele';

  @override
  String get voiceEmpty => 'Itt még nincs hang.';

  @override
  String get voiceServerError => 'A hangok most nem érhetők el';

  @override
  String get voiceDefault => 'Alapértelmezett hang';

  @override
  String get voiceName => 'Nevezd el a hangot';

  @override
  String get voiceConsent =>
      'Hozzájárulok, hogy a hangfelvételem a szerveren tárolódjon, és a fordítások az én hangomon szólaljanak meg. Ez biometrikus adat, csak magamat vehetem fel, a hozzájárulásomat a hang törlésével vonom vissza.';

  @override
  String get voiceReadThis =>
      'Nyomd meg a gombot, és olvass természetesen 30 másodpercig:';

  @override
  String get voiceSampleText =>
      'Jó napot, ez egy minta a hangomból. Nyugodtan és természetesen beszélek, mintha az asztalnál beszélgetnék valakivel. Tegnap sétálni mentem, útközben összefutottam egy régi barátommal, és együtt ittunk egy kávét. Mesélt a tengerparti útjáról, az időjárásról, a jó ételekről és arról, hogy mi vár rá a munkában. Ha befejeztem az olvasást, a saját szavaimmal folytatom, amíg a felvétel véget nem ér.';

  @override
  String get voiceRecord => '30 másodperc felvétele';

  @override
  String voiceRecording(int seconds) {
    return 'Felvétel folyik, még $seconds mp';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Törlöd a(z) $name hangot?';
  }

  @override
  String get voiceDeleteBody => 'A felvétel véglegesen törlődik a szerverről.';

  @override
  String get serverChecking => 'ellenőrzés…';

  @override
  String get serverReady => 'kész';

  @override
  String get serverDegraded => 'nem működik minden';

  @override
  String get serverOffline => 'nem elérhető';

  @override
  String get serverRecheck => 'Ellenőrzés újra';

  @override
  String get deviceTier => 'Ez az eszköz';

  @override
  String get deviceTierPublic => 'Alap: napi korlátozott fordítási idő';

  @override
  String get deviceTierTester => 'Tesztelő: hosszabb fordítás és saját hang';

  @override
  String get deviceTierUnknown => 'A szerver most nem válaszol';

  @override
  String get inviteCode => 'Meghívókód';

  @override
  String get inviteHelp => 'Az alkalmazás készítőjétől, feloldja a tesztelést';

  @override
  String get inviteWrong => 'Ez a kód nem érvényes';

  @override
  String get inviteUnavailable =>
      'A kódot most nem lehet ellenőrizni, próbáld később';

  @override
  String get errorQuota => 'A mai fordítási percek elfogytak, holnap újra lesz';

  @override
  String get voiceNeedsInvite =>
      'A saját hang egyelőre csak meghívókóddal rendelkező tesztelőknek érhető el';
}
