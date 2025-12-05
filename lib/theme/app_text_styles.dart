/// Text style definitions extracted from Figma design.
/// 
/// All text styles used throughout the app are centralized here for consistency.
/// This ensures consistent typography and makes it easy to update styles globally.
library;
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // ============================================================================
  // PAGE HEADER STYLES
  // ============================================================================
  /// Main page title style (e.g., "Found Items", "Lost Items")
  /// Large, purple text used at the top of pages
  static const TextStyle pageTitle = TextStyle(
    color: AppColors.primaryPurple,
    fontSize: 30,
    fontFamily: 'Arimo',
    fontWeight: FontWeight.w400,
    height: 1.20,
  );
  
  /// Subtitle style used below page titles
  /// Provides additional context or description
  static const TextStyle subtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 16,
    fontFamily: 'Arimo',
    fontWeight: FontWeight.w400,
    height: 1.50,
  );
  
  // ============================================================================
  // CARD TEXT STYLES
  // ============================================================================
  /// Username text style on item cards
  /// Used to display the name of the person who posted the item
  static const TextStyle cardUserName = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontFamily: 'Arimo',
    fontWeight: FontWeight.w400,
    height: 1.50,
  );
  
  /// Time ago text style (e.g., "2 hours ago", "Yesterday")
  /// Shows when the item was posted
  static const TextStyle cardTimeAgo = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontFamily: 'Arimo',
    fontWeight: FontWeight.w400,
    height: 1.43,
  );
  
  /// Item description text style
  /// Main text body describing the found/lost item
  static const TextStyle cardDescription = TextStyle(
    color: AppColors.textTertiary,
    fontSize: 16,
    fontFamily: 'Arimo',
    fontWeight: FontWeight.w400,
    height: 1.62,
  );
  
  /// Location badge text style
  /// Shows where the item was found/lost
  static const TextStyle cardLocation = TextStyle(
    color: AppColors.textTertiary,
    fontSize: 14,
    fontFamily: 'Arimo',
    fontWeight: FontWeight.w400,
    height: 1.43,
  );
  
  // ============================================================================
  // TAG STYLES
  // ============================================================================
  /// Tag/chip text style (e.g., "Wallet", "Keys", "Electronics")
  /// Used for category tags on item cards
  static const TextStyle tagText = TextStyle(
    color: AppColors.textTertiary,
    fontSize: 12,
    fontFamily: 'Arimo',
    fontWeight: FontWeight.w400,
    height: 1.33,
  );
  
  // ============================================================================
  // BUTTON STYLES
  // ============================================================================
  /// Button text style (e.g., "LQitha", "LQitou", "Submit Post")
  /// White text on colored button backgrounds
  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontFamily: 'Arimo',
    fontWeight: FontWeight.w400,
    height: 1.43,
  );
  
  // ============================================================================
  // INPUT FIELD STYLES
  // ============================================================================
  /// Search bar hint text style
  /// Used for placeholder text in search inputs
  static const TextStyle searchHint = TextStyle(
    color: AppColors.textLight,
    fontSize: 16,
    fontFamily: 'Arimo',
    fontWeight: FontWeight.w400,
  );
  
  // ============================================================================
  // NAVIGATION STYLES
  // ============================================================================
  /// Bottom navigation active tab text style
  /// White text for the currently selected tab
  static const TextStyle bottomNavActive = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontFamily: 'Arimo',
    fontWeight: FontWeight.w400,
    height: 1.33,
  );
  
  /// Bottom navigation inactive tab text style
  /// Gray text for unselected tabs
  static const TextStyle bottomNavInactive = TextStyle(
    color: AppColors.textLight,
    fontSize: 12,
    fontFamily: 'Arimo',
    fontWeight: FontWeight.w400,
    height: 1.33,
  );
}

