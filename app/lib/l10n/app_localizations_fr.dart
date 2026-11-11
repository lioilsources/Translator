// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Interprète';

  @override
  String get me => 'Moi';

  @override
  String get colleague => 'Collègue';

  @override
  String get start => 'Démarrer';

  @override
  String get modeLabel => 'Mode';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Maintenir et parler';

  @override
  String get modeStreaming => 'En continu';

  @override
  String get chooseLanguage => 'Choisissez la langue';

  @override
  String get history => 'Historique';

  @override
  String get settings => 'Réglages';

  @override
  String get serverUrl => 'Adresse du serveur';

  @override
  String get save => 'Enregistrer';

  @override
  String get statusConnecting => 'Connexion…';

  @override
  String get statusListening => 'J\'écoute';

  @override
  String get statusRecording => 'Je vous entends';

  @override
  String get statusTranslating => 'Traduction';

  @override
  String get statusSpeaking => 'Je parle';

  @override
  String get statusPaused => 'En pause';

  @override
  String get itWasMe => 'C\'était moi';

  @override
  String get promptAuto => 'Parlez chacun votre tour';

  @override
  String get promptPtt => 'Maintenez et parlez';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Reprendre';

  @override
  String get soundOn => 'Son activé';

  @override
  String get soundOff => 'Texte seul';

  @override
  String get endConversation => 'Terminer';

  @override
  String get volumeHint => 'Mettez le volume au maximum';

  @override
  String get share => 'Partager';

  @override
  String get delete => 'Supprimer';

  @override
  String get noHistory => 'Aucune conversation pour l\'instant';

  @override
  String get micDenied =>
      'Sans accès au micro, ça ne marchera pas. Autorisez-le dans les réglages.';

  @override
  String get errorConnection => 'La connexion au serveur a été perdue';

  @override
  String get errorBackend =>
      'Le service de traduction est indisponible pour le moment';

  @override
  String get errorVoice => 'La voix est indisponible, le texte reste';

  @override
  String get errorBusy => 'Le serveur est saturé, réessayez dans un instant';

  @override
  String get errorTooLong => 'La prise de parole est trop longue';

  @override
  String get errorGeneric => 'Une erreur est survenue';

  @override
  String get cancel => 'Annuler';

  @override
  String get voiceLibrary => 'Mes voix';

  @override
  String get voiceAdd => 'Enregistrer une voix';

  @override
  String get voiceEmpty => 'Aucune voix pour l\'instant.';

  @override
  String get voiceServerError => 'Les voix sont indisponibles pour le moment';

  @override
  String get voiceDefault => 'Voix par défaut';

  @override
  String get voiceName => 'Nommez la voix';

  @override
  String get voiceConsent =>
      'J\'accepte que l\'enregistrement de ma voix soit conservé sur le serveur et utilisé pour prononcer les traductions avec ma voix. C\'est une donnée biométrique, je ne peux enregistrer que moi-même et je retire mon consentement en supprimant la voix.';

  @override
  String get voiceReadThis =>
      'Appuyez sur le bouton et lisez naturellement pendant 30 secondes :';

  @override
  String get voiceSampleText =>
      'Bonjour, voici un échantillon de ma voix. Je parle calmement et naturellement, comme si je bavardais avec quelqu\'un à table. Hier, je suis allé me promener, en chemin j\'ai croisé un vieil ami et nous avons pris un café ensemble. Il m\'a raconté son voyage à la mer, le temps qu\'il faisait, les bons repas et ce qui l\'attend au travail. Quand j\'aurai fini de lire, je continuerai avec mes propres mots jusqu\'à la fin de l\'enregistrement.';

  @override
  String get voiceRecord => 'Enregistrer 30 secondes';

  @override
  String voiceRecording(int seconds) {
    return 'Enregistrement, il reste $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Supprimer la voix $name ?';
  }

  @override
  String get voiceDeleteBody =>
      'L\'enregistrement sera supprimé définitivement du serveur.';

  @override
  String get serverChecking => 'vérification…';

  @override
  String get serverReady => 'prêt';

  @override
  String get serverDegraded => 'tout ne fonctionne pas';

  @override
  String get serverOffline => 'indisponible';

  @override
  String get serverRecheck => 'Revérifier';

  @override
  String get deviceTier => 'Cet appareil';

  @override
  String get deviceTierPublic =>
      'Basique : temps de traduction limité par jour';

  @override
  String get deviceTierTester =>
      'Testeur : traduction plus longue et voix personnelle';

  @override
  String get deviceTierUnknown => 'Le serveur ne répond pas pour le moment';

  @override
  String get inviteCode => 'Code d\'invitation';

  @override
  String get inviteHelp => 'De l\'auteur de l\'appli, débloque les tests';

  @override
  String get inviteWrong => 'Ce code n\'est pas valide';

  @override
  String get inviteUnavailable =>
      'Le code ne peut pas être vérifié maintenant, réessayez plus tard';

  @override
  String get errorQuota =>
      'Les minutes de traduction du jour sont épuisées, demain ça repart';

  @override
  String get voiceNeedsInvite =>
      'La voix personnelle est pour l\'instant réservée aux testeurs avec un code d\'invitation';
}
