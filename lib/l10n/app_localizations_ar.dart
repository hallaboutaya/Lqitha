// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get foundItems => 'الأشياء الموجودة';

  @override
  String get helpReuniteItems => 'ساعد في لم شمل الأشياء مع أصحابها';

  @override
  String get searchItemsTagsLocations =>
      'ابحث عن الأشياء، العلامات، المواقع...';

  @override
  String get lostItems => 'الأشياء المفقودة';

  @override
  String get helpFindLostBelongings =>
      'ساعد الناس في العثور على ممتلكاتهم المفقودة';

  @override
  String get searchLostItems => 'ابحث عن الأشياء المفقودة...';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get stayUpdatedOnItems => 'ابق على اطلاع على أشيائك';

  @override
  String get saysTheyFoundYourLostWallet => 'يقول أنه وجد محفظتك المفقودة!';

  @override
  String get unlockedYourContactInformation => 'فتح معلومات الاتصال الخاصة بك';

  @override
  String get saysTheyFoundYourPhone => 'يقول أنه وجد هاتفك!';

  @override
  String get getContact => 'الحصول على جهة الاتصال';

  @override
  String get yesIGotMyItemBack => 'نعم، استعدت الشيء الخاص بي';

  @override
  String thanksMarkedAsReunited(String userName) {
    return 'شكراً! لقد وضعنا علامة على $userName كأنه تم لم شمله.';
  }

  @override
  String get yourItem => 'الشيء الخاص بك';

  @override
  String get reportFoundItem => 'الإبلاغ عن شيء موجود';

  @override
  String get fillDetailsFoundItem => 'املأ التفاصيل حول الشيء الموجود';

  @override
  String get uploadPhotos => 'رفع الصور';

  @override
  String get clickToUploadImages => 'انقر لرفع الصور';

  @override
  String get pngJpgUpTo10MB => 'PNG، JPG حتى 10 ميجابايت';

  @override
  String get description => 'الوصف';

  @override
  String get describeFoundItemDetail => 'اوصف الشيء الموجود بالتفصيل...';

  @override
  String get location => 'الموقع';

  @override
  String get whereDidYouFindIt => 'أين وجدته؟';

  @override
  String get tagsCommaSeparated => 'العلامات (مفصولة بفواصل)';

  @override
  String get walletKeysPhone => 'محفظة، مفاتيح، هاتف...';

  @override
  String get cancel => 'إلغاء';

  @override
  String get submitPost => 'نشر';

  @override
  String get foundItemPostedSuccessfully => 'تم نشر الشيء الموجود بنجاح!';

  @override
  String get reportLostItem => 'الإبلاغ عن شيء مفقود';

  @override
  String get fillDetailsLostItem => 'املأ التفاصيل حول الشيء المفقود';

  @override
  String get describeLostItemDetail => 'اوصف الشيء المفقود بالتفصيل...';

  @override
  String get whereDidYouLoseIt => 'أين فقدته؟';

  @override
  String get lostItemPostedSuccessfully => 'تم نشر الشيء المفقود بنجاح!';

  @override
  String get lqitha => 'لقيثة';

  @override
  String get lqitou => 'لقيتو';

  @override
  String get rewardOffered => 'مكافأة مقدمة';
}
