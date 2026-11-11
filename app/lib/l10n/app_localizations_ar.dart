// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'المترجم الفوري';

  @override
  String get me => 'أنا';

  @override
  String get colleague => 'الزميل';

  @override
  String get start => 'ابدأ';

  @override
  String get modeLabel => 'الوضع';

  @override
  String get modeAuto => 'تلقائي';

  @override
  String get modePtt => 'اضغط مطولاً وتحدّث';

  @override
  String get modeStreaming => 'متواصل';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get history => 'السجل';

  @override
  String get settings => 'الإعدادات';

  @override
  String get serverUrl => 'عنوان الخادم';

  @override
  String get save => 'حفظ';

  @override
  String get statusConnecting => 'جارٍ الاتصال…';

  @override
  String get statusListening => 'أستمع';

  @override
  String get statusRecording => 'أسمعك';

  @override
  String get statusTranslating => 'جارٍ الترجمة';

  @override
  String get statusSpeaking => 'أتحدث';

  @override
  String get statusPaused => 'متوقف مؤقتاً';

  @override
  String get itWasMe => 'هذا أنا';

  @override
  String get promptAuto => 'تحدثوا واحداً تلو الآخر';

  @override
  String get promptPtt => 'اضغط مطولاً وتحدّث';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get resume => 'متابعة';

  @override
  String get soundOn => 'الصوت مفعّل';

  @override
  String get soundOff => 'نص فقط';

  @override
  String get endConversation => 'إنهاء';

  @override
  String get volumeHint => 'ارفع مستوى الصوت إلى الحد الأقصى';

  @override
  String get share => 'مشاركة';

  @override
  String get delete => 'حذف';

  @override
  String get noHistory => 'لا توجد محادثات بعد';

  @override
  String get micDenied =>
      'لن يعمل التطبيق دون الوصول إلى الميكروفون. اسمح به في الإعدادات.';

  @override
  String get errorConnection => 'انقطع الاتصال بالخادم';

  @override
  String get errorBackend => 'خدمة الترجمة غير متاحة الآن';

  @override
  String get errorVoice => 'الصوت غير متاح، سيبقى النص';

  @override
  String get errorBusy => 'الخادم ممتلئ، حاول بعد قليل';

  @override
  String get errorTooLong => 'الكلام طويل جداً';

  @override
  String get errorGeneric => 'حدث خطأ ما';

  @override
  String get cancel => 'إلغاء';

  @override
  String get voiceLibrary => 'أصواتي';

  @override
  String get voiceAdd => 'تسجيل صوت';

  @override
  String get voiceEmpty => 'لا يوجد أي صوت هنا بعد.';

  @override
  String get voiceServerError => 'الأصوات غير متاحة الآن';

  @override
  String get voiceDefault => 'الصوت الافتراضي';

  @override
  String get voiceName => 'سمِّ الصوت';

  @override
  String get voiceConsent =>
      'أوافق على حفظ تسجيل صوتي على الخادم واستخدامه لنطق الترجمات بصوتي. إنه بيان بيومتري، ولا يحق لي تسجيل غير صوتي، وأسحب موافقتي بحذف الصوت.';

  @override
  String get voiceReadThis => 'اضغط الزر واقرأ بشكل طبيعي لمدة 30 ثانية:';

  @override
  String get voiceSampleText =>
      'مرحباً، هذه عينة من صوتي. أتحدث بهدوء وبشكل طبيعي، كأنني أتحدث مع شخص على الطاولة. أمس خرجت في نزهة، وفي الطريق قابلت صديقاً قديماً وشربنا القهوة معاً. حدّثني عن رحلته إلى البحر وعن الطقس والطعام الجيد وعما ينتظره في العمل. وعندما أنتهي من القراءة سأواصل بكلماتي الخاصة حتى ينتهي التسجيل.';

  @override
  String get voiceRecord => 'سجّل 30 ثانية';

  @override
  String voiceRecording(int seconds) {
    return 'جارٍ التسجيل، تبقّى $seconds ث';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'حذف الصوت $name؟';
  }

  @override
  String get voiceDeleteBody => 'سيُحذف التسجيل نهائياً من الخادم.';

  @override
  String get serverChecking => 'جارٍ التحقق…';

  @override
  String get serverReady => 'جاهز';

  @override
  String get serverDegraded => 'لا يعمل كل شيء';

  @override
  String get serverOffline => 'غير متاح';

  @override
  String get serverRecheck => 'تحقق مرة أخرى';

  @override
  String get deviceTier => 'هذا الجهاز';

  @override
  String get deviceTierPublic => 'أساسي: وقت ترجمة محدود يومياً';

  @override
  String get deviceTierTester => 'مختبِر: ترجمة أطول وصوت خاص';

  @override
  String get deviceTierUnknown => 'الخادم لا يردّ الآن';

  @override
  String get inviteCode => 'رمز الدعوة';

  @override
  String get inviteHelp => 'من مؤلف التطبيق، يفتح الاختبار';

  @override
  String get inviteWrong => 'هذا الرمز غير صالح';

  @override
  String get inviteUnavailable => 'تعذّر التحقق من الرمز الآن، حاول لاحقاً';

  @override
  String get errorQuota => 'انتهت دقائق الترجمة اليوم، ستتجدد غداً';

  @override
  String get voiceNeedsInvite =>
      'الصوت الخاص متاح حالياً للمختبِرين برمز دعوة فقط';
}
