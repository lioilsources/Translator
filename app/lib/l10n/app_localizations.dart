import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('gu'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('kn'),
    Locale('ko'),
    Locale('ml'),
    Locale('mr'),
    Locale('ms'),
    Locale('nb'),
    Locale('nl'),
    Locale('or'),
    Locale('pa'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('pt', 'PT'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sv'),
    Locale('ta'),
    Locale('te'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In cs, this message translates to:
  /// **'Tlumočník'**
  String get appTitle;

  /// No description provided for @me.
  ///
  /// In cs, this message translates to:
  /// **'Já'**
  String get me;

  /// No description provided for @colleague.
  ///
  /// In cs, this message translates to:
  /// **'Kolega'**
  String get colleague;

  /// No description provided for @start.
  ///
  /// In cs, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @modeLabel.
  ///
  /// In cs, this message translates to:
  /// **'Režim'**
  String get modeLabel;

  /// No description provided for @modeAuto.
  ///
  /// In cs, this message translates to:
  /// **'Auto'**
  String get modeAuto;

  /// No description provided for @modePtt.
  ///
  /// In cs, this message translates to:
  /// **'Podržet a mluvit'**
  String get modePtt;

  /// No description provided for @modeStreaming.
  ///
  /// In cs, this message translates to:
  /// **'Průběžně'**
  String get modeStreaming;

  /// No description provided for @chooseLanguage.
  ///
  /// In cs, this message translates to:
  /// **'Vyberte jazyk'**
  String get chooseLanguage;

  /// No description provided for @history.
  ///
  /// In cs, this message translates to:
  /// **'Historie'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In cs, this message translates to:
  /// **'Nastavení'**
  String get settings;

  /// No description provided for @serverUrl.
  ///
  /// In cs, this message translates to:
  /// **'Adresa serveru'**
  String get serverUrl;

  /// No description provided for @save.
  ///
  /// In cs, this message translates to:
  /// **'Uložit'**
  String get save;

  /// No description provided for @statusConnecting.
  ///
  /// In cs, this message translates to:
  /// **'Připojuji…'**
  String get statusConnecting;

  /// No description provided for @statusListening.
  ///
  /// In cs, this message translates to:
  /// **'Poslouchám'**
  String get statusListening;

  /// No description provided for @statusRecording.
  ///
  /// In cs, this message translates to:
  /// **'Slyším vás'**
  String get statusRecording;

  /// No description provided for @statusTranslating.
  ///
  /// In cs, this message translates to:
  /// **'Překládám'**
  String get statusTranslating;

  /// No description provided for @statusSpeaking.
  ///
  /// In cs, this message translates to:
  /// **'Mluvím'**
  String get statusSpeaking;

  /// No description provided for @statusPaused.
  ///
  /// In cs, this message translates to:
  /// **'Pozastaveno'**
  String get statusPaused;

  /// No description provided for @itWasMe.
  ///
  /// In cs, this message translates to:
  /// **'To jsem já'**
  String get itWasMe;

  /// No description provided for @promptAuto.
  ///
  /// In cs, this message translates to:
  /// **'Mluvte po jednom'**
  String get promptAuto;

  /// No description provided for @promptPtt.
  ///
  /// In cs, this message translates to:
  /// **'Držte a mluvte'**
  String get promptPtt;

  /// No description provided for @pause.
  ///
  /// In cs, this message translates to:
  /// **'Pauza'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In cs, this message translates to:
  /// **'Pokračovat'**
  String get resume;

  /// No description provided for @soundOn.
  ///
  /// In cs, this message translates to:
  /// **'Zvuk zapnutý'**
  String get soundOn;

  /// No description provided for @soundOff.
  ///
  /// In cs, this message translates to:
  /// **'Jen text'**
  String get soundOff;

  /// No description provided for @endConversation.
  ///
  /// In cs, this message translates to:
  /// **'Ukončit'**
  String get endConversation;

  /// No description provided for @volumeHint.
  ///
  /// In cs, this message translates to:
  /// **'Dejte hlasitost na maximum'**
  String get volumeHint;

  /// No description provided for @share.
  ///
  /// In cs, this message translates to:
  /// **'Sdílet'**
  String get share;

  /// No description provided for @delete.
  ///
  /// In cs, this message translates to:
  /// **'Smazat'**
  String get delete;

  /// No description provided for @noHistory.
  ///
  /// In cs, this message translates to:
  /// **'Zatím žádné rozhovory'**
  String get noHistory;

  /// No description provided for @micDenied.
  ///
  /// In cs, this message translates to:
  /// **'Bez přístupu k mikrofonu to nepůjde. Povolte ho v nastavení.'**
  String get micDenied;

  /// No description provided for @errorConnection.
  ///
  /// In cs, this message translates to:
  /// **'Spojení se serverem se ztratilo'**
  String get errorConnection;

  /// No description provided for @errorBackend.
  ///
  /// In cs, this message translates to:
  /// **'Překladová služba teď není dostupná'**
  String get errorBackend;

  /// No description provided for @errorVoice.
  ///
  /// In cs, this message translates to:
  /// **'Hlas není dostupný, zůstává text'**
  String get errorVoice;

  /// No description provided for @errorBusy.
  ///
  /// In cs, this message translates to:
  /// **'Server je plný, zkuste to za chvíli'**
  String get errorBusy;

  /// No description provided for @errorTooLong.
  ///
  /// In cs, this message translates to:
  /// **'Promluva je moc dlouhá'**
  String get errorTooLong;

  /// No description provided for @errorGeneric.
  ///
  /// In cs, this message translates to:
  /// **'Něco se pokazilo'**
  String get errorGeneric;

  /// No description provided for @cancel.
  ///
  /// In cs, this message translates to:
  /// **'Zrušit'**
  String get cancel;

  /// No description provided for @voiceLibrary.
  ///
  /// In cs, this message translates to:
  /// **'Moje hlasy'**
  String get voiceLibrary;

  /// No description provided for @voiceAdd.
  ///
  /// In cs, this message translates to:
  /// **'Nahrát hlas'**
  String get voiceAdd;

  /// No description provided for @voiceEmpty.
  ///
  /// In cs, this message translates to:
  /// **'Zatím tu není žádný hlas.'**
  String get voiceEmpty;

  /// No description provided for @voiceServerError.
  ///
  /// In cs, this message translates to:
  /// **'Hlasy teď nejsou dostupné'**
  String get voiceServerError;

  /// No description provided for @voiceDefault.
  ///
  /// In cs, this message translates to:
  /// **'Výchozí hlas'**
  String get voiceDefault;

  /// No description provided for @voiceName.
  ///
  /// In cs, this message translates to:
  /// **'Pojmenujte hlas'**
  String get voiceName;

  /// No description provided for @voiceConsent.
  ///
  /// In cs, this message translates to:
  /// **'Souhlasím s uložením nahrávky mého hlasu na serveru a s jejím použitím k překladu mým hlasem. Je to biometrický údaj, nahrávat smím jen sebe a souhlas zruším smazáním hlasu.'**
  String get voiceConsent;

  /// No description provided for @voiceReadThis.
  ///
  /// In cs, this message translates to:
  /// **'Stiskněte tlačítko a 30 sekund přirozeně čtěte:'**
  String get voiceReadThis;

  /// No description provided for @voiceSampleText.
  ///
  /// In cs, this message translates to:
  /// **'Dobrý den, tohle je ukázka mého hlasu. Mluvím klidně a přirozeně, tak jako bych si s někým povídal u stolu. Včera jsem šel na procházku, cestou jsem potkal starého kamaráda a dali jsme si spolu kávu. Vyprávěl mi o své cestě k moři, o počasí, o dobrém jídle i o tom, co ho čeká v práci. Až to dočtu, klidně budu pokračovat vlastními slovy, dokud neskončí nahrávání.'**
  String get voiceSampleText;

  /// No description provided for @voiceRecord.
  ///
  /// In cs, this message translates to:
  /// **'Nahrát 30 sekund'**
  String get voiceRecord;

  /// No description provided for @voiceRecording.
  ///
  /// In cs, this message translates to:
  /// **'Nahrávám, zbývá {seconds} s'**
  String voiceRecording(int seconds);

  /// No description provided for @voiceDeleteTitle.
  ///
  /// In cs, this message translates to:
  /// **'Smazat hlas {name}?'**
  String voiceDeleteTitle(String name);

  /// No description provided for @voiceDeleteBody.
  ///
  /// In cs, this message translates to:
  /// **'Nahrávka se trvale smaže ze serveru.'**
  String get voiceDeleteBody;

  /// No description provided for @serverChecking.
  ///
  /// In cs, this message translates to:
  /// **'ověřuji…'**
  String get serverChecking;

  /// No description provided for @serverReady.
  ///
  /// In cs, this message translates to:
  /// **'připraveno'**
  String get serverReady;

  /// No description provided for @serverDegraded.
  ///
  /// In cs, this message translates to:
  /// **'neběží vše'**
  String get serverDegraded;

  /// No description provided for @serverOffline.
  ///
  /// In cs, this message translates to:
  /// **'nedostupné'**
  String get serverOffline;

  /// No description provided for @serverRecheck.
  ///
  /// In cs, this message translates to:
  /// **'Znovu ověřit'**
  String get serverRecheck;

  /// No description provided for @deviceTier.
  ///
  /// In cs, this message translates to:
  /// **'Toto zařízení'**
  String get deviceTier;

  /// No description provided for @deviceTierPublic.
  ///
  /// In cs, this message translates to:
  /// **'Základní: omezený čas překladu denně'**
  String get deviceTierPublic;

  /// No description provided for @deviceTierTester.
  ///
  /// In cs, this message translates to:
  /// **'Tester: delší překlad a vlastní hlas'**
  String get deviceTierTester;

  /// No description provided for @deviceTierUnknown.
  ///
  /// In cs, this message translates to:
  /// **'Server teď neodpovídá'**
  String get deviceTierUnknown;

  /// No description provided for @inviteCode.
  ///
  /// In cs, this message translates to:
  /// **'Zvací kód'**
  String get inviteCode;

  /// No description provided for @inviteHelp.
  ///
  /// In cs, this message translates to:
  /// **'Od autora appky, odemkne testování'**
  String get inviteHelp;

  /// No description provided for @inviteWrong.
  ///
  /// In cs, this message translates to:
  /// **'Tenhle kód neplatí'**
  String get inviteWrong;

  /// No description provided for @inviteUnavailable.
  ///
  /// In cs, this message translates to:
  /// **'Kód teď nejde ověřit, zkuste to později'**
  String get inviteUnavailable;

  /// No description provided for @errorQuota.
  ///
  /// In cs, this message translates to:
  /// **'Dnešní minuty překladu došly, zítra zase'**
  String get errorQuota;

  /// No description provided for @voiceNeedsInvite.
  ///
  /// In cs, this message translates to:
  /// **'Vlastní hlas je zatím jen pro testery se zvacím kódem'**
  String get voiceNeedsInvite;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'ca',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'fi',
    'fr',
    'gu',
    'he',
    'hi',
    'hr',
    'hu',
    'id',
    'it',
    'ja',
    'kn',
    'ko',
    'ml',
    'mr',
    'ms',
    'nb',
    'nl',
    'or',
    'pa',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'sl',
    'sv',
    'ta',
    'te',
    'th',
    'tr',
    'uk',
    'ur',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
          case 'PT':
            return AppLocalizationsPtPt();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'gu':
      return AppLocalizationsGu();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'kn':
      return AppLocalizationsKn();
    case 'ko':
      return AppLocalizationsKo();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'ms':
      return AppLocalizationsMs();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sv':
      return AppLocalizationsSv();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'ur':
      return AppLocalizationsUr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
