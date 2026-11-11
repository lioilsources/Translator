// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Tulkki';

  @override
  String get me => 'Minä';

  @override
  String get colleague => 'Kollega';

  @override
  String get start => 'Aloita';

  @override
  String get modeLabel => 'Tila';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Pidä pohjassa ja puhu';

  @override
  String get modeStreaming => 'Jatkuva';

  @override
  String get chooseLanguage => 'Valitse kieli';

  @override
  String get history => 'Historia';

  @override
  String get settings => 'Asetukset';

  @override
  String get serverUrl => 'Palvelimen osoite';

  @override
  String get save => 'Tallenna';

  @override
  String get statusConnecting => 'Yhdistetään…';

  @override
  String get statusListening => 'Kuuntelen';

  @override
  String get statusRecording => 'Kuulen sinut';

  @override
  String get statusTranslating => 'Käännän';

  @override
  String get statusSpeaking => 'Puhun';

  @override
  String get statusPaused => 'Tauolla';

  @override
  String get itWasMe => 'Se olin minä';

  @override
  String get promptAuto => 'Puhukaa yksi kerrallaan';

  @override
  String get promptPtt => 'Pidä pohjassa ja puhu';

  @override
  String get pause => 'Tauko';

  @override
  String get resume => 'Jatka';

  @override
  String get soundOn => 'Ääni päällä';

  @override
  String get soundOff => 'Vain teksti';

  @override
  String get endConversation => 'Lopeta';

  @override
  String get volumeHint => 'Laita äänenvoimakkuus täysille';

  @override
  String get share => 'Jaa';

  @override
  String get delete => 'Poista';

  @override
  String get noHistory => 'Ei vielä keskusteluja';

  @override
  String get micDenied =>
      'Ilman mikrofonin käyttöoikeutta tämä ei toimi. Salli se asetuksissa.';

  @override
  String get errorConnection => 'Yhteys palvelimeen katkesi';

  @override
  String get errorBackend => 'Käännöspalvelu ei ole nyt käytettävissä';

  @override
  String get errorVoice => 'Ääni ei ole käytettävissä, teksti jää';

  @override
  String get errorBusy => 'Palvelin on täynnä, yritä hetken kuluttua uudelleen';

  @override
  String get errorTooLong => 'Puheenvuoro on liian pitkä';

  @override
  String get errorGeneric => 'Jokin meni pieleen';

  @override
  String get cancel => 'Peruuta';

  @override
  String get voiceLibrary => 'Äänet';

  @override
  String get voiceAdd => 'Nauhoita ääni';

  @override
  String get voiceEmpty => 'Täällä ei ole vielä yhtään ääntä.';

  @override
  String get voiceServerError => 'Äänet eivät ole nyt käytettävissä';

  @override
  String get voiceDefault => 'Oletusääni';

  @override
  String get voiceName => 'Nimeä ääni';

  @override
  String get voiceConsent =>
      'Hyväksyn, että äänitallenteeni tallennetaan palvelimelle ja sitä käytetään lausumaan käännökset minun äänelläni. Se on biometrinen tieto, saan nauhoittaa vain itseni, ja peruutan suostumuksen poistamalla äänen.';

  @override
  String get voiceReadThis =>
      'Paina painiketta ja lue luonnollisesti 30 sekuntia:';

  @override
  String get voiceSampleText =>
      'Hyvää päivää, tämä on näyte äänestäni. Puhun rauhallisesti ja luonnollisesti, kuin juttelisin jonkun kanssa pöydän ääressä. Eilen kävin kävelyllä, matkalla tapasin vanhan ystävän ja joimme yhdessä kahvit. Hän kertoi matkastaan merenrannalle, säästä, hyvästä ruoasta ja siitä, mitä työssä on tulossa. Kun olen lukenut loppuun, jatkan omin sanoin, kunnes nauhoitus päättyy.';

  @override
  String get voiceRecord => 'Nauhoita 30 sekuntia';

  @override
  String voiceRecording(int seconds) {
    return 'Nauhoitetaan, $seconds s jäljellä';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Poistetaanko ääni $name?';
  }

  @override
  String get voiceDeleteBody => 'Tallenne poistetaan palvelimelta pysyvästi.';

  @override
  String get serverChecking => 'tarkistetaan…';

  @override
  String get serverReady => 'valmis';

  @override
  String get serverDegraded => 'kaikki ei toimi';

  @override
  String get serverOffline => 'ei saatavilla';

  @override
  String get serverRecheck => 'Tarkista uudelleen';

  @override
  String get deviceTier => 'Tämä laite';

  @override
  String get deviceTierPublic => 'Perus: rajoitettu käännösaika päivässä';

  @override
  String get deviceTierTester => 'Testaaja: pidempi käännös ja oma ääni';

  @override
  String get deviceTierUnknown => 'Palvelin ei nyt vastaa';

  @override
  String get inviteCode => 'Kutsukoodi';

  @override
  String get inviteHelp => 'Sovelluksen tekijältä, avaa testauksen';

  @override
  String get inviteWrong => 'Tämä koodi ei kelpaa';

  @override
  String get inviteUnavailable =>
      'Koodia ei voi nyt tarkistaa, yritä myöhemmin';

  @override
  String get errorQuota =>
      'Tämän päivän käännösminuutit on käytetty, huomenna taas';

  @override
  String get voiceNeedsInvite =>
      'Oma ääni on toistaiseksi vain kutsukoodin saaneille testaajille';
}
