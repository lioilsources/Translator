import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';

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
    Locale('cs'),
    Locale('en'),
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

  /// No description provided for @serverToken.
  ///
  /// In cs, this message translates to:
  /// **'Přístupový token'**
  String get serverToken;

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
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
