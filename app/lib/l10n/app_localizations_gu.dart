// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'દુભાષિયો';

  @override
  String get me => 'હું';

  @override
  String get colleague => 'સહકર્મી';

  @override
  String get start => 'શરૂ કરો';

  @override
  String get modeLabel => 'મોડ';

  @override
  String get modeAuto => 'ઑટો';

  @override
  String get modePtt => 'દબાવી રાખો અને બોલો';

  @override
  String get modeStreaming => 'સતત';

  @override
  String get chooseLanguage => 'ભાષા પસંદ કરો';

  @override
  String get history => 'ઇતિહાસ';

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get serverUrl => 'સર્વરનું સરનામું';

  @override
  String get save => 'સાચવો';

  @override
  String get statusConnecting => 'જોડાઈ રહ્યું છે…';

  @override
  String get statusListening => 'સાંભળી રહ્યો છું';

  @override
  String get statusRecording => 'તમને સાંભળું છું';

  @override
  String get statusTranslating => 'અનુવાદ કરી રહ્યો છું';

  @override
  String get statusSpeaking => 'બોલી રહ્યો છું';

  @override
  String get statusPaused => 'થોભાવ્યું';

  @override
  String get itWasMe => 'એ હું હતો';

  @override
  String get promptAuto => 'એક પછી એક બોલો';

  @override
  String get promptPtt => 'દબાવી રાખો અને બોલો';

  @override
  String get pause => 'થોભો';

  @override
  String get resume => 'ચાલુ રાખો';

  @override
  String get soundOn => 'અવાજ ચાલુ';

  @override
  String get soundOff => 'ફક્ત ટેક્સ્ટ';

  @override
  String get endConversation => 'સમાપ્ત કરો';

  @override
  String get volumeHint => 'વૉલ્યુમ મહત્તમ કરો';

  @override
  String get share => 'શેર કરો';

  @override
  String get delete => 'કાઢી નાખો';

  @override
  String get noHistory => 'હજી કોઈ વાતચીત નથી';

  @override
  String get micDenied =>
      'માઇક્રોફોનની પરવાનગી વગર ચાલશે નહીં. સેટિંગ્સમાં પરવાનગી આપો.';

  @override
  String get errorConnection => 'સર્વર સાથેનું જોડાણ તૂટી ગયું';

  @override
  String get errorBackend => 'અનુવાદ સેવા હમણાં ઉપલબ્ધ નથી';

  @override
  String get errorVoice => 'અવાજ ઉપલબ્ધ નથી, ટેક્સ્ટ રહે છે';

  @override
  String get errorBusy => 'સર્વર ભરેલું છે, થોડી વારમાં ફરી પ્રયત્ન કરો';

  @override
  String get errorTooLong => 'બોલાયેલું ખૂબ લાંબું છે';

  @override
  String get errorGeneric => 'કંઈક ખોટું થયું';

  @override
  String get cancel => 'રદ કરો';

  @override
  String get voiceLibrary => 'મારા અવાજો';

  @override
  String get voiceAdd => 'અવાજ રેકોર્ડ કરો';

  @override
  String get voiceEmpty => 'અહીં હજી કોઈ અવાજ નથી.';

  @override
  String get voiceServerError => 'અવાજો હમણાં ઉપલબ્ધ નથી';

  @override
  String get voiceDefault => 'ડિફૉલ્ટ અવાજ';

  @override
  String get voiceName => 'અવાજને નામ આપો';

  @override
  String get voiceConsent =>
      'હું મારા અવાજનું રેકોર્ડિંગ સર્વર પર સાચવવા અને અનુવાદ મારા અવાજમાં બોલવા માટે વાપરવાની સંમતિ આપું છું. તે બાયોમેટ્રિક માહિતી છે, હું ફક્ત મારો પોતાનો અવાજ રેકોર્ડ કરી શકું, અને અવાજ કાઢી નાખીને હું સંમતિ પાછી ખેંચું છું.';

  @override
  String get voiceReadThis => 'બટન દબાવો અને 30 સેકન્ડ સ્વાભાવિક રીતે વાંચો:';

  @override
  String get voiceSampleText =>
      'નમસ્તે, આ મારા અવાજનો નમૂનો છે. હું શાંતિથી અને સ્વાભાવિક રીતે બોલું છું, જાણે ટેબલ પર કોઈ સાથે વાતો કરતો હોઉં. ગઈકાલે હું ફરવા ગયો હતો, રસ્તામાં જૂના મિત્રને મળ્યો અને અમે સાથે કૉફી પીધી. તેણે દરિયા કિનારાની પોતાની સફર, હવામાન, સારા ભોજન અને કામ પર તેની રાહ જોતી બાબતો વિશે કહ્યું. વાંચવાનું પૂરું થાય પછી રેકોર્ડિંગ પૂરું થાય ત્યાં સુધી હું મારા પોતાના શબ્દોમાં ચાલુ રાખીશ.';

  @override
  String get voiceRecord => '30 સેકન્ડ રેકોર્ડ કરો';

  @override
  String voiceRecording(int seconds) {
    return 'રેકોર્ડ થઈ રહ્યું છે, $seconds સે. બાકી';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'અવાજ $name કાઢી નાખવો?';
  }

  @override
  String get voiceDeleteBody => 'રેકોર્ડિંગ સર્વરમાંથી કાયમ માટે કાઢી નંખાશે.';

  @override
  String get serverChecking => 'તપાસી રહ્યું છે…';

  @override
  String get serverReady => 'તૈયાર';

  @override
  String get serverDegraded => 'બધું ચાલતું નથી';

  @override
  String get serverOffline => 'ઉપલબ્ધ નથી';

  @override
  String get serverRecheck => 'ફરી તપાસો';

  @override
  String get deviceTier => 'આ ઉપકરણ';

  @override
  String get deviceTierPublic => 'મૂળભૂત: રોજ મર્યાદિત અનુવાદ સમય';

  @override
  String get deviceTierTester => 'ટેસ્ટર: લાંબો અનુવાદ અને પોતાનો અવાજ';

  @override
  String get deviceTierUnknown => 'સર્વર હમણાં જવાબ આપતું નથી';

  @override
  String get inviteCode => 'આમંત્રણ કોડ';

  @override
  String get inviteHelp => 'ઍપના લેખક પાસેથી, પરીક્ષણ ખોલે છે';

  @override
  String get inviteWrong => 'આ કોડ માન્ય નથી';

  @override
  String get inviteUnavailable => 'કોડ હમણાં ચકાસી શકાતો નથી, પછી પ્રયત્ન કરો';

  @override
  String get errorQuota => 'આજની અનુવાદ મિનિટો પૂરી થઈ, કાલે ફરી મળશે';

  @override
  String get voiceNeedsInvite =>
      'પોતાનો અવાજ હાલ ફક્ત આમંત્રણ કોડ ધરાવતા ટેસ્ટરો માટે છે';
}
