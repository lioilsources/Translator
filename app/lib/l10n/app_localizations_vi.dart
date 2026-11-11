// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Thông dịch viên';

  @override
  String get me => 'Tôi';

  @override
  String get colleague => 'Đồng nghiệp';

  @override
  String get start => 'Bắt đầu';

  @override
  String get modeLabel => 'Chế độ';

  @override
  String get modeAuto => 'Tự động';

  @override
  String get modePtt => 'Giữ để nói';

  @override
  String get modeStreaming => 'Liên tục';

  @override
  String get chooseLanguage => 'Chọn ngôn ngữ';

  @override
  String get history => 'Lịch sử';

  @override
  String get settings => 'Cài đặt';

  @override
  String get serverUrl => 'Địa chỉ máy chủ';

  @override
  String get save => 'Lưu';

  @override
  String get statusConnecting => 'Đang kết nối…';

  @override
  String get statusListening => 'Đang nghe';

  @override
  String get statusRecording => 'Tôi đang nghe bạn';

  @override
  String get statusTranslating => 'Đang dịch';

  @override
  String get statusSpeaking => 'Đang nói';

  @override
  String get statusPaused => 'Đã tạm dừng';

  @override
  String get itWasMe => 'Đó là tôi';

  @override
  String get promptAuto => 'Hãy nói lần lượt';

  @override
  String get promptPtt => 'Giữ và nói';

  @override
  String get pause => 'Tạm dừng';

  @override
  String get resume => 'Tiếp tục';

  @override
  String get soundOn => 'Bật âm thanh';

  @override
  String get soundOff => 'Chỉ văn bản';

  @override
  String get endConversation => 'Kết thúc';

  @override
  String get volumeHint => 'Hãy để âm lượng ở mức tối đa';

  @override
  String get share => 'Chia sẻ';

  @override
  String get delete => 'Xóa';

  @override
  String get noHistory => 'Chưa có cuộc trò chuyện nào';

  @override
  String get micDenied =>
      'Không có quyền dùng micrô thì không hoạt động được. Hãy cho phép trong cài đặt.';

  @override
  String get errorConnection => 'Mất kết nối với máy chủ';

  @override
  String get errorBackend => 'Dịch vụ dịch hiện không khả dụng';

  @override
  String get errorVoice => 'Giọng nói không khả dụng, văn bản vẫn còn';

  @override
  String get errorBusy => 'Máy chủ đang đầy, hãy thử lại sau ít phút';

  @override
  String get errorTooLong => 'Lời nói quá dài';

  @override
  String get errorGeneric => 'Đã xảy ra lỗi';

  @override
  String get cancel => 'Hủy';

  @override
  String get voiceLibrary => 'Giọng của tôi';

  @override
  String get voiceAdd => 'Ghi âm giọng';

  @override
  String get voiceEmpty => 'Ở đây chưa có giọng nào.';

  @override
  String get voiceServerError => 'Hiện không dùng được giọng';

  @override
  String get voiceDefault => 'Giọng mặc định';

  @override
  String get voiceName => 'Đặt tên cho giọng';

  @override
  String get voiceConsent =>
      'Tôi đồng ý để bản ghi giọng nói của tôi được lưu trên máy chủ và dùng để đọc bản dịch bằng giọng của tôi. Đây là dữ liệu sinh trắc học, tôi chỉ được ghi âm chính mình và tôi rút lại sự đồng ý bằng cách xóa giọng.';

  @override
  String get voiceReadThis => 'Nhấn nút và đọc tự nhiên trong 30 giây:';

  @override
  String get voiceSampleText =>
      'Xin chào, đây là mẫu giọng nói của tôi. Tôi nói bình tĩnh và tự nhiên, như đang trò chuyện với ai đó bên bàn. Hôm qua tôi đi dạo, trên đường gặp một người bạn cũ và chúng tôi cùng uống cà phê. Anh ấy kể về chuyến đi biển, về thời tiết, về những món ăn ngon và về những việc đang chờ anh ấy ở chỗ làm. Khi đọc xong, tôi sẽ cứ tiếp tục bằng lời của mình cho đến khi bản ghi kết thúc.';

  @override
  String get voiceRecord => 'Ghi âm 30 giây';

  @override
  String voiceRecording(int seconds) {
    return 'Đang ghi âm, còn $seconds giây';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Xóa giọng $name?';
  }

  @override
  String get voiceDeleteBody => 'Bản ghi sẽ bị xóa vĩnh viễn khỏi máy chủ.';

  @override
  String get serverChecking => 'đang kiểm tra…';

  @override
  String get serverReady => 'sẵn sàng';

  @override
  String get serverDegraded => 'không phải mọi thứ đều chạy';

  @override
  String get serverOffline => 'không khả dụng';

  @override
  String get serverRecheck => 'Kiểm tra lại';

  @override
  String get deviceTier => 'Thiết bị này';

  @override
  String get deviceTierPublic => 'Cơ bản: thời gian dịch mỗi ngày có giới hạn';

  @override
  String get deviceTierTester =>
      'Người thử nghiệm: dịch lâu hơn và giọng riêng';

  @override
  String get deviceTierUnknown => 'Máy chủ hiện không phản hồi';

  @override
  String get inviteCode => 'Mã mời';

  @override
  String get inviteHelp => 'Từ tác giả ứng dụng, mở khóa thử nghiệm';

  @override
  String get inviteWrong => 'Mã này không hợp lệ';

  @override
  String get inviteUnavailable => 'Hiện chưa kiểm tra được mã, hãy thử lại sau';

  @override
  String get errorQuota => 'Số phút dịch hôm nay đã hết, mai sẽ có lại';

  @override
  String get voiceNeedsInvite =>
      'Giọng riêng hiện chỉ dành cho người thử nghiệm có mã mời';
}
