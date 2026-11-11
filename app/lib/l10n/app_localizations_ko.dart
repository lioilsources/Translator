// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '통역';

  @override
  String get me => '나';

  @override
  String get colleague => '동료';

  @override
  String get start => '시작';

  @override
  String get modeLabel => '모드';

  @override
  String get modeAuto => '자동';

  @override
  String get modePtt => '누른 채 말하기';

  @override
  String get modeStreaming => '연속';

  @override
  String get chooseLanguage => '언어 선택';

  @override
  String get history => '기록';

  @override
  String get settings => '설정';

  @override
  String get serverUrl => '서버 주소';

  @override
  String get save => '저장';

  @override
  String get statusConnecting => '연결 중…';

  @override
  String get statusListening => '듣는 중';

  @override
  String get statusRecording => '말씀을 듣고 있어요';

  @override
  String get statusTranslating => '번역 중';

  @override
  String get statusSpeaking => '말하는 중';

  @override
  String get statusPaused => '일시정지됨';

  @override
  String get itWasMe => '저예요';

  @override
  String get promptAuto => '한 사람씩 말해 주세요';

  @override
  String get promptPtt => '누른 채 말해 주세요';

  @override
  String get pause => '일시정지';

  @override
  String get resume => '계속';

  @override
  String get soundOn => '소리 켜짐';

  @override
  String get soundOff => '텍스트만';

  @override
  String get endConversation => '종료';

  @override
  String get volumeHint => '볼륨을 최대로 올려 주세요';

  @override
  String get share => '공유';

  @override
  String get delete => '삭제';

  @override
  String get noHistory => '아직 대화가 없습니다';

  @override
  String get micDenied => '마이크 접근 권한이 없으면 사용할 수 없습니다. 설정에서 허용해 주세요.';

  @override
  String get errorConnection => '서버와의 연결이 끊어졌습니다';

  @override
  String get errorBackend => '번역 서비스를 지금은 사용할 수 없습니다';

  @override
  String get errorVoice => '음성을 사용할 수 없어 텍스트만 표시합니다';

  @override
  String get errorBusy => '서버가 가득 찼습니다. 잠시 후 다시 시도해 주세요';

  @override
  String get errorTooLong => '발화가 너무 깁니다';

  @override
  String get errorGeneric => '문제가 발생했습니다';

  @override
  String get cancel => '취소';

  @override
  String get voiceLibrary => '내 목소리';

  @override
  String get voiceAdd => '목소리 녹음';

  @override
  String get voiceEmpty => '아직 목소리가 없습니다.';

  @override
  String get voiceServerError => '목소리를 지금은 사용할 수 없습니다';

  @override
  String get voiceDefault => '기본 목소리';

  @override
  String get voiceName => '목소리 이름 짓기';

  @override
  String get voiceConsent =>
      '내 목소리 녹음을 서버에 저장하고 번역을 내 목소리로 말하는 데 사용하는 것에 동의합니다. 이는 생체 정보이며, 저는 제 목소리만 녹음할 수 있고, 목소리를 삭제하면 동의가 철회됩니다.';

  @override
  String get voiceReadThis => '버튼을 누르고 30초 동안 자연스럽게 읽어 주세요:';

  @override
  String get voiceSampleText =>
      '안녕하세요, 제 목소리 샘플입니다. 테이블에서 누군가와 이야기하듯 차분하고 자연스럽게 말하고 있습니다. 어제는 산책을 나갔다가 길에서 오랜 친구를 만나 함께 커피를 마셨습니다. 친구는 바다로 다녀온 여행, 날씨, 맛있는 음식, 그리고 직장에서 기다리고 있는 일들에 대해 이야기해 주었습니다. 다 읽고 나면 녹음이 끝날 때까지 제 말로 계속 이어 가겠습니다.';

  @override
  String get voiceRecord => '30초 녹음';

  @override
  String voiceRecording(int seconds) {
    return '녹음 중, $seconds초 남음';
  }

  @override
  String voiceDeleteTitle(String name) {
    return '목소리 $name을(를) 삭제할까요?';
  }

  @override
  String get voiceDeleteBody => '녹음이 서버에서 영구적으로 삭제됩니다.';

  @override
  String get serverChecking => '확인 중…';

  @override
  String get serverReady => '준비됨';

  @override
  String get serverDegraded => '일부가 작동하지 않음';

  @override
  String get serverOffline => '사용할 수 없음';

  @override
  String get serverRecheck => '다시 확인';

  @override
  String get deviceTier => '이 기기';

  @override
  String get deviceTierPublic => '기본: 하루 번역 시간 제한';

  @override
  String get deviceTierTester => '테스터: 더 긴 번역과 내 목소리';

  @override
  String get deviceTierUnknown => '서버가 지금 응답하지 않습니다';

  @override
  String get inviteCode => '초대 코드';

  @override
  String get inviteHelp => '앱 제작자에게서 받으며, 테스트가 열립니다';

  @override
  String get inviteWrong => '이 코드는 유효하지 않습니다';

  @override
  String get inviteUnavailable => '지금은 코드를 확인할 수 없습니다. 나중에 다시 시도해 주세요';

  @override
  String get errorQuota => '오늘의 번역 시간을 모두 사용했습니다. 내일 다시 이용할 수 있습니다';

  @override
  String get voiceNeedsInvite => '내 목소리는 아직 초대 코드가 있는 테스터만 사용할 수 있습니다';
}
