// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Intérprete';

  @override
  String get me => 'Eu';

  @override
  String get colleague => 'Colega';

  @override
  String get start => 'Iniciar';

  @override
  String get modeLabel => 'Modo';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Segure e fale';

  @override
  String get modeStreaming => 'Contínuo';

  @override
  String get chooseLanguage => 'Escolha o idioma';

  @override
  String get history => 'Histórico';

  @override
  String get settings => 'Ajustes';

  @override
  String get serverUrl => 'Endereço do servidor';

  @override
  String get save => 'Salvar';

  @override
  String get statusConnecting => 'Conectando…';

  @override
  String get statusListening => 'Ouvindo';

  @override
  String get statusRecording => 'Estou ouvindo você';

  @override
  String get statusTranslating => 'Traduzindo';

  @override
  String get statusSpeaking => 'Falando';

  @override
  String get statusPaused => 'Pausado';

  @override
  String get itWasMe => 'Era eu';

  @override
  String get promptAuto => 'Falem um de cada vez';

  @override
  String get promptPtt => 'Segure e fale';

  @override
  String get pause => 'Pausar';

  @override
  String get resume => 'Continuar';

  @override
  String get soundOn => 'Som ligado';

  @override
  String get soundOff => 'Só texto';

  @override
  String get endConversation => 'Encerrar';

  @override
  String get volumeHint => 'Coloque o volume no máximo';

  @override
  String get share => 'Compartilhar';

  @override
  String get delete => 'Excluir';

  @override
  String get noHistory => 'Ainda não há conversas';

  @override
  String get micDenied =>
      'Sem acesso ao microfone não vai funcionar. Permita nos ajustes.';

  @override
  String get errorConnection => 'A conexão com o servidor foi perdida';

  @override
  String get errorBackend => 'O serviço de tradução está indisponível agora';

  @override
  String get errorVoice => 'A voz não está disponível, o texto permanece';

  @override
  String get errorBusy => 'O servidor está cheio, tente de novo daqui a pouco';

  @override
  String get errorTooLong => 'A fala é longa demais';

  @override
  String get errorGeneric => 'Algo deu errado';

  @override
  String get cancel => 'Cancelar';

  @override
  String get voiceLibrary => 'Minhas vozes';

  @override
  String get voiceAdd => 'Gravar uma voz';

  @override
  String get voiceEmpty => 'Ainda não há nenhuma voz aqui.';

  @override
  String get voiceServerError => 'As vozes estão indisponíveis agora';

  @override
  String get voiceDefault => 'Voz padrão';

  @override
  String get voiceName => 'Dê um nome à voz';

  @override
  String get voiceConsent =>
      'Concordo que a gravação da minha voz seja armazenada no servidor e usada para falar as traduções com a minha voz. É um dado biométrico, só posso gravar a mim mesmo e retiro o consentimento excluindo a voz.';

  @override
  String get voiceReadThis =>
      'Aperte o botão e leia naturalmente por 30 segundos:';

  @override
  String get voiceSampleText =>
      'Bom dia, esta é uma amostra da minha voz. Falo com calma e naturalidade, como se estivesse conversando com alguém à mesa. Ontem saí para caminhar, no caminho encontrei um velho amigo e tomamos um café juntos. Ele me contou da viagem dele à praia, do clima, da boa comida e do que o espera no trabalho. Quando eu terminar de ler, vou continuar com as minhas próprias palavras até a gravação acabar.';

  @override
  String get voiceRecord => 'Gravar 30 segundos';

  @override
  String voiceRecording(int seconds) {
    return 'Gravando, faltam $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Excluir a voz $name?';
  }

  @override
  String get voiceDeleteBody =>
      'A gravação será excluída permanentemente do servidor.';

  @override
  String get serverChecking => 'verificando…';

  @override
  String get serverReady => 'pronto';

  @override
  String get serverDegraded => 'nem tudo funciona';

  @override
  String get serverOffline => 'indisponível';

  @override
  String get serverRecheck => 'Verificar de novo';

  @override
  String get deviceTier => 'Este dispositivo';

  @override
  String get deviceTierPublic => 'Básico: tempo de tradução limitado por dia';

  @override
  String get deviceTierTester => 'Testador: tradução mais longa e voz própria';

  @override
  String get deviceTierUnknown => 'O servidor não está respondendo agora';

  @override
  String get inviteCode => 'Código de convite';

  @override
  String get inviteHelp => 'Do autor do app, libera os testes';

  @override
  String get inviteWrong => 'Este código não é válido';

  @override
  String get inviteUnavailable =>
      'Não foi possível verificar o código agora, tente mais tarde';

  @override
  String get errorQuota =>
      'Os minutos de tradução de hoje acabaram, amanhã tem mais';

  @override
  String get voiceNeedsInvite =>
      'A voz própria é, por enquanto, só para testadores com código de convite';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Intérprete';

  @override
  String get me => 'Eu';

  @override
  String get colleague => 'Colega';

  @override
  String get start => 'Iniciar';

  @override
  String get modeLabel => 'Modo';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Segure e fale';

  @override
  String get modeStreaming => 'Contínuo';

  @override
  String get chooseLanguage => 'Escolha o idioma';

  @override
  String get history => 'Histórico';

  @override
  String get settings => 'Ajustes';

  @override
  String get serverUrl => 'Endereço do servidor';

  @override
  String get save => 'Salvar';

  @override
  String get statusConnecting => 'Conectando…';

  @override
  String get statusListening => 'Ouvindo';

  @override
  String get statusRecording => 'Estou ouvindo você';

  @override
  String get statusTranslating => 'Traduzindo';

  @override
  String get statusSpeaking => 'Falando';

  @override
  String get statusPaused => 'Pausado';

  @override
  String get itWasMe => 'Era eu';

  @override
  String get promptAuto => 'Falem um de cada vez';

  @override
  String get promptPtt => 'Segure e fale';

  @override
  String get pause => 'Pausar';

  @override
  String get resume => 'Continuar';

  @override
  String get soundOn => 'Som ligado';

  @override
  String get soundOff => 'Só texto';

  @override
  String get endConversation => 'Encerrar';

  @override
  String get volumeHint => 'Coloque o volume no máximo';

  @override
  String get share => 'Compartilhar';

  @override
  String get delete => 'Excluir';

  @override
  String get noHistory => 'Ainda não há conversas';

  @override
  String get micDenied =>
      'Sem acesso ao microfone não vai funcionar. Permita nos ajustes.';

  @override
  String get errorConnection => 'A conexão com o servidor foi perdida';

  @override
  String get errorBackend => 'O serviço de tradução está indisponível agora';

  @override
  String get errorVoice => 'A voz não está disponível, o texto permanece';

  @override
  String get errorBusy => 'O servidor está cheio, tente de novo daqui a pouco';

  @override
  String get errorTooLong => 'A fala é longa demais';

  @override
  String get errorGeneric => 'Algo deu errado';

  @override
  String get cancel => 'Cancelar';

  @override
  String get voiceLibrary => 'Minhas vozes';

  @override
  String get voiceAdd => 'Gravar uma voz';

  @override
  String get voiceEmpty => 'Ainda não há nenhuma voz aqui.';

  @override
  String get voiceServerError => 'As vozes estão indisponíveis agora';

  @override
  String get voiceDefault => 'Voz padrão';

  @override
  String get voiceName => 'Dê um nome à voz';

  @override
  String get voiceConsent =>
      'Concordo que a gravação da minha voz seja armazenada no servidor e usada para falar as traduções com a minha voz. É um dado biométrico, só posso gravar a mim mesmo e retiro o consentimento excluindo a voz.';

  @override
  String get voiceReadThis =>
      'Aperte o botão e leia naturalmente por 30 segundos:';

  @override
  String get voiceSampleText =>
      'Bom dia, esta é uma amostra da minha voz. Falo com calma e naturalidade, como se estivesse conversando com alguém à mesa. Ontem saí para caminhar, no caminho encontrei um velho amigo e tomamos um café juntos. Ele me contou da viagem dele à praia, do clima, da boa comida e do que o espera no trabalho. Quando eu terminar de ler, vou continuar com as minhas próprias palavras até a gravação acabar.';

  @override
  String get voiceRecord => 'Gravar 30 segundos';

  @override
  String voiceRecording(int seconds) {
    return 'Gravando, faltam $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Excluir a voz $name?';
  }

  @override
  String get voiceDeleteBody =>
      'A gravação será excluída permanentemente do servidor.';

  @override
  String get serverChecking => 'verificando…';

  @override
  String get serverReady => 'pronto';

  @override
  String get serverDegraded => 'nem tudo funciona';

  @override
  String get serverOffline => 'indisponível';

  @override
  String get serverRecheck => 'Verificar de novo';

  @override
  String get deviceTier => 'Este dispositivo';

  @override
  String get deviceTierPublic => 'Básico: tempo de tradução limitado por dia';

  @override
  String get deviceTierTester => 'Testador: tradução mais longa e voz própria';

  @override
  String get deviceTierUnknown => 'O servidor não está respondendo agora';

  @override
  String get inviteCode => 'Código de convite';

  @override
  String get inviteHelp => 'Do autor do app, libera os testes';

  @override
  String get inviteWrong => 'Este código não é válido';

  @override
  String get inviteUnavailable =>
      'Não foi possível verificar o código agora, tente mais tarde';

  @override
  String get errorQuota =>
      'Os minutos de tradução de hoje acabaram, amanhã tem mais';

  @override
  String get voiceNeedsInvite =>
      'A voz própria é, por enquanto, só para testadores com código de convite';
}

/// The translations for Portuguese, as used in Portugal (`pt_PT`).
class AppLocalizationsPtPt extends AppLocalizationsPt {
  AppLocalizationsPtPt() : super('pt_PT');

  @override
  String get appTitle => 'Intérprete';

  @override
  String get me => 'Eu';

  @override
  String get colleague => 'Colega';

  @override
  String get start => 'Iniciar';

  @override
  String get modeLabel => 'Modo';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Mantenha e fale';

  @override
  String get modeStreaming => 'Contínuo';

  @override
  String get chooseLanguage => 'Escolha o idioma';

  @override
  String get history => 'Histórico';

  @override
  String get settings => 'Definições';

  @override
  String get serverUrl => 'Endereço do servidor';

  @override
  String get save => 'Guardar';

  @override
  String get statusConnecting => 'A ligar…';

  @override
  String get statusListening => 'A ouvir';

  @override
  String get statusRecording => 'Estou a ouvi-lo';

  @override
  String get statusTranslating => 'A traduzir';

  @override
  String get statusSpeaking => 'A falar';

  @override
  String get statusPaused => 'Em pausa';

  @override
  String get itWasMe => 'Era eu';

  @override
  String get promptAuto => 'Falem um de cada vez';

  @override
  String get promptPtt => 'Mantenha premido e fale';

  @override
  String get pause => 'Pausa';

  @override
  String get resume => 'Continuar';

  @override
  String get soundOn => 'Som ligado';

  @override
  String get soundOff => 'Só texto';

  @override
  String get endConversation => 'Terminar';

  @override
  String get volumeHint => 'Coloque o volume no máximo';

  @override
  String get share => 'Partilhar';

  @override
  String get delete => 'Eliminar';

  @override
  String get noHistory => 'Ainda não há conversas';

  @override
  String get micDenied =>
      'Sem acesso ao microfone não vai funcionar. Permita-o nas definições.';

  @override
  String get errorConnection => 'A ligação ao servidor perdeu-se';

  @override
  String get errorBackend =>
      'O serviço de tradução está indisponível neste momento';

  @override
  String get errorVoice => 'A voz não está disponível, o texto mantém-se';

  @override
  String get errorBusy =>
      'O servidor está cheio, tente novamente daqui a pouco';

  @override
  String get errorTooLong => 'A intervenção é demasiado longa';

  @override
  String get errorGeneric => 'Algo correu mal';

  @override
  String get cancel => 'Cancelar';

  @override
  String get voiceLibrary => 'As minhas vozes';

  @override
  String get voiceAdd => 'Gravar uma voz';

  @override
  String get voiceEmpty => 'Ainda não há nenhuma voz aqui.';

  @override
  String get voiceServerError => 'As vozes estão indisponíveis neste momento';

  @override
  String get voiceDefault => 'Voz predefinida';

  @override
  String get voiceName => 'Dê um nome à voz';

  @override
  String get voiceConsent =>
      'Concordo que a gravação da minha voz seja guardada no servidor e usada para dizer as traduções com a minha voz. É um dado biométrico, só posso gravar-me a mim próprio e retiro o consentimento eliminando a voz.';

  @override
  String get voiceReadThis =>
      'Prima o botão e leia naturalmente durante 30 segundos:';

  @override
  String get voiceSampleText =>
      'Bom dia, esta é uma amostra da minha voz. Falo com calma e naturalidade, como se estivesse a conversar com alguém à mesa. Ontem fui passear, pelo caminho encontrei um velho amigo e tomámos um café juntos. Contou-me da viagem dele ao mar, do tempo, da boa comida e do que o espera no trabalho. Quando acabar de ler, continuarei com as minhas próprias palavras até a gravação terminar.';

  @override
  String get voiceRecord => 'Gravar 30 segundos';

  @override
  String voiceRecording(int seconds) {
    return 'A gravar, faltam $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Eliminar a voz $name?';
  }

  @override
  String get voiceDeleteBody =>
      'A gravação será eliminada permanentemente do servidor.';

  @override
  String get serverChecking => 'a verificar…';

  @override
  String get serverReady => 'pronto';

  @override
  String get serverDegraded => 'nem tudo funciona';

  @override
  String get serverOffline => 'indisponível';

  @override
  String get serverRecheck => 'Verificar de novo';

  @override
  String get deviceTier => 'Este dispositivo';

  @override
  String get deviceTierPublic => 'Básico: tempo de tradução limitado por dia';

  @override
  String get deviceTierTester => 'Testador: tradução mais longa e voz própria';

  @override
  String get deviceTierUnknown =>
      'O servidor não está a responder neste momento';

  @override
  String get inviteCode => 'Código de convite';

  @override
  String get inviteHelp => 'Do autor da aplicação, desbloqueia os testes';

  @override
  String get inviteWrong => 'Este código não é válido';

  @override
  String get inviteUnavailable =>
      'Não foi possível verificar o código agora, tente mais tarde';

  @override
  String get errorQuota =>
      'Os minutos de tradução de hoje acabaram, amanhã há mais';

  @override
  String get voiceNeedsInvite =>
      'A voz própria é, por agora, só para testadores com código de convite';
}
