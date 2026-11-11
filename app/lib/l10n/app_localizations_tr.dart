// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Tercüman';

  @override
  String get me => 'Ben';

  @override
  String get colleague => 'Meslektaş';

  @override
  String get start => 'Başlat';

  @override
  String get modeLabel => 'Mod';

  @override
  String get modeAuto => 'Otomatik';

  @override
  String get modePtt => 'Basılı tut ve konuş';

  @override
  String get modeStreaming => 'Sürekli';

  @override
  String get chooseLanguage => 'Dil seçin';

  @override
  String get history => 'Geçmiş';

  @override
  String get settings => 'Ayarlar';

  @override
  String get serverUrl => 'Sunucu adresi';

  @override
  String get save => 'Kaydet';

  @override
  String get statusConnecting => 'Bağlanıyor…';

  @override
  String get statusListening => 'Dinliyorum';

  @override
  String get statusRecording => 'Sizi duyuyorum';

  @override
  String get statusTranslating => 'Çeviriyorum';

  @override
  String get statusSpeaking => 'Konuşuyorum';

  @override
  String get statusPaused => 'Duraklatıldı';

  @override
  String get itWasMe => 'Bendim';

  @override
  String get promptAuto => 'Sırayla konuşun';

  @override
  String get promptPtt => 'Basılı tutun ve konuşun';

  @override
  String get pause => 'Duraklat';

  @override
  String get resume => 'Devam et';

  @override
  String get soundOn => 'Ses açık';

  @override
  String get soundOff => 'Yalnızca metin';

  @override
  String get endConversation => 'Bitir';

  @override
  String get volumeHint => 'Ses seviyesini sonuna kadar açın';

  @override
  String get share => 'Paylaş';

  @override
  String get delete => 'Sil';

  @override
  String get noHistory => 'Henüz konuşma yok';

  @override
  String get micDenied =>
      'Mikrofon erişimi olmadan olmaz. Ayarlardan izin verin.';

  @override
  String get errorConnection => 'Sunucuyla bağlantı koptu';

  @override
  String get errorBackend => 'Çeviri hizmeti şu anda kullanılamıyor';

  @override
  String get errorVoice => 'Ses kullanılamıyor, metin kalıyor';

  @override
  String get errorBusy => 'Sunucu dolu, birazdan tekrar deneyin';

  @override
  String get errorTooLong => 'Konuşma çok uzun';

  @override
  String get errorGeneric => 'Bir şeyler ters gitti';

  @override
  String get cancel => 'İptal';

  @override
  String get voiceLibrary => 'Seslerim';

  @override
  String get voiceAdd => 'Ses kaydet';

  @override
  String get voiceEmpty => 'Burada henüz ses yok.';

  @override
  String get voiceServerError => 'Sesler şu anda kullanılamıyor';

  @override
  String get voiceDefault => 'Varsayılan ses';

  @override
  String get voiceName => 'Sese bir ad verin';

  @override
  String get voiceConsent =>
      'Ses kaydımın sunucuda saklanmasını ve çevirileri benim sesimle okumak için kullanılmasını kabul ediyorum. Bu biyometrik bir veridir, yalnızca kendimi kaydedebilirim ve sesi silerek onayımı geri çekerim.';

  @override
  String get voiceReadThis =>
      'Düğmeye basın ve 30 saniye boyunca doğal bir şekilde okuyun:';

  @override
  String get voiceSampleText =>
      'İyi günler, bu benim sesimden bir örnek. Masada biriyle sohbet ediyormuş gibi sakin ve doğal konuşuyorum. Dün yürüyüşe çıktım, yolda eski bir arkadaşımla karşılaştım ve birlikte kahve içtik. Bana denize yaptığı yolculuktan, havadan, güzel yemeklerden ve işte kendisini nelerin beklediğinden bahsetti. Okumayı bitirdiğimde, kayıt sona erene kadar kendi kelimelerimle devam edeceğim.';

  @override
  String get voiceRecord => '30 saniye kaydet';

  @override
  String voiceRecording(int seconds) {
    return 'Kaydediliyor, $seconds sn kaldı';
  }

  @override
  String voiceDeleteTitle(String name) {
    return '$name sesi silinsin mi?';
  }

  @override
  String get voiceDeleteBody => 'Kayıt sunucudan kalıcı olarak silinecek.';

  @override
  String get serverChecking => 'denetleniyor…';

  @override
  String get serverReady => 'hazır';

  @override
  String get serverDegraded => 'her şey çalışmıyor';

  @override
  String get serverOffline => 'kullanılamıyor';

  @override
  String get serverRecheck => 'Yeniden denetle';

  @override
  String get deviceTier => 'Bu cihaz';

  @override
  String get deviceTierPublic => 'Temel: günlük sınırlı çeviri süresi';

  @override
  String get deviceTierTester =>
      'Test kullanıcısı: daha uzun çeviri ve kendi sesi';

  @override
  String get deviceTierUnknown => 'Sunucu şu anda yanıt vermiyor';

  @override
  String get inviteCode => 'Davet kodu';

  @override
  String get inviteHelp => 'Uygulamanın yazarından, testi açar';

  @override
  String get inviteWrong => 'Bu kod geçerli değil';

  @override
  String get inviteUnavailable =>
      'Kod şu anda doğrulanamıyor, daha sonra deneyin';

  @override
  String get errorQuota => 'Bugünkü çeviri dakikaları bitti, yarın yeniden';

  @override
  String get voiceNeedsInvite =>
      'Kendi sesi şimdilik yalnızca davet kodu olan test kullanıcıları için';
}
