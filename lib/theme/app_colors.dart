/// Application color palette extracted from Figma design.
/// 
/// All colors used throughout the app are centralized here for consistency.
/// Colors are organized by category for easy maintenance and updates.
library;
import 'package:flutter/material.dart';

class AppColors {
  // ============================================================================
  // PRIMARY BRAND COLORS
  // ============================================================================
  /// Main brand color - Purple. Used for found items, primary buttons, and accents.
  static const Color primaryPurple = Color(0xFF9D4EDD);
  
  /// Secondary brand color - Orange. Used for lost items, secondary buttons, and accents.
  static const Color primaryOrange = Color(0xFFFF6B35);
  
  // ============================================================================
  // BACKGROUND COLORS
  // ============================================================================
  /// Starting color of the gradient background (lightest)
  static const Color backgroundStart = Color(0xFFFAF8FC);
  
  /// Middle color of the gradient background
  static const Color backgroundMid = Color(0xFFF5F2F9);
  
  /// Ending color of the gradient background (with slight orange tint)
  static const Color backgroundEnd = Color(0xFFFFF5F0);
  
  // ============================================================================
  // TEXT COLORS
  // ============================================================================
  /// Primary text color - Used for main headings and important text
  static const Color textPrimary = Color(0xFF1D2838);
  
  /// Secondary text color - Used for subtitles and secondary information
  static const Color textSecondary = Color(0xFF495565);
  
  /// Tertiary text color - Used for descriptions and body text
  static const Color textTertiary = Color(0xFF354152);
  
  /// Light text color - Used for hints, placeholders, and less important text
  static const Color textLight = Color(0xFF697282);
  
  // ============================================================================
  // CARD & BADGE COLORS
  // ============================================================================
  /// Semi-transparent white background for cards (60% opacity)
  static const Color cardBackground = Color(0x99FFFFFF);
  
  /// Background color for location badges on found items (purple tinted)
  static const Color locationBadgeBg = Color(0x7FEDE6FA);
  
  /// Background color for location badges on lost items (orange tinted)
  static const Color locationBadgeBgOrange = Color(0x7FFFF2EB);
  
  // ============================================================================
  // BORDER COLORS
  // ============================================================================
  /// Semi-transparent purple border (used for input fields, cards)
  static const Color borderPurple = Color(0x269D4EDD);
  
  /// More solid purple border (40% opacity - used for badges, buttons)
  static const Color borderPurpleSolid = Color(0x4C9D4EDD);
  
  /// Solid orange border (used for lost item cards and orange-themed elements)
  static const Color borderOrange = Color(0xFFFF6B35);
  
  // ============================================================================
  // SHADOW COLORS
  // ============================================================================
  /// Purple-tinted shadow for cards and elevated elements
  static const Color shadowPurple = Color(0x0F7B2CBF);
  
  /// Light purple shadow (used for subtle elevation)
  static const Color shadowPurpleLight = Color(0x199D4EDD);
  
  /// Very subtle purple shadow (used for badges and small elements)
  static const Color shadowPurpleSubtle = Color(0x149D4EDD);
  
  /// Standard black shadow with low opacity (used for buttons and popups)
  static const Color shadowBlack = Color(0x19000000);
  
  // ============================================================================
  // ACCENT COLORS
  // ============================================================================
  /// Purple accent color (used in bottom nav indicator, decorative elements)
  static const Color accentPurple = Color(0xFFB08CC9);
  
  // ============================================================================
  // NAVIGATION COLORS
  // ============================================================================
  /// Background color for bottom navigation bar (85% opacity white)
  static const Color bottomNavBackground = Color(0xD9FFFFFF);
  
  /// Border color for bottom navigation bar (semi-transparent purple)
  static const Color bottomNavBorder = Color(0x339D4EDD);
}

