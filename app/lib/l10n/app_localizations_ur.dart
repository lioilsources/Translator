// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'ترجمان';

  @override
  String get me => 'میں';

  @override
  String get colleague => 'ساتھی';

  @override
  String get start => 'شروع کریں';

  @override
  String get modeLabel => 'موڈ';

  @override
  String get modeAuto => 'خودکار';

  @override
  String get modePtt => 'دبائے رکھیں اور بولیں';

  @override
  String get modeStreaming => 'مسلسل';

  @override
  String get chooseLanguage => 'زبان منتخب کریں';

  @override
  String get history => 'تاریخ';

  @override
  String get settings => 'سیٹنگز';

  @override
  String get serverUrl => 'سرور کا پتہ';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get statusConnecting => 'جڑ رہا ہے…';

  @override
  String get statusListening => 'سن رہا ہوں';

  @override
  String get statusRecording => 'آپ کو سن رہا ہوں';

  @override
  String get statusTranslating => 'ترجمہ کر رہا ہوں';

  @override
  String get statusSpeaking => 'بول رہا ہوں';

  @override
  String get statusPaused => 'موقوف';

  @override
  String get itWasMe => 'وہ میں تھا';

  @override
  String get promptAuto => 'ایک ایک کر کے بولیں';

  @override
  String get promptPtt => 'دبائے رکھیں اور بولیں';

  @override
  String get pause => 'وقفہ';

  @override
  String get resume => 'جاری رکھیں';

  @override
  String get soundOn => 'آواز آن';

  @override
  String get soundOff => 'صرف متن';

  @override
  String get endConversation => 'ختم کریں';

  @override
  String get volumeHint => 'والیوم زیادہ سے زیادہ کر دیں';

  @override
  String get share => 'شیئر کریں';

  @override
  String get delete => 'حذف کریں';

  @override
  String get noHistory => 'ابھی کوئی گفتگو نہیں';

  @override
  String get micDenied =>
      'مائیکروفون کی رسائی کے بغیر نہیں چلے گا۔ سیٹنگز میں اجازت دیں۔';

  @override
  String get errorConnection => 'سرور سے رابطہ ٹوٹ گیا';

  @override
  String get errorBackend => 'ترجمے کی سروس ابھی دستیاب نہیں';

  @override
  String get errorVoice => 'آواز دستیاب نہیں، متن باقی رہے گا';

  @override
  String get errorBusy => 'سرور بھرا ہوا ہے، تھوڑی دیر بعد کوشش کریں';

  @override
  String get errorTooLong => 'بات بہت لمبی ہے';

  @override
  String get errorGeneric => 'کچھ غلط ہو گیا';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get voiceLibrary => 'میری آوازیں';

  @override
  String get voiceAdd => 'آواز ریکارڈ کریں';

  @override
  String get voiceEmpty => 'یہاں ابھی کوئی آواز نہیں ہے۔';

  @override
  String get voiceServerError => 'آوازیں ابھی دستیاب نہیں ہیں';

  @override
  String get voiceDefault => 'طے شدہ آواز';

  @override
  String get voiceName => 'آواز کا نام رکھیں';

  @override
  String get voiceConsent =>
      'میں اس بات پر رضامند ہوں کہ میری آواز کی ریکارڈنگ سرور پر محفوظ کی جائے اور تراجم کو میری آواز میں بولنے کے لیے استعمال ہو۔ یہ بائیو میٹرک ڈیٹا ہے، میں صرف اپنی آواز ریکارڈ کر سکتا ہوں، اور آواز حذف کر کے میں اپنی رضامندی واپس لیتا ہوں۔';

  @override
  String get voiceReadThis =>
      'بٹن دبائیں اور 30 سیکنڈ تک فطری انداز میں پڑھیں:';

  @override
  String get voiceSampleText =>
      'السلام علیکم، یہ میری آواز کا نمونہ ہے۔ میں سکون اور فطری انداز میں بول رہا ہوں، جیسے میز پر کسی سے گپ شپ کر رہا ہوں۔ کل میں سیر کے لیے گیا تھا، راستے میں ایک پرانے دوست سے ملاقات ہوئی اور ہم نے مل کر کافی پی۔ اس نے مجھے سمندر کے سفر، موسم، اچھے کھانے اور کام پر اپنا انتظار کرنے والی باتوں کے بارے میں بتایا۔ پڑھنا ختم ہونے پر میں ریکارڈنگ ختم ہونے تک اپنے الفاظ میں بولتا رہوں گا۔';

  @override
  String get voiceRecord => '30 سیکنڈ ریکارڈ کریں';

  @override
  String voiceRecording(int seconds) {
    return 'ریکارڈ ہو رہا ہے، $seconds سیکنڈ باقی';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'آواز $name حذف کریں؟';
  }

  @override
  String get voiceDeleteBody => 'ریکارڈنگ سرور سے ہمیشہ کے لیے حذف ہو جائے گی۔';

  @override
  String get serverChecking => 'جانچ ہو رہی ہے…';

  @override
  String get serverReady => 'تیار';

  @override
  String get serverDegraded => 'سب کچھ نہیں چل رہا';

  @override
  String get serverOffline => 'دستیاب نہیں';

  @override
  String get serverRecheck => 'دوبارہ جانچیں';

  @override
  String get deviceTier => 'یہ ڈیوائس';

  @override
  String get deviceTierPublic => 'بنیادی: روزانہ محدود ترجمے کا وقت';

  @override
  String get deviceTierTester => 'ٹیسٹر: لمبا ترجمہ اور اپنی آواز';

  @override
  String get deviceTierUnknown => 'سرور ابھی جواب نہیں دے رہا';

  @override
  String get inviteCode => 'دعوتی کوڈ';

  @override
  String get inviteHelp => 'ایپ کے مصنف سے، ٹیسٹنگ کھولتا ہے';

  @override
  String get inviteWrong => 'یہ کوڈ درست نہیں';

  @override
  String get inviteUnavailable =>
      'کوڈ ابھی جانچا نہیں جا سکتا، بعد میں کوشش کریں';

  @override
  String get errorQuota => 'آج کے ترجمے کے منٹ ختم ہو گئے، کل پھر ملیں گے';

  @override
  String get voiceNeedsInvite =>
      'اپنی آواز فی الحال صرف دعوتی کوڈ والے ٹیسٹرز کے لیے ہے';
}
