// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'दुभाषी';

  @override
  String get me => 'मी';

  @override
  String get colleague => 'सहकारी';

  @override
  String get start => 'सुरू करा';

  @override
  String get modeLabel => 'मोड';

  @override
  String get modeAuto => 'ऑटो';

  @override
  String get modePtt => 'दाबून धरा आणि बोला';

  @override
  String get modeStreaming => 'सलग';

  @override
  String get chooseLanguage => 'भाषा निवडा';

  @override
  String get history => 'इतिहास';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get serverUrl => 'सर्व्हरचा पत्ता';

  @override
  String get save => 'जतन करा';

  @override
  String get statusConnecting => 'जोडत आहे…';

  @override
  String get statusListening => 'ऐकत आहे';

  @override
  String get statusRecording => 'तुम्हाला ऐकत आहे';

  @override
  String get statusTranslating => 'भाषांतर करत आहे';

  @override
  String get statusSpeaking => 'बोलत आहे';

  @override
  String get statusPaused => 'थांबवले';

  @override
  String get itWasMe => 'तो मी होतो';

  @override
  String get promptAuto => 'एकामागून एक बोला';

  @override
  String get promptPtt => 'दाबून धरा आणि बोला';

  @override
  String get pause => 'थांबा';

  @override
  String get resume => 'पुढे चालू ठेवा';

  @override
  String get soundOn => 'आवाज सुरू';

  @override
  String get soundOff => 'फक्त मजकूर';

  @override
  String get endConversation => 'संपवा';

  @override
  String get volumeHint => 'आवाज कमाल करा';

  @override
  String get share => 'शेअर करा';

  @override
  String get delete => 'हटवा';

  @override
  String get noHistory => 'अजून कोणतीही संभाषणे नाहीत';

  @override
  String get micDenied =>
      'मायक्रोफोनच्या परवानगीशिवाय चालणार नाही. सेटिंग्जमध्ये परवानगी द्या.';

  @override
  String get errorConnection => 'सर्व्हरशी संपर्क तुटला';

  @override
  String get errorBackend => 'भाषांतर सेवा आत्ता उपलब्ध नाही';

  @override
  String get errorVoice => 'आवाज उपलब्ध नाही, मजकूर राहतो';

  @override
  String get errorBusy => 'सर्व्हर भरलेला आहे, थोड्या वेळाने प्रयत्न करा';

  @override
  String get errorTooLong => 'बोलणे खूप लांब आहे';

  @override
  String get errorGeneric => 'काहीतरी चुकले';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get voiceLibrary => 'माझे आवाज';

  @override
  String get voiceAdd => 'आवाज रेकॉर्ड करा';

  @override
  String get voiceEmpty => 'इथे अजून कोणताही आवाज नाही.';

  @override
  String get voiceServerError => 'आवाज आत्ता उपलब्ध नाहीत';

  @override
  String get voiceDefault => 'डीफॉल्ट आवाज';

  @override
  String get voiceName => 'आवाजाला नाव द्या';

  @override
  String get voiceConsent =>
      'माझ्या आवाजाचे रेकॉर्डिंग सर्व्हरवर साठवले जाण्यास आणि भाषांतरे माझ्या आवाजात बोलण्यासाठी वापरले जाण्यास मी संमती देतो. ही बायोमेट्रिक माहिती आहे, मी फक्त स्वतःलाच रेकॉर्ड करू शकतो आणि आवाज हटवून मी संमती मागे घेतो.';

  @override
  String get voiceReadThis => 'बटण दाबा आणि 30 सेकंद नैसर्गिकपणे वाचा:';

  @override
  String get voiceSampleText =>
      'नमस्कार, हा माझ्या आवाजाचा नमुना आहे. टेबलावर कोणाशी तरी गप्पा मारत असल्यासारखा मी शांतपणे आणि नैसर्गिकपणे बोलत आहे. काल मी फिरायला गेलो होतो, वाटेत एक जुना मित्र भेटला आणि आम्ही एकत्र कॉफी घेतली. त्याने समुद्राच्या सहलीबद्दल, हवामानाबद्दल, चांगल्या जेवणाबद्दल आणि कामावर त्याची वाट पाहत असलेल्या गोष्टींबद्दल सांगितले. वाचून झाल्यावर रेकॉर्डिंग संपेपर्यंत मी माझ्याच शब्दांत बोलत राहीन.';

  @override
  String get voiceRecord => '30 सेकंद रेकॉर्ड करा';

  @override
  String voiceRecording(int seconds) {
    return 'रेकॉर्डिंग सुरू आहे, $seconds से. बाकी';
  }

  @override
  String voiceDeleteTitle(String name) {
    return '$name आवाज हटवायचा?';
  }

  @override
  String get voiceDeleteBody => 'रेकॉर्डिंग सर्व्हरवरून कायमचे हटवले जाईल.';

  @override
  String get serverChecking => 'तपासत आहे…';

  @override
  String get serverReady => 'तयार';

  @override
  String get serverDegraded => 'सर्व काही चालत नाही';

  @override
  String get serverOffline => 'उपलब्ध नाही';

  @override
  String get serverRecheck => 'पुन्हा तपासा';

  @override
  String get deviceTier => 'हे उपकरण';

  @override
  String get deviceTierPublic => 'मूलभूत: दररोज मर्यादित भाषांतर वेळ';

  @override
  String get deviceTierTester => 'टेस्टर: जास्त भाषांतर आणि स्वतःचा आवाज';

  @override
  String get deviceTierUnknown => 'सर्व्हर आत्ता उत्तर देत नाही';

  @override
  String get inviteCode => 'आमंत्रण कोड';

  @override
  String get inviteHelp => 'ऍपच्या लेखकाकडून, चाचणी खुली करतो';

  @override
  String get inviteWrong => 'हा कोड वैध नाही';

  @override
  String get inviteUnavailable => 'कोड आत्ता तपासता येत नाही, नंतर प्रयत्न करा';

  @override
  String get errorQuota => 'आजची भाषांतराची मिनिटे संपली, उद्या पुन्हा';

  @override
  String get voiceNeedsInvite =>
      'स्वतःचा आवाज सध्या फक्त आमंत्रण कोड असलेल्या टेस्टरसाठी आहे';
}
