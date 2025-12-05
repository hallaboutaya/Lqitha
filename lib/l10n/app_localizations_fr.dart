// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get foundItems => 'Objets Trouvés';

  @override
  String get helpReuniteItems =>
      'Aidez à réunir les objets avec leurs propriétaires';

  @override
  String get searchItemsTagsLocations =>
      'Rechercher des objets, des tags, des lieux...';

  @override
  String get lostItems => 'Objets Perdus';

  @override
  String get helpFindLostBelongings =>
      'Aidez les gens à retrouver leurs objets perdus';

  @override
  String get searchLostItems => 'Rechercher des objets perdus...';

  @override
  String get notifications => 'Notifications';

  @override
  String get stayUpdatedOnItems => 'Restez informé sur vos objets';

  @override
  String get saysTheyFoundYourLostWallet =>
      'dit qu\'il a trouvé votre portefeuille perdu !';

  @override
  String get unlockedYourContactInformation =>
      'a déverrouillé vos informations de contact';

  @override
  String get saysTheyFoundYourPhone => 'dit qu\'il a trouvé votre téléphone !';

  @override
  String get getContact => 'Obtenir le Contact';

  @override
  String get yesIGotMyItemBack => 'Oui, j\'ai récupéré mon objet';

  @override
  String thanksMarkedAsReunited(String userName) {
    return 'Merci ! Nous avons marqué $userName comme réuni.';
  }

  @override
  String get yourItem => 'votre objet';

  @override
  String get reportFoundItem => 'Signaler un Objet Trouvé';

  @override
  String get fillDetailsFoundItem =>
      'Remplissez les détails sur l\'objet trouvé';

  @override
  String get uploadPhotos => 'Télécharger des Photos';

  @override
  String get clickToUploadImages => 'Cliquez pour télécharger des images';

  @override
  String get pngJpgUpTo10MB => 'PNG, JPG jusqu\'à 10 Mo';

  @override
  String get description => 'Description';

  @override
  String get describeFoundItemDetail => 'Décrivez l\'objet trouvé en détail...';

  @override
  String get location => 'Lieu';

  @override
  String get whereDidYouFindIt => 'Où l\'avez-vous trouvé ?';

  @override
  String get tagsCommaSeparated => 'Tags (séparés par des virgules)';

  @override
  String get walletKeysPhone => 'portefeuille, clés, téléphone...';

  @override
  String get cancel => 'Annuler';

  @override
  String get submitPost => 'Publier';

  @override
  String get foundItemPostedSuccessfully => 'Objet trouvé publié avec succès !';

  @override
  String get reportLostItem => 'Signaler un Objet Perdu';

  @override
  String get fillDetailsLostItem => 'Remplissez les détails sur l\'objet perdu';

  @override
  String get describeLostItemDetail => 'Décrivez l\'objet perdu en détail...';

  @override
  String get whereDidYouLoseIt => 'Où l\'avez-vous perdu ?';

  @override
  String get lostItemPostedSuccessfully => 'Objet perdu publié avec succès !';

  @override
  String get lqitha => 'LQitha';

  @override
  String get lqitou => 'LQitou';

  @override
  String get rewardOffered => 'Récompense offerte';
}
