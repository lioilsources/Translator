// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '通訳';

  @override
  String get me => '自分';

  @override
  String get colleague => '同僚';

  @override
  String get start => '開始';

  @override
  String get modeLabel => 'モード';

  @override
  String get modeAuto => '自動';

  @override
  String get modePtt => '押したまま話す';

  @override
  String get modeStreaming => '連続';

  @override
  String get chooseLanguage => '言語を選択';

  @override
  String get history => '履歴';

  @override
  String get settings => '設定';

  @override
  String get serverUrl => 'サーバーのアドレス';

  @override
  String get save => '保存';

  @override
  String get statusConnecting => '接続中…';

  @override
  String get statusListening => '聞いています';

  @override
  String get statusRecording => '聞こえています';

  @override
  String get statusTranslating => '翻訳中';

  @override
  String get statusSpeaking => '話しています';

  @override
  String get statusPaused => '一時停止中';

  @override
  String get itWasMe => '私です';

  @override
  String get promptAuto => 'ひとりずつ話してください';

  @override
  String get promptPtt => '押したまま話してください';

  @override
  String get pause => '一時停止';

  @override
  String get resume => '再開';

  @override
  String get soundOn => '音声オン';

  @override
  String get soundOff => 'テキストのみ';

  @override
  String get endConversation => '終了';

  @override
  String get volumeHint => '音量を最大にしてください';

  @override
  String get share => '共有';

  @override
  String get delete => '削除';

  @override
  String get noHistory => 'まだ会話はありません';

  @override
  String get micDenied => 'マイクへのアクセスがないと使えません。設定で許可してください。';

  @override
  String get errorConnection => 'サーバーとの接続が切れました';

  @override
  String get errorBackend => '翻訳サービスは現在ご利用いただけません';

  @override
  String get errorVoice => '音声を利用できないため、テキストのみ表示します';

  @override
  String get errorBusy => 'サーバーが混み合っています。しばらくしてからお試しください';

  @override
  String get errorTooLong => '発話が長すぎます';

  @override
  String get errorGeneric => '問題が発生しました';

  @override
  String get cancel => 'キャンセル';

  @override
  String get voiceLibrary => '自分の声';

  @override
  String get voiceAdd => '声を録音';

  @override
  String get voiceEmpty => 'まだ声がありません。';

  @override
  String get voiceServerError => '現在、声を利用できません';

  @override
  String get voiceDefault => '標準の声';

  @override
  String get voiceName => '声に名前を付けてください';

  @override
  String get voiceConsent =>
      '私の声の録音をサーバーに保存し、翻訳を私の声で読み上げるために使うことに同意します。これは生体データであり、録音できるのは自分の声のみで、声を削除することで同意を撤回します。';

  @override
  String get voiceReadThis => 'ボタンを押して、30秒間自然に読み上げてください：';

  @override
  String get voiceSampleText =>
      'こんにちは、これは私の声のサンプルです。テーブルで誰かとおしゃべりするように、落ち着いて自然に話しています。昨日は散歩に出かけ、途中で古い友人に会って、一緒にコーヒーを飲みました。彼は海への旅行のこと、天気のこと、おいしい食事のこと、そして仕事で待っていることについて話してくれました。読み終わったら、録音が終わるまで自分の言葉で続けます。';

  @override
  String get voiceRecord => '30秒録音';

  @override
  String voiceRecording(int seconds) {
    return '録音中、残り$seconds秒';
  }

  @override
  String voiceDeleteTitle(String name) {
    return '声「$name」を削除しますか？';
  }

  @override
  String get voiceDeleteBody => '録音はサーバーから完全に削除されます。';

  @override
  String get serverChecking => '確認中…';

  @override
  String get serverReady => '準備完了';

  @override
  String get serverDegraded => '一部が動作していません';

  @override
  String get serverOffline => '利用できません';

  @override
  String get serverRecheck => '再確認';

  @override
  String get deviceTier => 'この端末';

  @override
  String get deviceTierPublic => '基本：1日あたりの翻訳時間に制限あり';

  @override
  String get deviceTierTester => 'テスター：長めの翻訳と自分の声';

  @override
  String get deviceTierUnknown => 'サーバーが応答していません';

  @override
  String get inviteCode => '招待コード';

  @override
  String get inviteHelp => 'アプリの作者から。テストが利用できるようになります';

  @override
  String get inviteWrong => 'このコードは無効です';

  @override
  String get inviteUnavailable => '現在コードを確認できません。後でお試しください';

  @override
  String get errorQuota => '今日の翻訳時間を使い切りました。明日また使えます';

  @override
  String get voiceNeedsInvite => '自分の声は今のところ招待コードをお持ちのテスターのみ利用できます';
}
