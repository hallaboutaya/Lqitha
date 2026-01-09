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

  /// Title for confirmation dialog when user clicks Lqitou
  ///
  /// In en, this message translates to:
  /// **'Found this item?'**
  String get foundThisItem;

  /// Confirmation message when user clicks Lqitou
  ///
  /// In en, this message translates to:
  /// **'Are you sure you found this item? The owner will be notified.'**
  String get areYouSureFoundItem;

  /// Confirmation button text in Lqitou dialog
  ///
  /// In en, this message translates to:
  /// **'Yes, I found it!'**
  String get yesIFoundIt;

  /// Success message after converting lost post to found post
  ///
  /// In en, this message translates to:
  /// **'Great! The owner has been notified. The item has been moved to Found Items.'**
  String get ownerNotifiedItemMoved;

  /// Notification title when someone finds a lost item
  ///
  /// In en, this message translates to:
  /// **'Someone found your item!'**
  String get someoneFoundYourItem;

  /// Notification message when someone finds a lost item
  ///
  /// In en, this message translates to:
  /// **'Good news! Someone says they found your lost item: {itemDescription}'**
  String goodNewsSomeoneFound(String itemDescription);

  /// Welcome message on auth landing screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to Lqitha'**
  String get welcomeToLqitha;

  /// Subtitle on auth landing screen
  ///
  /// In en, this message translates to:
  /// **'Find and report lost items with the community'**
  String get findAndReportLostItems;

  /// Button label to create account
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Button label to sign in
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Welcome message on login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// Subtitle on login screen
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to LQitha'**
  String get signInToContinue;

  /// User role label
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Admin role label
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// Button label to sign in as user
  ///
  /// In en, this message translates to:
  /// **'Sign in as User'**
  String get signInAsUser;

  /// Button label to sign in as admin
  ///
  /// In en, this message translates to:
  /// **'Sign in as Admin'**
  String get signInAsAdmin;

  /// Text before sign up link on login screen
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Link to sign up page
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// Label for email field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Validation message for empty email
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// Validation message for invalid email
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// Label for password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Validation message for empty password
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// Label for full name field
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Validation message for full name
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// Label for phone number field
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Validation message for empty phone number
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// Validation message for invalid phone number
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get enterValidPhoneNumber;

  /// Validation message for password length
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters'**
  String get useAtLeast6Characters;

  /// Text before sign in link on signup screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Title on admin dashboard
  ///
  /// In en, this message translates to:
  /// **'Lqitha Admin'**
  String get lqithaAdmin;

  /// Subtitle on admin dashboard
  ///
  /// In en, this message translates to:
  /// **'Manage posts and platform activity'**
  String get managePostsAndActivity;

  /// Button label for admin panel
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// Button label to logout
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Error label prefix
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Button label to retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Stat card title for total posts
  ///
  /// In en, this message translates to:
  /// **'Total Posts'**
  String get totalPosts;

  /// Stat card title for pending posts
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get pendingReview;

  /// Stat card title for approved posts today
  ///
  /// In en, this message translates to:
  /// **'Total Approved'**
  String get approvedToday;

  /// Stat card title for active users
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get activeUsers;

  /// Placeholder for search field in admin dashboard
  ///
  /// In en, this message translates to:
  /// **'Search posts...'**
  String get searchPosts;

  /// Message when there are no posts to review
  ///
  /// In en, this message translates to:
  /// **'No posts to review'**
  String get noPostsToReview;

  /// Success message when post is approved
  ///
  /// In en, this message translates to:
  /// **'Post approved successfully'**
  String get postApprovedSuccessfully;

  /// Notification title when admin rejects a post
  ///
  /// In en, this message translates to:
  /// **'Post Rejected'**
  String get postRejected;

  /// Button label to approve post
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// Button label to reject post
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Notification title when admin approves a post
  ///
  /// In en, this message translates to:
  /// **'Post Approved'**
  String get postApproved;

  /// Notification message when admin approves a post
  ///
  /// In en, this message translates to:
  /// **'Admin approved your {postType} post and it is now visible to users.'**
  String adminApprovedYourPost(String postType);

  /// Notification message when admin rejects a post
  ///
  /// In en, this message translates to:
  /// **'Admin rejected your {postType} post.'**
  String adminRejectedYourPost(String postType);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profileAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Profile & Security'**
  String get profileAndSecurity;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @aboutLqitha.
  ///
  /// In en, this message translates to:
  /// **'About Lqitha'**
  String get aboutLqitha;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @manageAlerts.
  ///
  /// In en, this message translates to:
  /// **'Manage your alerts'**
  String get manageAlerts;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @setSecurePassword.
  ///
  /// In en, this message translates to:
  /// **'Set a secure password to protect your account'**
  String get setSecurePassword;

  /// No description provided for @min8Characters.
  ///
  /// In en, this message translates to:
  /// **'Min 8 characters'**
  String get min8Characters;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @enterOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter old password'**
  String get enterOldPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully!'**
  String get passwordChangedSuccessfully;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @nameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameCannotBeEmpty;

  /// No description provided for @profilePictureUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile picture updated!'**
  String get profilePictureUpdated;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @totalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get totalPoints;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @keepHelpingOthers.
  ///
  /// In en, this message translates to:
  /// **'Keep helping others to earn more!'**
  String get keepHelpingOthers;

  /// No description provided for @reclaimMyPoints.
  ///
  /// In en, this message translates to:
  /// **'Reclaim My Points'**
  String get reclaimMyPoints;

  /// No description provided for @itemsFound.
  ///
  /// In en, this message translates to:
  /// **'Items Found'**
  String get itemsFound;

  /// No description provided for @itemsLost.
  ///
  /// In en, this message translates to:
  /// **'Items Lost'**
  String get itemsLost;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @createPostToEarnPoints.
  ///
  /// In en, this message translates to:
  /// **'Create a post to earn points!'**
  String get createPostToEarnPoints;

  /// No description provided for @myPosts.
  ///
  /// In en, this message translates to:
  /// **'My Posts'**
  String get myPosts;

  /// No description provided for @validated.
  ///
  /// In en, this message translates to:
  /// **'Validated'**
  String get validated;

  /// No description provided for @onHold.
  ///
  /// In en, this message translates to:
  /// **'On Hold'**
  String get onHold;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @waitingForAdminApproval.
  ///
  /// In en, this message translates to:
  /// **'Waiting for admin approval'**
  String get waitingForAdminApproval;

  /// No description provided for @postWasRejectedByAdmin.
  ///
  /// In en, this message translates to:
  /// **'Post was rejected by admin'**
  String get postWasRejectedByAdmin;

  /// No description provided for @noPostsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No posts in this category'**
  String get noPostsInCategory;

  /// No description provided for @found.
  ///
  /// In en, this message translates to:
  /// **'Found'**
  String get found;

  /// No description provided for @lost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get lost;

  /// No description provided for @trustPoints.
  ///
  /// In en, this message translates to:
  /// **'Trust Points'**
  String get trustPoints;

  /// No description provided for @someone.
  ///
  /// In en, this message translates to:
  /// **'Someone'**
  String get someone;

  /// No description provided for @userWithId.
  ///
  /// In en, this message translates to:
  /// **'User {id}'**
  String userWithId(String id);

  /// No description provided for @unknownTime.
  ///
  /// In en, this message translates to:
  /// **'Unknown time'**
  String get unknownTime;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @secondsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} seconds ago'**
  String secondsAgo(int count);

  /// No description provided for @minuteAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String minuteAgo(int count);

  /// No description provided for @hourAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String hourAgo(int count);

  /// No description provided for @dayAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String dayAgo(int count);

  /// No description provided for @weekAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week ago} other{{count} weeks ago}}'**
  String weekAgo(int count);

  /// No description provided for @monthAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month ago} other{{count} months ago}}'**
  String monthAgo(int count);

  /// No description provided for @yearAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 year ago} other{{count} years ago}}'**
  String yearAgo(int count);

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @postIdNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Post ID not available'**
  String get postIdNotAvailable;

  /// No description provided for @noFoundItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No found items yet'**
  String get noFoundItemsYet;

  /// No description provided for @noLostItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No lost items yet'**
  String get noLostItemsYet;

  /// No description provided for @userInsights.
  ///
  /// In en, this message translates to:
  /// **'User Insights'**
  String get userInsights;

  /// No description provided for @avgPoints.
  ///
  /// In en, this message translates to:
  /// **'Avg Points'**
  String get avgPoints;

  /// No description provided for @successRate.
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get successRate;

  /// No description provided for @performanceRankings.
  ///
  /// In en, this message translates to:
  /// **'Performance Rankings'**
  String get performanceRankings;

  /// No description provided for @searchUsersByName.
  ///
  /// In en, this message translates to:
  /// **'Search users by name...'**
  String get searchUsersByName;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @denied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get denied;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @noUsersFoundMatchingSearch.
  ///
  /// In en, this message translates to:
  /// **'No users found matching your search'**
  String get noUsersFoundMatchingSearch;

  /// No description provided for @errorLoadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile'**
  String get errorLoadingProfile;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @founds.
  ///
  /// In en, this message translates to:
  /// **'Founds'**
  String get founds;

  /// No description provided for @losts.
  ///
  /// In en, this message translates to:
  /// **'Losts'**
  String get losts;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @developers.
  ///
  /// In en, this message translates to:
  /// **'Developers'**
  String get developers;

  /// No description provided for @lqithaDescription.
  ///
  /// In en, this message translates to:
  /// **'Lqitha is a community-driven platform to help people find lost items and return found ones.'**
  String get lqithaDescription;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @emailAlerts.
  ///
  /// In en, this message translates to:
  /// **'Email Alerts'**
  String get emailAlerts;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;
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
