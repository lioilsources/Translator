// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Juru Bahasa';

  @override
  String get me => 'Saya';

  @override
  String get colleague => 'Rekan';

  @override
  String get start => 'Mulai';

  @override
  String get modeLabel => 'Mode';

  @override
  String get modeAuto => 'Otomatis';

  @override
  String get modePtt => 'Tahan dan bicara';

  @override
  String get modeStreaming => 'Berkelanjutan';

  @override
  String get chooseLanguage => 'Pilih bahasa';

  @override
  String get history => 'Riwayat';

  @override
  String get settings => 'Pengaturan';

  @override
  String get serverUrl => 'Alamat server';

  @override
  String get save => 'Simpan';

  @override
  String get statusConnecting => 'Menyambung…';

  @override
  String get statusListening => 'Mendengarkan';

  @override
  String get statusRecording => 'Saya mendengar Anda';

  @override
  String get statusTranslating => 'Menerjemahkan';

  @override
  String get statusSpeaking => 'Berbicara';

  @override
  String get statusPaused => 'Dijeda';

  @override
  String get itWasMe => 'Itu saya';

  @override
  String get promptAuto => 'Bicaralah bergantian';

  @override
  String get promptPtt => 'Tahan dan bicara';

  @override
  String get pause => 'Jeda';

  @override
  String get resume => 'Lanjutkan';

  @override
  String get soundOn => 'Suara aktif';

  @override
  String get soundOff => 'Hanya teks';

  @override
  String get endConversation => 'Akhiri';

  @override
  String get volumeHint => 'Setel volume ke maksimum';

  @override
  String get share => 'Bagikan';

  @override
  String get delete => 'Hapus';

  @override
  String get noHistory => 'Belum ada percakapan';

  @override
  String get micDenied =>
      'Tanpa akses mikrofon tidak bisa jalan. Izinkan di pengaturan.';

  @override
  String get errorConnection => 'Koneksi ke server terputus';

  @override
  String get errorBackend => 'Layanan terjemahan sedang tidak tersedia';

  @override
  String get errorVoice => 'Suara tidak tersedia, teks tetap ada';

  @override
  String get errorBusy => 'Server penuh, coba lagi sebentar lagi';

  @override
  String get errorTooLong => 'Ucapan terlalu panjang';

  @override
  String get errorGeneric => 'Terjadi kesalahan';

  @override
  String get cancel => 'Batal';

  @override
  String get voiceLibrary => 'Suara saya';

  @override
  String get voiceAdd => 'Rekam suara';

  @override
  String get voiceEmpty => 'Belum ada suara di sini.';

  @override
  String get voiceServerError => 'Suara sedang tidak tersedia';

  @override
  String get voiceDefault => 'Suara default';

  @override
  String get voiceName => 'Beri nama suara';

  @override
  String get voiceConsent =>
      'Saya setuju rekaman suara saya disimpan di server dan dipakai untuk mengucapkan terjemahan dengan suara saya. Ini data biometrik, saya hanya boleh merekam diri sendiri, dan saya mencabut persetujuan dengan menghapus suara.';

  @override
  String get voiceReadThis =>
      'Tekan tombol dan bacalah dengan wajar selama 30 detik:';

  @override
  String get voiceSampleText =>
      'Selamat siang, ini contoh suara saya. Saya berbicara dengan tenang dan wajar, seperti sedang mengobrol dengan seseorang di meja. Kemarin saya berjalan-jalan, di jalan saya bertemu teman lama dan kami minum kopi bersama. Dia bercerita tentang perjalanannya ke pantai, cuaca, makanan yang enak, dan apa yang menantinya di tempat kerja. Setelah selesai membaca, saya akan melanjutkan dengan kata-kata saya sendiri sampai rekaman berakhir.';

  @override
  String get voiceRecord => 'Rekam 30 detik';

  @override
  String voiceRecording(int seconds) {
    return 'Merekam, sisa $seconds dtk';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Hapus suara $name?';
  }

  @override
  String get voiceDeleteBody => 'Rekaman akan dihapus permanen dari server.';

  @override
  String get serverChecking => 'memeriksa…';

  @override
  String get serverReady => 'siap';

  @override
  String get serverDegraded => 'tidak semua berjalan';

  @override
  String get serverOffline => 'tidak tersedia';

  @override
  String get serverRecheck => 'Periksa lagi';

  @override
  String get deviceTier => 'Perangkat ini';

  @override
  String get deviceTierPublic => 'Dasar: waktu terjemahan terbatas per hari';

  @override
  String get deviceTierTester =>
      'Penguji: terjemahan lebih lama dan suara sendiri';

  @override
  String get deviceTierUnknown => 'Server sedang tidak merespons';

  @override
  String get inviteCode => 'Kode undangan';

  @override
  String get inviteHelp => 'Dari pembuat aplikasi, membuka pengujian';

  @override
  String get inviteWrong => 'Kode ini tidak berlaku';

  @override
  String get inviteUnavailable =>
      'Kode belum bisa diperiksa sekarang, coba lagi nanti';

  @override
  String get errorQuota =>
      'Menit terjemahan hari ini habis, besok tersedia lagi';

  @override
  String get voiceNeedsInvite =>
      'Suara sendiri untuk sementara hanya untuk penguji dengan kode undangan';
}
