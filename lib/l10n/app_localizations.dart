import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// Title for the Found Items page
  ///
  /// In en, this message translates to:
  /// **'Found Items'**
  String get foundItems;

  /// Subtitle for Found Items page
  ///
  /// In en, this message translates to:
  /// **'Help reunite items with their owners'**
  String get helpReuniteItems;

  /// Search placeholder for Found Items page
  ///
  /// In en, this message translates to:
  /// **'Search items, tags, locations...'**
  String get searchItemsTagsLocations;

  /// Title for the Lost Items page
  ///
  /// In en, this message translates to:
  /// **'Lost Items'**
  String get lostItems;

  /// Subtitle for Lost Items page
  ///
  /// In en, this message translates to:
  /// **'Help people find their lost belongings'**
  String get helpFindLostBelongings;

  /// Search placeholder for Lost Items page
  ///
  /// In en, this message translates to:
  /// **'Search lost items...'**
  String get searchLostItems;

  /// Title for the Notifications page
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Subtitle for Notifications page
  ///
  /// In en, this message translates to:
  /// **'Stay updated on your items'**
  String get stayUpdatedOnItems;

  /// Notification message when someone found a wallet
  ///
  /// In en, this message translates to:
  /// **'says they found your lost wallet!'**
  String get saysTheyFoundYourLostWallet;

  /// Notification message when contact is unlocked
  ///
  /// In en, this message translates to:
  /// **'unlocked your contact information'**
  String get unlockedYourContactInformation;

  /// Notification message when someone found a phone
  ///
  /// In en, this message translates to:
  /// **'says they found your phone!'**
  String get saysTheyFoundYourPhone;

  /// Button label to get contact information
  ///
  /// In en, this message translates to:
  /// **'Get Contact'**
  String get getContact;

  /// Button label to confirm item return
  ///
  /// In en, this message translates to:
  /// **'Yes, I got my item back'**
  String get yesIGotMyItemBack;

  /// Success message when item is marked as reunited
  ///
  /// In en, this message translates to:
  /// **'Thanks! We marked {userName} as reunited.'**
  String thanksMarkedAsReunited(String userName);

  /// Generic reference to user's item
  ///
  /// In en, this message translates to:
  /// **'your item'**
  String get yourItem;

  /// Title for the found item popup dialog
  ///
  /// In en, this message translates to:
  /// **'Report Found Item'**
  String get reportFoundItem;

  /// Instructions text in found item popup
  ///
  /// In en, this message translates to:
  /// **'Fill in the details about the found item'**
  String get fillDetailsFoundItem;

  /// Label for photo upload section
  ///
  /// In en, this message translates to:
  /// **'Upload Photos'**
  String get uploadPhotos;

  /// Instruction text for image upload
  ///
  /// In en, this message translates to:
  /// **'Click to upload images'**
  String get clickToUploadImages;

  /// File format and size limit text
  ///
  /// In en, this message translates to:
  /// **'PNG, JPG up to 10MB'**
  String get pngJpgUpTo10MB;

  /// Label for description field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Placeholder for found item description field
  ///
  /// In en, this message translates to:
  /// **'Describe the found item in detail...'**
  String get describeFoundItemDetail;

  /// Label for location field
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Placeholder for found item location field
  ///
  /// In en, this message translates to:
  /// **'Where did you find it?'**
  String get whereDidYouFindIt;

  /// Label for tags field
  ///
  /// In en, this message translates to:
  /// **'Tags (comma separated)'**
  String get tagsCommaSeparated;

  /// Placeholder for tags field
  ///
  /// In en, this message translates to:
  /// **'wallet, keys, phone...'**
  String get walletKeysPhone;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Submit button label
  ///
  /// In en, this message translates to:
  /// **'Submit Post'**
  String get submitPost;

  /// Success message after posting found item
  ///
  /// In en, this message translates to:
  /// **'Found item posted successfully!'**
  String get foundItemPostedSuccessfully;

  /// Title for the lost item popup dialog
  ///
  /// In en, this message translates to:
  /// **'Report Lost Item'**
  String get reportLostItem;

  /// Instructions text in lost item popup
  ///
  /// In en, this message translates to:
  /// **'Fill in the details about the lost item'**
  String get fillDetailsLostItem;

  /// Placeholder for lost item description field
  ///
  /// In en, this message translates to:
  /// **'Describe the lost item in detail...'**
  String get describeLostItemDetail;

  /// Placeholder for lost item location field
  ///
  /// In en, this message translates to:
  /// **'Where did you lose it?'**
  String get whereDidYouLoseIt;

  /// Success message after posting lost item
  ///
  /// In en, this message translates to:
  /// **'Lost item posted successfully!'**
  String get lostItemPostedSuccessfully;

  /// Button label on found item card
  ///
  /// In en, this message translates to:
  /// **'LQitha'**
  String get lqitha;

  /// Button label on lost item card
  ///
  /// In en, this message translates to:
  /// **'LQitou'**
  String get lqitou;

  /// Badge text for items with reward
  ///
  /// In en, this message translates to:
  /// **'Reward offered'**
  String get rewardOffered;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
