// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'Διερμηνέας';

  @override
  String get me => 'Εγώ';

  @override
  String get colleague => 'Συνάδελφος';

  @override
  String get start => 'Έναρξη';

  @override
  String get modeLabel => 'Λειτουργία';

  @override
  String get modeAuto => 'Αυτόματα';

  @override
  String get modePtt => 'Κρατήστε και μιλήστε';

  @override
  String get modeStreaming => 'Συνεχής';

  @override
  String get chooseLanguage => 'Επιλέξτε γλώσσα';

  @override
  String get history => 'Ιστορικό';

  @override
  String get settings => 'Ρυθμίσεις';

  @override
  String get serverUrl => 'Διεύθυνση διακομιστή';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get statusConnecting => 'Σύνδεση…';

  @override
  String get statusListening => 'Ακούω';

  @override
  String get statusRecording => 'Σας ακούω';

  @override
  String get statusTranslating => 'Μεταφράζω';

  @override
  String get statusSpeaking => 'Μιλάω';

  @override
  String get statusPaused => 'Σε παύση';

  @override
  String get itWasMe => 'Ήμουν εγώ';

  @override
  String get promptAuto => 'Μιλήστε ο ένας μετά τον άλλον';

  @override
  String get promptPtt => 'Κρατήστε και μιλήστε';

  @override
  String get pause => 'Παύση';

  @override
  String get resume => 'Συνέχεια';

  @override
  String get soundOn => 'Ήχος ενεργός';

  @override
  String get soundOff => 'Μόνο κείμενο';

  @override
  String get endConversation => 'Τέλος';

  @override
  String get volumeHint => 'Βάλτε την ένταση στο μέγιστο';

  @override
  String get share => 'Κοινοποίηση';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get noHistory => 'Δεν υπάρχουν ακόμη συνομιλίες';

  @override
  String get micDenied =>
      'Χωρίς πρόσβαση στο μικρόφωνο δεν θα λειτουργήσει. Επιτρέψτε την στις ρυθμίσεις.';

  @override
  String get errorConnection => 'Χάθηκε η σύνδεση με τον διακομιστή';

  @override
  String get errorBackend =>
      'Η υπηρεσία μετάφρασης δεν είναι διαθέσιμη αυτή τη στιγμή';

  @override
  String get errorVoice => 'Η φωνή δεν είναι διαθέσιμη, μένει το κείμενο';

  @override
  String get errorBusy => 'Ο διακομιστής είναι γεμάτος, δοκιμάστε σε λίγο';

  @override
  String get errorTooLong => 'Η ομιλία είναι πολύ μεγάλη';

  @override
  String get errorGeneric => 'Κάτι πήγε στραβά';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get voiceLibrary => 'Οι φωνές μου';

  @override
  String get voiceAdd => 'Ηχογράφηση φωνής';

  @override
  String get voiceEmpty => 'Δεν υπάρχει ακόμη καμία φωνή.';

  @override
  String get voiceServerError => 'Οι φωνές δεν είναι διαθέσιμες αυτή τη στιγμή';

  @override
  String get voiceDefault => 'Προεπιλεγμένη φωνή';

  @override
  String get voiceName => 'Ονομάστε τη φωνή';

  @override
  String get voiceConsent =>
      'Συναινώ να αποθηκευτεί η ηχογράφηση της φωνής μου στον διακομιστή και να χρησιμοποιηθεί για να εκφωνούνται οι μεταφράσεις με τη φωνή μου. Είναι βιομετρικό δεδομένο, επιτρέπεται να ηχογραφώ μόνο τον εαυτό μου και ανακαλώ τη συναίνεση διαγράφοντας τη φωνή.';

  @override
  String get voiceReadThis =>
      'Πατήστε το κουμπί και διαβάστε φυσικά για 30 δευτερόλεπτα:';

  @override
  String get voiceSampleText =>
      'Καλημέρα, αυτό είναι ένα δείγμα της φωνής μου. Μιλάω ήρεμα και φυσικά, σαν να κουβεντιάζω με κάποιον στο τραπέζι. Χθες πήγα μια βόλτα, στον δρόμο συνάντησα έναν παλιό φίλο και ήπιαμε μαζί έναν καφέ. Μου διηγήθηκε για το ταξίδι του στη θάλασσα, για τον καιρό, για το καλό φαγητό και για το τι τον περιμένει στη δουλειά. Όταν τελειώσω το διάβασμα, θα συνεχίσω με δικά μου λόγια μέχρι να τελειώσει η ηχογράφηση.';

  @override
  String get voiceRecord => 'Ηχογράφηση 30 δευτερολέπτων';

  @override
  String voiceRecording(int seconds) {
    return 'Ηχογράφηση, απομένουν $seconds δ';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Διαγραφή της φωνής $name;';
  }

  @override
  String get voiceDeleteBody =>
      'Η ηχογράφηση θα διαγραφεί οριστικά από τον διακομιστή.';

  @override
  String get serverChecking => 'έλεγχος…';

  @override
  String get serverReady => 'έτοιμο';

  @override
  String get serverDegraded => 'δεν λειτουργούν όλα';

  @override
  String get serverOffline => 'μη διαθέσιμο';

  @override
  String get serverRecheck => 'Νέος έλεγχος';

  @override
  String get deviceTier => 'Αυτή η συσκευή';

  @override
  String get deviceTierPublic =>
      'Βασικό: περιορισμένος χρόνος μετάφρασης ανά ημέρα';

  @override
  String get deviceTierTester =>
      'Δοκιμαστής: μεγαλύτερη μετάφραση και δική σας φωνή';

  @override
  String get deviceTierUnknown => 'Ο διακομιστής δεν απαντά αυτή τη στιγμή';

  @override
  String get inviteCode => 'Κωδικός πρόσκλησης';

  @override
  String get inviteHelp =>
      'Από τον δημιουργό της εφαρμογής, ξεκλειδώνει τη δοκιμή';

  @override
  String get inviteWrong => 'Αυτός ο κωδικός δεν ισχύει';

  @override
  String get inviteUnavailable =>
      'Ο κωδικός δεν μπορεί να ελεγχθεί τώρα, δοκιμάστε αργότερα';

  @override
  String get errorQuota =>
      'Τα λεπτά μετάφρασης για σήμερα τελείωσαν, αύριο ξανά';

  @override
  String get voiceNeedsInvite =>
      'Η δική σας φωνή είναι προς το παρόν μόνο για δοκιμαστές με κωδικό πρόσκλησης';
}
