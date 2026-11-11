// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'Jurubahasa';

  @override
  String get me => 'Saya';

  @override
  String get colleague => 'Rakan sekerja';

  @override
  String get start => 'Mula';

  @override
  String get modeLabel => 'Mod';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Tahan dan cakap';

  @override
  String get modeStreaming => 'Berterusan';

  @override
  String get chooseLanguage => 'Pilih bahasa';

  @override
  String get history => 'Sejarah';

  @override
  String get settings => 'Tetapan';

  @override
  String get serverUrl => 'Alamat pelayan';

  @override
  String get save => 'Simpan';

  @override
  String get statusConnecting => 'Menyambung…';

  @override
  String get statusListening => 'Mendengar';

  @override
  String get statusRecording => 'Saya dengar anda';

  @override
  String get statusTranslating => 'Menterjemah';

  @override
  String get statusSpeaking => 'Bercakap';

  @override
  String get statusPaused => 'Dijeda';

  @override
  String get itWasMe => 'Itu saya';

  @override
  String get promptAuto => 'Cakap seorang demi seorang';

  @override
  String get promptPtt => 'Tahan dan cakap';

  @override
  String get pause => 'Jeda';

  @override
  String get resume => 'Sambung';

  @override
  String get soundOn => 'Bunyi hidup';

  @override
  String get soundOff => 'Teks sahaja';

  @override
  String get endConversation => 'Tamat';

  @override
  String get volumeHint => 'Set kelantangan ke maksimum';

  @override
  String get share => 'Kongsi';

  @override
  String get delete => 'Padam';

  @override
  String get noHistory => 'Belum ada perbualan';

  @override
  String get micDenied =>
      'Tanpa akses mikrofon ia tidak boleh berfungsi. Benarkannya dalam tetapan.';

  @override
  String get errorConnection => 'Sambungan ke pelayan terputus';

  @override
  String get errorBackend => 'Perkhidmatan terjemahan tidak tersedia sekarang';

  @override
  String get errorVoice => 'Suara tidak tersedia, teks kekal';

  @override
  String get errorBusy => 'Pelayan penuh, cuba lagi sebentar nanti';

  @override
  String get errorTooLong => 'Pertuturan terlalu panjang';

  @override
  String get errorGeneric => 'Sesuatu telah berlaku';

  @override
  String get cancel => 'Batal';

  @override
  String get voiceLibrary => 'Suara saya';

  @override
  String get voiceAdd => 'Rakam suara';

  @override
  String get voiceEmpty => 'Belum ada suara di sini.';

  @override
  String get voiceServerError => 'Suara tidak tersedia sekarang';

  @override
  String get voiceDefault => 'Suara lalai';

  @override
  String get voiceName => 'Namakan suara';

  @override
  String get voiceConsent =>
      'Saya bersetuju rakaman suara saya disimpan di pelayan dan digunakan untuk menuturkan terjemahan dengan suara saya. Ia data biometrik, saya hanya boleh merakam diri sendiri, dan saya menarik balik persetujuan dengan memadam suara.';

  @override
  String get voiceReadThis =>
      'Tekan butang dan baca secara semula jadi selama 30 saat:';

  @override
  String get voiceSampleText =>
      'Selamat tengah hari, ini sampel suara saya. Saya bercakap dengan tenang dan semula jadi, seperti sedang berbual dengan seseorang di meja. Semalam saya berjalan-jalan, di tengah jalan saya terserempak kawan lama dan kami minum kopi bersama. Dia bercerita tentang perjalanannya ke pantai, cuaca, makanan yang sedap dan apa yang menantinya di tempat kerja. Apabila saya habis membaca, saya akan terus bercakap dengan kata-kata sendiri sehingga rakaman tamat.';

  @override
  String get voiceRecord => 'Rakam 30 saat';

  @override
  String voiceRecording(int seconds) {
    return 'Merakam, baki $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Padam suara $name?';
  }

  @override
  String get voiceDeleteBody =>
      'Rakaman akan dipadam secara kekal daripada pelayan.';

  @override
  String get serverChecking => 'menyemak…';

  @override
  String get serverReady => 'sedia';

  @override
  String get serverDegraded => 'tidak semua berfungsi';

  @override
  String get serverOffline => 'tidak tersedia';

  @override
  String get serverRecheck => 'Semak semula';

  @override
  String get deviceTier => 'Peranti ini';

  @override
  String get deviceTierPublic => 'Asas: masa terjemahan terhad sehari';

  @override
  String get deviceTierTester =>
      'Penguji: terjemahan lebih lama dan suara sendiri';

  @override
  String get deviceTierUnknown => 'Pelayan tidak menjawab sekarang';

  @override
  String get inviteCode => 'Kod jemputan';

  @override
  String get inviteHelp => 'Daripada pencipta apl, membuka ujian';

  @override
  String get inviteWrong => 'Kod ini tidak sah';

  @override
  String get inviteUnavailable =>
      'Kod tidak dapat disemak sekarang, cuba lagi nanti';

  @override
  String get errorQuota =>
      'Minit terjemahan hari ini sudah habis, esok ada lagi';

  @override
  String get voiceNeedsInvite =>
      'Suara sendiri buat masa ini hanya untuk penguji yang mempunyai kod jemputan';
}
