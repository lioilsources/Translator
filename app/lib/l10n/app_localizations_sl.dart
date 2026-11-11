// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get appTitle => 'Tolmač';

  @override
  String get me => 'Jaz';

  @override
  String get colleague => 'Kolega';

  @override
  String get start => 'Začni';

  @override
  String get modeLabel => 'Način';

  @override
  String get modeAuto => 'Samodejno';

  @override
  String get modePtt => 'Drži in govori';

  @override
  String get modeStreaming => 'Sprotno';

  @override
  String get chooseLanguage => 'Izberite jezik';

  @override
  String get history => 'Zgodovina';

  @override
  String get settings => 'Nastavitve';

  @override
  String get serverUrl => 'Naslov strežnika';

  @override
  String get save => 'Shrani';

  @override
  String get statusConnecting => 'Povezovanje …';

  @override
  String get statusListening => 'Poslušam';

  @override
  String get statusRecording => 'Slišim vas';

  @override
  String get statusTranslating => 'Prevajam';

  @override
  String get statusSpeaking => 'Govorim';

  @override
  String get statusPaused => 'Zaustavljeno';

  @override
  String get itWasMe => 'To sem bil jaz';

  @override
  String get promptAuto => 'Govorite po vrsti';

  @override
  String get promptPtt => 'Držite in govorite';

  @override
  String get pause => 'Premor';

  @override
  String get resume => 'Nadaljuj';

  @override
  String get soundOn => 'Zvok vklopljen';

  @override
  String get soundOff => 'Samo besedilo';

  @override
  String get endConversation => 'Končaj';

  @override
  String get volumeHint => 'Nastavite glasnost na največ';

  @override
  String get share => 'Deli';

  @override
  String get delete => 'Izbriši';

  @override
  String get noHistory => 'Še ni pogovorov';

  @override
  String get micDenied =>
      'Brez dostopa do mikrofona ne bo šlo. Dovolite ga v nastavitvah.';

  @override
  String get errorConnection => 'Povezava s strežnikom je bila izgubljena';

  @override
  String get errorBackend => 'Prevajalska storitev trenutno ni na voljo';

  @override
  String get errorVoice => 'Glas ni na voljo, ostane besedilo';

  @override
  String get errorBusy => 'Strežnik je poln, poskusite čez trenutek';

  @override
  String get errorTooLong => 'Izjava je predolga';

  @override
  String get errorGeneric => 'Nekaj je šlo narobe';

  @override
  String get cancel => 'Prekliči';

  @override
  String get voiceLibrary => 'Moji glasovi';

  @override
  String get voiceAdd => 'Posnemi glas';

  @override
  String get voiceEmpty => 'Tu še ni nobenega glasu.';

  @override
  String get voiceServerError => 'Glasovi trenutno niso na voljo';

  @override
  String get voiceDefault => 'Privzeti glas';

  @override
  String get voiceName => 'Poimenujte glas';

  @override
  String get voiceConsent =>
      'Soglašam, da se posnetek mojega glasu shrani na strežniku in uporablja za izgovorjavo prevodov z mojim glasom. Gre za biometrični podatek, snemam lahko samo sebe, soglasje pa prekličem z izbrisom glasu.';

  @override
  String get voiceReadThis => 'Pritisnite gumb in 30 sekund naravno berite:';

  @override
  String get voiceSampleText =>
      'Dober dan, to je vzorec mojega glasu. Govorim mirno in naravno, kot da bi se pogovarjal z nekom za mizo. Včeraj sem šel na sprehod, na poti sem srečal starega prijatelja in skupaj sva popila kavo. Pripovedoval mi je o svojem potovanju na morje, o vremenu, o dobri hrani in o tem, kaj ga čaka v službi. Ko dokončam branje, bom mirno nadaljeval z lastnimi besedami, dokler se snemanje ne konča.';

  @override
  String get voiceRecord => 'Posnemi 30 sekund';

  @override
  String voiceRecording(int seconds) {
    return 'Snemam, še $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Izbrišem glas $name?';
  }

  @override
  String get voiceDeleteBody => 'Posnetek bo trajno izbrisan s strežnika.';

  @override
  String get serverChecking => 'preverjam …';

  @override
  String get serverReady => 'pripravljeno';

  @override
  String get serverDegraded => 'ne deluje vse';

  @override
  String get serverOffline => 'ni na voljo';

  @override
  String get serverRecheck => 'Preveri znova';

  @override
  String get deviceTier => 'Ta naprava';

  @override
  String get deviceTierPublic => 'Osnovno: omejen čas prevajanja na dan';

  @override
  String get deviceTierTester =>
      'Preizkuševalec: daljše prevajanje in lasten glas';

  @override
  String get deviceTierUnknown => 'Strežnik trenutno ne odgovarja';

  @override
  String get inviteCode => 'Koda povabila';

  @override
  String get inviteHelp => 'Od avtorja aplikacije, odklene preizkušanje';

  @override
  String get inviteWrong => 'Ta koda ne velja';

  @override
  String get inviteUnavailable =>
      'Kode trenutno ni mogoče preveriti, poskusite pozneje';

  @override
  String get errorQuota =>
      'Današnje minute prevajanja so porabljene, jutri spet';

  @override
  String get voiceNeedsInvite =>
      'Lasten glas je zaenkrat samo za preizkuševalce s kodo povabila';
}
