import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'admin_panel': 'Admin Panel',
      'logout': 'Logout',
      'total_posts': 'Total Posts',
      'pending_review': 'Pending Review',
      'approved_today': 'Approved Today',
      'total_income': 'Total Income',
      'search_posts': 'Search posts...',
      'filters': 'Filters',
      'pending': 'Pending',
      'approved': 'Approved',
      'rejected': 'Rejected',
      'approve': 'Approve',
      'reject': 'Reject',
      'lost': 'Lost',
      'found': 'Found',
    },
    'fr': {
      'admin_panel': 'Panneau Admin',
      'logout': 'Déconnexion',
      'total_posts': 'Total des Publications',
      'pending_review': 'En Attente',
      'approved_today': 'Approuvé Aujourd\'hui',
      'total_income': 'Revenu Total',
      'search_posts': 'Rechercher des publications...',
      'filters': 'Filtres',
      'pending': 'En Attente',
      'approved': 'Approuvé',
      'rejected': 'Rejeté',
      'approve': 'Approuver',
      'reject': 'Rejeter',
      'lost': 'Perdu',
      'found': 'Trouvé',
    },
    'ar': {
      'admin_panel': 'لوحة الإدارة',
      'logout': 'تسجيل الخروج',
      'total_posts': 'إجمالي المنشورات',
      'pending_review': 'قيد المراجعة',
      'approved_today': 'تمت الموافقة اليوم',
      'total_income': 'إجمالي الدخل',
      'search_posts': 'ابحث عن المنشورات...',
      'filters': 'المرشحات',
      'pending': 'قيد الانتظار',
      'approved': 'موافق عليه',
      'rejected': 'مرفوض',
      'approve': 'موافقة',
      'reject': 'رفض',
      'lost': 'مفقود',
      'found': 'موجود',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
