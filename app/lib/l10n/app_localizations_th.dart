// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'ล่าม';

  @override
  String get me => 'ฉัน';

  @override
  String get colleague => 'เพื่อนร่วมงาน';

  @override
  String get start => 'เริ่ม';

  @override
  String get modeLabel => 'โหมด';

  @override
  String get modeAuto => 'อัตโนมัติ';

  @override
  String get modePtt => 'กดค้างแล้วพูด';

  @override
  String get modeStreaming => 'ต่อเนื่อง';

  @override
  String get chooseLanguage => 'เลือกภาษา';

  @override
  String get history => 'ประวัติ';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get serverUrl => 'ที่อยู่เซิร์ฟเวอร์';

  @override
  String get save => 'บันทึก';

  @override
  String get statusConnecting => 'กำลังเชื่อมต่อ…';

  @override
  String get statusListening => 'กำลังฟัง';

  @override
  String get statusRecording => 'ได้ยินคุณอยู่';

  @override
  String get statusTranslating => 'กำลังแปล';

  @override
  String get statusSpeaking => 'กำลังพูด';

  @override
  String get statusPaused => 'หยุดชั่วคราว';

  @override
  String get itWasMe => 'นั่นคือฉันเอง';

  @override
  String get promptAuto => 'พูดทีละคน';

  @override
  String get promptPtt => 'กดค้างแล้วพูด';

  @override
  String get pause => 'หยุดชั่วคราว';

  @override
  String get resume => 'ทำต่อ';

  @override
  String get soundOn => 'เปิดเสียง';

  @override
  String get soundOff => 'เฉพาะข้อความ';

  @override
  String get endConversation => 'จบ';

  @override
  String get volumeHint => 'ปรับระดับเสียงให้สูงสุด';

  @override
  String get share => 'แชร์';

  @override
  String get delete => 'ลบ';

  @override
  String get noHistory => 'ยังไม่มีบทสนทนา';

  @override
  String get micDenied =>
      'หากไม่ได้รับสิทธิ์ใช้ไมโครโฟนจะใช้งานไม่ได้ โปรดอนุญาตในการตั้งค่า';

  @override
  String get errorConnection => 'การเชื่อมต่อกับเซิร์ฟเวอร์ขาดหาย';

  @override
  String get errorBackend => 'บริการแปลภาษาใช้งานไม่ได้ในขณะนี้';

  @override
  String get errorVoice => 'ไม่มีเสียงให้ใช้ จะแสดงเป็นข้อความ';

  @override
  String get errorBusy => 'เซิร์ฟเวอร์เต็ม โปรดลองอีกครั้งในอีกสักครู่';

  @override
  String get errorTooLong => 'คำพูดยาวเกินไป';

  @override
  String get errorGeneric => 'เกิดข้อผิดพลาดบางอย่าง';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get voiceLibrary => 'เสียงของฉัน';

  @override
  String get voiceAdd => 'บันทึกเสียง';

  @override
  String get voiceEmpty => 'ที่นี่ยังไม่มีเสียงใด ๆ';

  @override
  String get voiceServerError => 'ไม่สามารถใช้เสียงได้ในขณะนี้';

  @override
  String get voiceDefault => 'เสียงเริ่มต้น';

  @override
  String get voiceName => 'ตั้งชื่อเสียง';

  @override
  String get voiceConsent =>
      'ฉันยินยอมให้เก็บเสียงที่บันทึกของฉันไว้บนเซิร์ฟเวอร์ และใช้พูดคำแปลด้วยเสียงของฉัน เสียงเป็นข้อมูลชีวมิติ ฉันบันทึกได้เฉพาะเสียงของตัวเอง และถอนความยินยอมได้โดยการลบเสียง';

  @override
  String get voiceReadThis => 'กดปุ่มแล้วอ่านตามธรรมชาติเป็นเวลา 30 วินาที:';

  @override
  String get voiceSampleText =>
      'สวัสดีครับ นี่คือตัวอย่างเสียงของผม ผมพูดอย่างใจเย็นและเป็นธรรมชาติ เหมือนกำลังคุยกับใครสักคนที่โต๊ะ เมื่อวานผมออกไปเดินเล่น ระหว่างทางเจอเพื่อนเก่าและเราดื่มกาแฟด้วยกัน เขาเล่าเรื่องการเดินทางไปทะเล เรื่องอากาศ อาหารอร่อย ๆ และเรื่องที่รอเขาอยู่ที่ทำงาน พออ่านจบแล้ว ผมจะพูดต่อด้วยคำพูดของตัวเองจนกว่าการบันทึกจะสิ้นสุด';

  @override
  String get voiceRecord => 'บันทึก 30 วินาที';

  @override
  String voiceRecording(int seconds) {
    return 'กำลังบันทึก เหลืออีก $seconds วิ';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'ลบเสียง $name หรือไม่';
  }

  @override
  String get voiceDeleteBody => 'การบันทึกจะถูกลบออกจากเซิร์ฟเวอร์อย่างถาวร';

  @override
  String get serverChecking => 'กำลังตรวจสอบ…';

  @override
  String get serverReady => 'พร้อม';

  @override
  String get serverDegraded => 'ทำงานไม่ครบ';

  @override
  String get serverOffline => 'ใช้งานไม่ได้';

  @override
  String get serverRecheck => 'ตรวจสอบอีกครั้ง';

  @override
  String get deviceTier => 'อุปกรณ์เครื่องนี้';

  @override
  String get deviceTierPublic => 'พื้นฐาน: เวลาแปลต่อวันจำกัด';

  @override
  String get deviceTierTester => 'ผู้ทดสอบ: แปลได้นานขึ้นและมีเสียงของตัวเอง';

  @override
  String get deviceTierUnknown => 'เซิร์ฟเวอร์ไม่ตอบสนองในขณะนี้';

  @override
  String get inviteCode => 'รหัสเชิญ';

  @override
  String get inviteHelp => 'จากผู้สร้างแอป ใช้ปลดล็อกการทดสอบ';

  @override
  String get inviteWrong => 'รหัสนี้ใช้ไม่ได้';

  @override
  String get inviteUnavailable => 'ตรวจสอบรหัสไม่ได้ในขณะนี้ โปรดลองภายหลัง';

  @override
  String get errorQuota => 'นาทีแปลของวันนี้หมดแล้ว พรุ่งนี้มาใหม่';

  @override
  String get voiceNeedsInvite =>
      'เสียงของตัวเองยังใช้ได้เฉพาะผู้ทดสอบที่มีรหัสเชิญ';
}
