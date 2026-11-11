// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '口译员';

  @override
  String get me => '我';

  @override
  String get colleague => '同事';

  @override
  String get start => '开始';

  @override
  String get modeLabel => '模式';

  @override
  String get modeAuto => '自动';

  @override
  String get modePtt => '按住说话';

  @override
  String get modeStreaming => '连续';

  @override
  String get chooseLanguage => '选择语言';

  @override
  String get history => '历史记录';

  @override
  String get settings => '设置';

  @override
  String get serverUrl => '服务器地址';

  @override
  String get save => '保存';

  @override
  String get statusConnecting => '正在连接…';

  @override
  String get statusListening => '正在聆听';

  @override
  String get statusRecording => '我听到您了';

  @override
  String get statusTranslating => '正在翻译';

  @override
  String get statusSpeaking => '正在说话';

  @override
  String get statusPaused => '已暂停';

  @override
  String get itWasMe => '那是我';

  @override
  String get promptAuto => '请依次说话';

  @override
  String get promptPtt => '请按住说话';

  @override
  String get pause => '暂停';

  @override
  String get resume => '继续';

  @override
  String get soundOn => '声音已开启';

  @override
  String get soundOff => '仅文字';

  @override
  String get endConversation => '结束';

  @override
  String get volumeHint => '请把音量调到最大';

  @override
  String get share => '分享';

  @override
  String get delete => '删除';

  @override
  String get noHistory => '还没有对话';

  @override
  String get micDenied => '没有麦克风权限就无法使用。请在设置中允许。';

  @override
  String get errorConnection => '与服务器的连接已断开';

  @override
  String get errorBackend => '翻译服务暂时不可用';

  @override
  String get errorVoice => '语音不可用，只保留文字';

  @override
  String get errorBusy => '服务器已满，请稍后再试';

  @override
  String get errorTooLong => '发言太长';

  @override
  String get errorGeneric => '出了点问题';

  @override
  String get cancel => '取消';

  @override
  String get voiceLibrary => '我的声音';

  @override
  String get voiceAdd => '录制声音';

  @override
  String get voiceEmpty => '这里还没有任何声音。';

  @override
  String get voiceServerError => '声音暂时不可用';

  @override
  String get voiceDefault => '默认声音';

  @override
  String get voiceName => '为声音命名';

  @override
  String get voiceConsent =>
      '我同意将我的声音录音保存在服务器上，并用于以我的声音朗读翻译。这是生物识别数据，我只能录制自己的声音，删除声音即表示撤回同意。';

  @override
  String get voiceReadThis => '按下按钮，自然地朗读 30 秒：';

  @override
  String get voiceSampleText =>
      '您好，这是我的声音样本。我平静而自然地说话，就像在桌边和某人聊天一样。昨天我去散步，路上遇到一位老朋友，我们一起喝了咖啡。他给我讲了他去海边的旅行、天气、好吃的东西，还有工作上等着他的事情。读完之后，我会继续用自己的话说下去，直到录音结束。';

  @override
  String get voiceRecord => '录制 30 秒';

  @override
  String voiceRecording(int seconds) {
    return '正在录音，还剩 $seconds 秒';
  }

  @override
  String voiceDeleteTitle(String name) {
    return '删除声音“$name”？';
  }

  @override
  String get voiceDeleteBody => '录音将从服务器永久删除。';

  @override
  String get serverChecking => '正在检查…';

  @override
  String get serverReady => '就绪';

  @override
  String get serverDegraded => '部分功能未运行';

  @override
  String get serverOffline => '不可用';

  @override
  String get serverRecheck => '重新检查';

  @override
  String get deviceTier => '此设备';

  @override
  String get deviceTierPublic => '基础：每天翻译时长有限';

  @override
  String get deviceTierTester => '测试者：更长翻译和自己的声音';

  @override
  String get deviceTierUnknown => '服务器暂时没有响应';

  @override
  String get inviteCode => '邀请码';

  @override
  String get inviteHelp => '来自应用作者，用于解锁测试';

  @override
  String get inviteWrong => '此邀请码无效';

  @override
  String get inviteUnavailable => '暂时无法验证邀请码，请稍后再试';

  @override
  String get errorQuota => '今天的翻译分钟数已用完，明天再来';

  @override
  String get voiceNeedsInvite => '自己的声音目前仅限持有邀请码的测试者使用';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get appTitle => '口译员';

  @override
  String get me => '我';

  @override
  String get colleague => '同事';

  @override
  String get start => '开始';

  @override
  String get modeLabel => '模式';

  @override
  String get modeAuto => '自动';

  @override
  String get modePtt => '按住说话';

  @override
  String get modeStreaming => '连续';

  @override
  String get chooseLanguage => '选择语言';

  @override
  String get history => '历史记录';

  @override
  String get settings => '设置';

  @override
  String get serverUrl => '服务器地址';

  @override
  String get save => '保存';

  @override
  String get statusConnecting => '正在连接…';

  @override
  String get statusListening => '正在聆听';

  @override
  String get statusRecording => '我听到您了';

  @override
  String get statusTranslating => '正在翻译';

  @override
  String get statusSpeaking => '正在说话';

  @override
  String get statusPaused => '已暂停';

  @override
  String get itWasMe => '那是我';

  @override
  String get promptAuto => '请依次说话';

  @override
  String get promptPtt => '请按住说话';

  @override
  String get pause => '暂停';

  @override
  String get resume => '继续';

  @override
  String get soundOn => '声音已开启';

  @override
  String get soundOff => '仅文字';

  @override
  String get endConversation => '结束';

  @override
  String get volumeHint => '请把音量调到最大';

  @override
  String get share => '分享';

  @override
  String get delete => '删除';

  @override
  String get noHistory => '还没有对话';

  @override
  String get micDenied => '没有麦克风权限就无法使用。请在设置中允许。';

  @override
  String get errorConnection => '与服务器的连接已断开';

  @override
  String get errorBackend => '翻译服务暂时不可用';

  @override
  String get errorVoice => '语音不可用，只保留文字';

  @override
  String get errorBusy => '服务器已满，请稍后再试';

  @override
  String get errorTooLong => '发言太长';

  @override
  String get errorGeneric => '出了点问题';

  @override
  String get cancel => '取消';

  @override
  String get voiceLibrary => '我的声音';

  @override
  String get voiceAdd => '录制声音';

  @override
  String get voiceEmpty => '这里还没有任何声音。';

  @override
  String get voiceServerError => '声音暂时不可用';

  @override
  String get voiceDefault => '默认声音';

  @override
  String get voiceName => '为声音命名';

  @override
  String get voiceConsent =>
      '我同意将我的声音录音保存在服务器上，并用于以我的声音朗读翻译。这是生物识别数据，我只能录制自己的声音，删除声音即表示撤回同意。';

  @override
  String get voiceReadThis => '按下按钮，自然地朗读 30 秒：';

  @override
  String get voiceSampleText =>
      '您好，这是我的声音样本。我平静而自然地说话，就像在桌边和某人聊天一样。昨天我去散步，路上遇到一位老朋友，我们一起喝了咖啡。他给我讲了他去海边的旅行、天气、好吃的东西，还有工作上等着他的事情。读完之后，我会继续用自己的话说下去，直到录音结束。';

  @override
  String get voiceRecord => '录制 30 秒';

  @override
  String voiceRecording(int seconds) {
    return '正在录音，还剩 $seconds 秒';
  }

  @override
  String voiceDeleteTitle(String name) {
    return '删除声音“$name”？';
  }

  @override
  String get voiceDeleteBody => '录音将从服务器永久删除。';

  @override
  String get serverChecking => '正在检查…';

  @override
  String get serverReady => '就绪';

  @override
  String get serverDegraded => '部分功能未运行';

  @override
  String get serverOffline => '不可用';

  @override
  String get serverRecheck => '重新检查';

  @override
  String get deviceTier => '此设备';

  @override
  String get deviceTierPublic => '基础：每天翻译时长有限';

  @override
  String get deviceTierTester => '测试者：更长翻译和自己的声音';

  @override
  String get deviceTierUnknown => '服务器暂时没有响应';

  @override
  String get inviteCode => '邀请码';

  @override
  String get inviteHelp => '来自应用作者，用于解锁测试';

  @override
  String get inviteWrong => '此邀请码无效';

  @override
  String get inviteUnavailable => '暂时无法验证邀请码，请稍后再试';

  @override
  String get errorQuota => '今天的翻译分钟数已用完，明天再来';

  @override
  String get voiceNeedsInvite => '自己的声音目前仅限持有邀请码的测试者使用';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => '口譯員';

  @override
  String get me => '我';

  @override
  String get colleague => '同事';

  @override
  String get start => '開始';

  @override
  String get modeLabel => '模式';

  @override
  String get modeAuto => '自動';

  @override
  String get modePtt => '按住說話';

  @override
  String get modeStreaming => '連續';

  @override
  String get chooseLanguage => '選擇語言';

  @override
  String get history => '歷史記錄';

  @override
  String get settings => '設定';

  @override
  String get serverUrl => '伺服器位址';

  @override
  String get save => '儲存';

  @override
  String get statusConnecting => '正在連線…';

  @override
  String get statusListening => '正在聆聽';

  @override
  String get statusRecording => '我聽到您了';

  @override
  String get statusTranslating => '正在翻譯';

  @override
  String get statusSpeaking => '正在說話';

  @override
  String get statusPaused => '已暫停';

  @override
  String get itWasMe => '那是我';

  @override
  String get promptAuto => '請依序說話';

  @override
  String get promptPtt => '請按住說話';

  @override
  String get pause => '暫停';

  @override
  String get resume => '繼續';

  @override
  String get soundOn => '聲音已開啟';

  @override
  String get soundOff => '僅文字';

  @override
  String get endConversation => '結束';

  @override
  String get volumeHint => '請把音量調到最大';

  @override
  String get share => '分享';

  @override
  String get delete => '刪除';

  @override
  String get noHistory => '還沒有對話';

  @override
  String get micDenied => '沒有麥克風權限就無法使用。請在設定中允許。';

  @override
  String get errorConnection => '與伺服器的連線已中斷';

  @override
  String get errorBackend => '翻譯服務暫時無法使用';

  @override
  String get errorVoice => '語音無法使用，只保留文字';

  @override
  String get errorBusy => '伺服器已滿，請稍後再試';

  @override
  String get errorTooLong => '發言太長';

  @override
  String get errorGeneric => '發生了一些問題';

  @override
  String get cancel => '取消';

  @override
  String get voiceLibrary => '我的聲音';

  @override
  String get voiceAdd => '錄製聲音';

  @override
  String get voiceEmpty => '這裡還沒有任何聲音。';

  @override
  String get voiceServerError => '聲音暫時無法使用';

  @override
  String get voiceDefault => '預設聲音';

  @override
  String get voiceName => '為聲音命名';

  @override
  String get voiceConsent =>
      '我同意將我的聲音錄音儲存在伺服器上，並用於以我的聲音朗讀翻譯。這是生物辨識資料，我只能錄製自己的聲音，刪除聲音即表示撤回同意。';

  @override
  String get voiceReadThis => '按下按鈕，自然地朗讀 30 秒：';

  @override
  String get voiceSampleText =>
      '您好，這是我的聲音樣本。我平靜而自然地說話，就像在桌邊和某人聊天一樣。昨天我去散步，路上遇到一位老朋友，我們一起喝了咖啡。他跟我說了他去海邊的旅行、天氣、好吃的東西，還有工作上等著他的事情。讀完之後，我會繼續用自己的話說下去，直到錄音結束。';

  @override
  String get voiceRecord => '錄製 30 秒';

  @override
  String voiceRecording(int seconds) {
    return '正在錄音，還剩 $seconds 秒';
  }

  @override
  String voiceDeleteTitle(String name) {
    return '刪除聲音「$name」？';
  }

  @override
  String get voiceDeleteBody => '錄音將從伺服器永久刪除。';

  @override
  String get serverChecking => '正在檢查…';

  @override
  String get serverReady => '就緒';

  @override
  String get serverDegraded => '部分功能未運作';

  @override
  String get serverOffline => '無法使用';

  @override
  String get serverRecheck => '重新檢查';

  @override
  String get deviceTier => '此裝置';

  @override
  String get deviceTierPublic => '基礎：每天翻譯時間有限';

  @override
  String get deviceTierTester => '測試者：更長翻譯與自己的聲音';

  @override
  String get deviceTierUnknown => '伺服器暫時沒有回應';

  @override
  String get inviteCode => '邀請碼';

  @override
  String get inviteHelp => '來自 App 作者，用於解鎖測試';

  @override
  String get inviteWrong => '此邀請碼無效';

  @override
  String get inviteUnavailable => '暫時無法驗證邀請碼，請稍後再試';

  @override
  String get errorQuota => '今天的翻譯分鐘數已用完，明天再來';

  @override
  String get voiceNeedsInvite => '自己的聲音目前僅限持有邀請碼的測試者使用';
}
