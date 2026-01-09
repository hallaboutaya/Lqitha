import 'package:hopefully_last/l10n/app_localizations.dart';

/// Utility for formatting time differences in a human-readable way
/// Shows accurate minutes instead of rounding to hours like timeago library
class TimeFormatter {
  /// Format a DateTime to show how long ago it was
  /// Returns strings like "Just now", "5 minutes ago", "2 hours ago", etc.
  static String formatTimeAgo(DateTime dateTime, AppLocalizations l10n) {
    // Convert both to UTC to avoid timezone issues
    final now = DateTime.now().toUtc();
    final inputTime = dateTime.toUtc();
    final difference = now.difference(inputTime).abs();

    if (difference.inSeconds < 30) {
      return l10n.justNow;
    } else if (difference.inSeconds < 60) {
      return l10n.secondsAgo(difference.inSeconds);
    } else if (difference.inMinutes < 60) {
      return l10n.minuteAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return l10n.hourAgo(difference.inHours);
    } else if (difference.inDays < 7) {
      return l10n.dayAgo(difference.inDays);
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return l10n.weekAgo(weeks);
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return l10n.monthAgo(months);
    } else {
      final years = (difference.inDays / 365).floor();
      return l10n.yearAgo(years);
    }
  }

  /// Format a DateTime string (ISO 8601) to show how long ago it was
  static String formatTimeAgoFromString(String? isoTime, AppLocalizations l10n) {
    if (isoTime == null || isoTime.isEmpty) return l10n.unknownTime;
    try {
      // Ensure the string has a 'T' instead of space and 'Z' suffix to force UTC parsing
      String normalizedTime = isoTime.trim();
      
      // Replace space with 'T' if present (e.g. "2026-01-09 17:13:04" -> "2026-01-09T17:13:04")
      if (normalizedTime.contains(' ') && !normalizedTime.contains('T')) {
        normalizedTime = normalizedTime.replaceFirst(' ', 'T');
      }
      
      // Ensure it ends with 'Z' or has offset if no other timezone info
      if (!normalizedTime.endsWith('Z') && !normalizedTime.contains('+') && !normalizedTime.contains('-')) {
        normalizedTime += 'Z';
      }
      
      final date = DateTime.parse(normalizedTime).toUtc();
      return formatTimeAgo(date, l10n);
    } catch (e) {
      // Fallback to simpler parsing if complex logic fails
      try {
        final date = DateTime.parse(isoTime);
        return formatTimeAgo(date, l10n);
      } catch (_) {
        return l10n.unknownTime;
      }
    }
  }
}
