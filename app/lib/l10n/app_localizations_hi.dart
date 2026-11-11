// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'दुभाषिया';

  @override
  String get me => 'मैं';

  @override
  String get colleague => 'सहकर्मी';

  @override
  String get start => 'शुरू करें';

  @override
  String get modeLabel => 'मोड';

  @override
  String get modeAuto => 'ऑटो';

  @override
  String get modePtt => 'दबाए रखें और बोलें';

  @override
  String get modeStreaming => 'लगातार';

  @override
  String get chooseLanguage => 'भाषा चुनें';

  @override
  String get history => 'इतिहास';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get serverUrl => 'सर्वर का पता';

  @override
  String get save => 'सहेजें';

  @override
  String get statusConnecting => 'जुड़ रहा है…';

  @override
  String get statusListening => 'सुन रहा हूँ';

  @override
  String get statusRecording => 'आपको सुन रहा हूँ';

  @override
  String get statusTranslating => 'अनुवाद कर रहा हूँ';

  @override
  String get statusSpeaking => 'बोल रहा हूँ';

  @override
  String get statusPaused => 'रुका हुआ';

  @override
  String get itWasMe => 'वह मैं था';

  @override
  String get promptAuto => 'एक-एक करके बोलें';

  @override
  String get promptPtt => 'दबाए रखें और बोलें';

  @override
  String get pause => 'रोकें';

  @override
  String get resume => 'जारी रखें';

  @override
  String get soundOn => 'आवाज़ चालू';

  @override
  String get soundOff => 'केवल टेक्स्ट';

  @override
  String get endConversation => 'समाप्त करें';

  @override
  String get volumeHint => 'वॉल्यूम अधिकतम पर रखें';

  @override
  String get share => 'साझा करें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get noHistory => 'अभी कोई बातचीत नहीं है';

  @override
  String get micDenied =>
      'माइक्रोफ़ोन की अनुमति के बिना यह नहीं चलेगा। सेटिंग्स में अनुमति दें।';

  @override
  String get errorConnection => 'सर्वर से कनेक्शन टूट गया';

  @override
  String get errorBackend => 'अनुवाद सेवा अभी उपलब्ध नहीं है';

  @override
  String get errorVoice => 'आवाज़ उपलब्ध नहीं है, टेक्स्ट बना रहेगा';

  @override
  String get errorBusy => 'सर्वर भरा हुआ है, थोड़ी देर बाद कोशिश करें';

  @override
  String get errorTooLong => 'बोला हुआ बहुत लंबा है';

  @override
  String get errorGeneric => 'कुछ गड़बड़ हो गई';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get voiceLibrary => 'मेरी आवाज़ें';

  @override
  String get voiceAdd => 'आवाज़ रिकॉर्ड करें';

  @override
  String get voiceEmpty => 'यहाँ अभी कोई आवाज़ नहीं है।';

  @override
  String get voiceServerError => 'आवाज़ें अभी उपलब्ध नहीं हैं';

  @override
  String get voiceDefault => 'डिफ़ॉल्ट आवाज़';

  @override
  String get voiceName => 'आवाज़ का नाम रखें';

  @override
  String get voiceConsent =>
      'मैं सहमत हूँ कि मेरी आवाज़ की रिकॉर्डिंग सर्वर पर सहेजी जाए और अनुवाद मेरी आवाज़ में बोलने के लिए इस्तेमाल हो। यह बायोमेट्रिक डेटा है, मैं केवल स्वयं को रिकॉर्ड कर सकता हूँ, और आवाज़ हटाकर मैं सहमति वापस लेता हूँ।';

  @override
  String get voiceReadThis =>
      'बटन दबाएँ और 30 सेकंड तक स्वाभाविक रूप से पढ़ें:';

  @override
  String get voiceSampleText =>
      'नमस्ते, यह मेरी आवाज़ का नमूना है। मैं शांति और स्वाभाविक ढंग से बोल रहा हूँ, जैसे किसी के साथ मेज़ पर बातें कर रहा हूँ। कल मैं टहलने गया था, रास्ते में एक पुराना दोस्त मिला और हमने साथ कॉफ़ी पी। उसने मुझे समुद्र की अपनी यात्रा, मौसम, अच्छे खाने और काम पर अपने इंतज़ार कर रहे कामों के बारे में बताया। पढ़ना पूरा होने पर मैं अपने शब्दों में तब तक बोलता रहूँगा जब तक रिकॉर्डिंग खत्म न हो।';

  @override
  String get voiceRecord => '30 सेकंड रिकॉर्ड करें';

  @override
  String voiceRecording(int seconds) {
    return 'रिकॉर्ड हो रहा है, $seconds से. बाकी';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'आवाज़ $name हटाएँ?';
  }

  @override
  String get voiceDeleteBody =>
      'रिकॉर्डिंग सर्वर से हमेशा के लिए हटा दी जाएगी।';

  @override
  String get serverChecking => 'जाँच हो रही है…';

  @override
  String get serverReady => 'तैयार';

  @override
  String get serverDegraded => 'सब कुछ नहीं चल रहा';

  @override
  String get serverOffline => 'उपलब्ध नहीं';

  @override
  String get serverRecheck => 'फिर से जाँचें';

  @override
  String get deviceTier => 'यह डिवाइस';

  @override
  String get deviceTierPublic => 'बुनियादी: रोज़ सीमित अनुवाद समय';

  @override
  String get deviceTierTester => 'टेस्टर: लंबा अनुवाद और अपनी आवाज़';

  @override
  String get deviceTierUnknown => 'सर्वर अभी जवाब नहीं दे रहा';

  @override
  String get inviteCode => 'आमंत्रण कोड';

  @override
  String get inviteHelp => 'ऐप के लेखक से, परीक्षण खोलता है';

  @override
  String get inviteWrong => 'यह कोड मान्य नहीं है';

  @override
  String get inviteUnavailable =>
      'कोड अभी जाँचा नहीं जा सकता, बाद में कोशिश करें';

  @override
  String get errorQuota => 'आज के अनुवाद के मिनट खत्म हो गए, कल फिर मिलेंगे';

  @override
  String get voiceNeedsInvite =>
      'अपनी आवाज़ फ़िलहाल सिर्फ़ आमंत्रण कोड वाले टेस्टरों के लिए है';
}
