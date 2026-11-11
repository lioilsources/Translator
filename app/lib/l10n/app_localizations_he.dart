// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'מתורגמן';

  @override
  String get me => 'אני';

  @override
  String get colleague => 'עמית';

  @override
  String get start => 'התחל';

  @override
  String get modeLabel => 'מצב';

  @override
  String get modeAuto => 'אוטומטי';

  @override
  String get modePtt => 'לחיצה ממושכת ודיבור';

  @override
  String get modeStreaming => 'רציף';

  @override
  String get chooseLanguage => 'בחרו שפה';

  @override
  String get history => 'היסטוריה';

  @override
  String get settings => 'הגדרות';

  @override
  String get serverUrl => 'כתובת השרת';

  @override
  String get save => 'שמירה';

  @override
  String get statusConnecting => 'מתחבר…';

  @override
  String get statusListening => 'מקשיב';

  @override
  String get statusRecording => 'שומע אתכם';

  @override
  String get statusTranslating => 'מתרגם';

  @override
  String get statusSpeaking => 'מדבר';

  @override
  String get statusPaused => 'מושהה';

  @override
  String get itWasMe => 'זה הייתי אני';

  @override
  String get promptAuto => 'דברו בזה אחר זה';

  @override
  String get promptPtt => 'לחצו והחזיקו ודברו';

  @override
  String get pause => 'השהיה';

  @override
  String get resume => 'המשך';

  @override
  String get soundOn => 'שמע פועל';

  @override
  String get soundOff => 'טקסט בלבד';

  @override
  String get endConversation => 'סיום';

  @override
  String get volumeHint => 'הגדילו את עוצמת הקול למקסימום';

  @override
  String get share => 'שיתוף';

  @override
  String get delete => 'מחיקה';

  @override
  String get noHistory => 'עדיין אין שיחות';

  @override
  String get micDenied => 'בלי גישה למיקרופון זה לא יעבוד. אפשרו אותה בהגדרות.';

  @override
  String get errorConnection => 'החיבור לשרת אבד';

  @override
  String get errorBackend => 'שירות התרגום אינו זמין כרגע';

  @override
  String get errorVoice => 'הקול אינו זמין, הטקסט נשאר';

  @override
  String get errorBusy => 'השרת מלא, נסו שוב בעוד רגע';

  @override
  String get errorTooLong => 'הדיבור ארוך מדי';

  @override
  String get errorGeneric => 'משהו השתבש';

  @override
  String get cancel => 'ביטול';

  @override
  String get voiceLibrary => 'הקולות שלי';

  @override
  String get voiceAdd => 'הקלטת קול';

  @override
  String get voiceEmpty => 'עדיין אין כאן אף קול.';

  @override
  String get voiceServerError => 'הקולות אינם זמינים כרגע';

  @override
  String get voiceDefault => 'קול ברירת מחדל';

  @override
  String get voiceName => 'תנו שם לקול';

  @override
  String get voiceConsent =>
      'אני מסכים/ה שהקלטת הקול שלי תישמר בשרת ותשמש להשמעת תרגומים בקולי. זהו מידע ביומטרי, מותר לי להקליט רק את עצמי, ואני מבטל/ת את ההסכמה על ידי מחיקת הקול.';

  @override
  String get voiceReadThis => 'לחצו על הכפתור וקראו באופן טבעי במשך 30 שניות:';

  @override
  String get voiceSampleText =>
      'שלום, זו דוגמה לקול שלי. אני מדבר/ת בנחת ובטבעיות, כאילו אני משוחח/ת עם מישהו ליד השולחן. אתמול יצאתי לטיול, בדרך פגשתי חבר ותיק ושתינו יחד קפה. הוא סיפר לי על הנסיעה שלו לים, על מזג האוויר, על האוכל הטוב ועל מה שמחכה לו בעבודה. כשאסיים לקרוא, אמשיך במילים שלי עד שההקלטה תסתיים.';

  @override
  String get voiceRecord => 'הקלטה של 30 שניות';

  @override
  String voiceRecording(int seconds) {
    return 'מקליט, נותרו $seconds שנ\'';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'למחוק את הקול $name?';
  }

  @override
  String get voiceDeleteBody => 'ההקלטה תימחק מהשרת לצמיתות.';

  @override
  String get serverChecking => 'בודק…';

  @override
  String get serverReady => 'מוכן';

  @override
  String get serverDegraded => 'לא הכול פועל';

  @override
  String get serverOffline => 'לא זמין';

  @override
  String get serverRecheck => 'בדיקה חוזרת';

  @override
  String get deviceTier => 'המכשיר הזה';

  @override
  String get deviceTierPublic => 'בסיסי: זמן תרגום מוגבל ליום';

  @override
  String get deviceTierTester => 'בודק: תרגום ארוך יותר וקול משלך';

  @override
  String get deviceTierUnknown => 'השרת אינו עונה כרגע';

  @override
  String get inviteCode => 'קוד הזמנה';

  @override
  String get inviteHelp => 'מיוצר האפליקציה, פותח את הבדיקות';

  @override
  String get inviteWrong => 'הקוד הזה אינו תקף';

  @override
  String get inviteUnavailable => 'לא ניתן לאמת את הקוד כרגע, נסו מאוחר יותר';

  @override
  String get errorQuota => 'דקות התרגום להיום נגמרו, מחר יהיו שוב';

  @override
  String get voiceNeedsInvite => 'קול משלך זמין כרגע רק לבודקים עם קוד הזמנה';
}
