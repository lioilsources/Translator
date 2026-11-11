// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'দোভাষী';

  @override
  String get me => 'আমি';

  @override
  String get colleague => 'সহকর্মী';

  @override
  String get start => 'শুরু';

  @override
  String get modeLabel => 'মোড';

  @override
  String get modeAuto => 'স্বয়ংক্রিয়';

  @override
  String get modePtt => 'চেপে ধরে বলুন';

  @override
  String get modeStreaming => 'ধারাবাহিক';

  @override
  String get chooseLanguage => 'ভাষা বেছে নিন';

  @override
  String get history => 'ইতিহাস';

  @override
  String get settings => 'সেটিংস';

  @override
  String get serverUrl => 'সার্ভারের ঠিকানা';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get statusConnecting => 'সংযোগ হচ্ছে…';

  @override
  String get statusListening => 'শুনছি';

  @override
  String get statusRecording => 'আপনাকে শুনছি';

  @override
  String get statusTranslating => 'অনুবাদ করছি';

  @override
  String get statusSpeaking => 'বলছি';

  @override
  String get statusPaused => 'বিরতি';

  @override
  String get itWasMe => 'ওটা আমি';

  @override
  String get promptAuto => 'একজন একজন করে বলুন';

  @override
  String get promptPtt => 'চেপে ধরে বলুন';

  @override
  String get pause => 'বিরতি';

  @override
  String get resume => 'চালিয়ে যান';

  @override
  String get soundOn => 'শব্দ চালু';

  @override
  String get soundOff => 'শুধু লেখা';

  @override
  String get endConversation => 'শেষ করুন';

  @override
  String get volumeHint => 'ভলিউম সর্বোচ্চ করুন';

  @override
  String get share => 'শেয়ার';

  @override
  String get delete => 'মুছুন';

  @override
  String get noHistory => 'এখনও কোনো কথোপকথন নেই';

  @override
  String get micDenied =>
      'মাইক্রোফোনের অনুমতি ছাড়া চলবে না। সেটিংসে অনুমতি দিন।';

  @override
  String get errorConnection => 'সার্ভারের সংযোগ বিচ্ছিন্ন হয়েছে';

  @override
  String get errorBackend => 'অনুবাদ সেবা এখন পাওয়া যাচ্ছে না';

  @override
  String get errorVoice => 'কণ্ঠ পাওয়া যাচ্ছে না, লেখা থাকছে';

  @override
  String get errorBusy => 'সার্ভার ব্যস্ত, একটু পরে চেষ্টা করুন';

  @override
  String get errorTooLong => 'কথাটি অনেক লম্বা';

  @override
  String get errorGeneric => 'কিছু একটা ভুল হয়েছে';

  @override
  String get cancel => 'বাতিল';

  @override
  String get voiceLibrary => 'আমার কণ্ঠ';

  @override
  String get voiceAdd => 'কণ্ঠ রেকর্ড করুন';

  @override
  String get voiceEmpty => 'এখানে এখনও কোনো কণ্ঠ নেই।';

  @override
  String get voiceServerError => 'কণ্ঠ এখন পাওয়া যাচ্ছে না';

  @override
  String get voiceDefault => 'ডিফল্ট কণ্ঠ';

  @override
  String get voiceName => 'কণ্ঠের নাম দিন';

  @override
  String get voiceConsent =>
      'আমি আমার কণ্ঠের রেকর্ডিং সার্ভারে সংরক্ষণ এবং আমার কণ্ঠে অনুবাদ বলার জন্য ব্যবহারে সম্মত। এটি বায়োমেট্রিক তথ্য, আমি শুধু নিজের কণ্ঠই রেকর্ড করতে পারি, আর কণ্ঠ মুছে দিলে আমার সম্মতি প্রত্যাহার হয়।';

  @override
  String get voiceReadThis => 'বোতাম চেপে ৩০ সেকেন্ড স্বাভাবিকভাবে পড়ুন:';

  @override
  String get voiceSampleText =>
      'নমস্কার, এটা আমার কণ্ঠের নমুনা। আমি শান্তভাবে ও স্বাভাবিকভাবে বলছি, যেন টেবিলে কারও সঙ্গে গল্প করছি। গতকাল আমি হাঁটতে গিয়েছিলাম, পথে এক পুরনো বন্ধুর সঙ্গে দেখা হলো আর আমরা একসঙ্গে কফি খেলাম। সে সমুদ্রে তার ভ্রমণের কথা, আবহাওয়ার কথা, ভালো খাবারের কথা এবং কাজে তার জন্য কী অপেক্ষা করছে তা বলল। পড়া শেষ হলে রেকর্ডিং শেষ না হওয়া পর্যন্ত আমি নিজের কথায় বলতে থাকব।';

  @override
  String get voiceRecord => '৩০ সেকেন্ড রেকর্ড করুন';

  @override
  String voiceRecording(int seconds) {
    return 'রেকর্ড হচ্ছে, আর $seconds সে.';
  }

  @override
  String voiceDeleteTitle(String name) {
    return '$name কণ্ঠ মুছবেন?';
  }

  @override
  String get voiceDeleteBody => 'রেকর্ডিং সার্ভার থেকে চিরতরে মুছে যাবে।';

  @override
  String get serverChecking => 'যাচাই হচ্ছে…';

  @override
  String get serverReady => 'প্রস্তুত';

  @override
  String get serverDegraded => 'সব চলছে না';

  @override
  String get serverOffline => 'পাওয়া যাচ্ছে না';

  @override
  String get serverRecheck => 'আবার যাচাই করুন';

  @override
  String get deviceTier => 'এই ডিভাইস';

  @override
  String get deviceTierPublic => 'সাধারণ: প্রতিদিন সীমিত অনুবাদের সময়';

  @override
  String get deviceTierTester => 'টেস্টার: দীর্ঘ অনুবাদ ও নিজের কণ্ঠ';

  @override
  String get deviceTierUnknown => 'সার্ভার এখন সাড়া দিচ্ছে না';

  @override
  String get inviteCode => 'আমন্ত্রণ কোড';

  @override
  String get inviteHelp => 'অ্যাপের নির্মাতার কাছ থেকে, পরীক্ষা চালু করে';

  @override
  String get inviteWrong => 'এই কোডটি বৈধ নয়';

  @override
  String get inviteUnavailable =>
      'কোড এখন যাচাই করা যাচ্ছে না, পরে চেষ্টা করুন';

  @override
  String get errorQuota => 'আজকের অনুবাদের মিনিট শেষ, কাল আবার পাবেন';

  @override
  String get voiceNeedsInvite =>
      'নিজের কণ্ঠ আপাতত শুধু আমন্ত্রণ কোডধারী টেস্টারদের জন্য';
}
