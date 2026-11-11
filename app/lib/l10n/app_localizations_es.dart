// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Intérprete';

  @override
  String get me => 'Yo';

  @override
  String get colleague => 'Colega';

  @override
  String get start => 'Iniciar';

  @override
  String get modeLabel => 'Modo';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Mantén y habla';

  @override
  String get modeStreaming => 'Continuo';

  @override
  String get chooseLanguage => 'Elige el idioma';

  @override
  String get history => 'Historial';

  @override
  String get settings => 'Ajustes';

  @override
  String get serverUrl => 'Dirección del servidor';

  @override
  String get save => 'Guardar';

  @override
  String get statusConnecting => 'Conectando…';

  @override
  String get statusListening => 'Escuchando';

  @override
  String get statusRecording => 'Te oigo';

  @override
  String get statusTranslating => 'Traduciendo';

  @override
  String get statusSpeaking => 'Hablando';

  @override
  String get statusPaused => 'En pausa';

  @override
  String get itWasMe => 'Era yo';

  @override
  String get promptAuto => 'Hablad uno por uno';

  @override
  String get promptPtt => 'Mantén pulsado y habla';

  @override
  String get pause => 'Pausa';

  @override
  String get resume => 'Continuar';

  @override
  String get soundOn => 'Sonido activado';

  @override
  String get soundOff => 'Solo texto';

  @override
  String get endConversation => 'Terminar';

  @override
  String get volumeHint => 'Pon el volumen al máximo';

  @override
  String get share => 'Compartir';

  @override
  String get delete => 'Eliminar';

  @override
  String get noHistory => 'Todavía no hay conversaciones';

  @override
  String get micDenied =>
      'Sin acceso al micrófono no funcionará. Permítelo en los ajustes.';

  @override
  String get errorConnection => 'Se perdió la conexión con el servidor';

  @override
  String get errorBackend =>
      'El servicio de traducción no está disponible ahora';

  @override
  String get errorVoice => 'La voz no está disponible, queda el texto';

  @override
  String get errorBusy => 'El servidor está lleno, inténtalo en un momento';

  @override
  String get errorTooLong => 'La intervención es demasiado larga';

  @override
  String get errorGeneric => 'Algo salió mal';

  @override
  String get cancel => 'Cancelar';

  @override
  String get voiceLibrary => 'Mis voces';

  @override
  String get voiceAdd => 'Grabar una voz';

  @override
  String get voiceEmpty => 'Aún no hay ninguna voz.';

  @override
  String get voiceServerError => 'Las voces no están disponibles ahora';

  @override
  String get voiceDefault => 'Voz predeterminada';

  @override
  String get voiceName => 'Pon nombre a la voz';

  @override
  String get voiceConsent =>
      'Acepto que la grabación de mi voz se guarde en el servidor y se use para pronunciar las traducciones con mi voz. Es un dato biométrico, solo puedo grabarme a mí mismo y retiro el consentimiento borrando la voz.';

  @override
  String get voiceReadThis =>
      'Pulsa el botón y lee con naturalidad durante 30 segundos:';

  @override
  String get voiceSampleText =>
      'Buenos días, esta es una muestra de mi voz. Hablo con calma y naturalidad, como si charlara con alguien en la mesa. Ayer salí a pasear, por el camino me encontré con un viejo amigo y nos tomamos un café juntos. Me contó su viaje al mar, el tiempo, la buena comida y lo que le espera en el trabajo. Cuando termine de leer, seguiré con mis propias palabras hasta que acabe la grabación.';

  @override
  String get voiceRecord => 'Grabar 30 segundos';

  @override
  String voiceRecording(int seconds) {
    return 'Grabando, quedan $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return '¿Eliminar la voz $name?';
  }

  @override
  String get voiceDeleteBody =>
      'La grabación se borrará del servidor de forma permanente.';

  @override
  String get serverChecking => 'comprobando…';

  @override
  String get serverReady => 'listo';

  @override
  String get serverDegraded => 'no todo funciona';

  @override
  String get serverOffline => 'no disponible';

  @override
  String get serverRecheck => 'Comprobar de nuevo';

  @override
  String get deviceTier => 'Este dispositivo';

  @override
  String get deviceTierPublic => 'Básico: tiempo de traducción limitado al día';

  @override
  String get deviceTierTester => 'Probador: traducción más larga y voz propia';

  @override
  String get deviceTierUnknown => 'El servidor no responde ahora';

  @override
  String get inviteCode => 'Código de invitación';

  @override
  String get inviteHelp => 'Del autor de la app, desbloquea las pruebas';

  @override
  String get inviteWrong => 'Este código no es válido';

  @override
  String get inviteUnavailable =>
      'Ahora no se puede comprobar el código, inténtalo más tarde';

  @override
  String get errorQuota =>
      'Los minutos de traducción de hoy se han agotado, mañana hay más';

  @override
  String get voiceNeedsInvite =>
      'La voz propia es por ahora solo para probadores con código de invitación';
}
