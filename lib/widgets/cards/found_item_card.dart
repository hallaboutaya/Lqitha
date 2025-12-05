/// Card widget displaying a found item with all its details.
/// 
/// Shows:
/// - User avatar and name who found the item
/// - Time ago (e.g., "2 hours ago")
/// - Item image with gradient overlay
/// - Item description
/// - Location badge with map icon
/// - Category tags (e.g., "Wallet", "Keys")
/// - "LQitha" button that opens payment popup to unlock contact info
/// 
/// Used in the Founds page to display list of found items.
/// Styled with purple theme to match Figma design.
library;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../popups/popup_payment.dart';

class FoundItemCard extends StatelessWidget {
  /// Name of the user who found the item
  final String userName;
  
  /// Relative time string (e.g., "2 hours ago", "Yesterday")
  final String timeAgo;
  
  /// Description of the found item
  final String description;
  
  /// Location where the item was found
  final String location;
  
  /// List of category tags (e.g., ["Wallet", "Cards"])
  final List<String> tags;
  
  /// URL of the item image
  final String imageUrl;
  
  /// Border color of the card (defaults to purple for found items)
  final Color borderColor;

  const FoundItemCard({
    super.key,
    required this.userName,
    required this.timeAgo,
    required this.description,
    required this.location,
    required this.tags,
    required this.imageUrl,
    this.borderColor = AppColors.primaryPurple,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.17,
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: const [
          BoxShadow(
            color: AppColors.shadowPurple,
            blurRadius: 24,
            offset: Offset(0, 8),
            spreadRadius: 0,
          )
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info Section
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 44,
                      height: 44,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0xFF2D2433),
                            blurRadius: 0,
                            offset: Offset(0, 0),
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // User Name and Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: AppTextStyles.cardUserName,
                          ),
                          Text(
                            timeAgo,
                            style: AppTextStyles.cardTimeAgo,
                          ),
                        ],
                      ),
                    ),
                    // Status indicator
                    Container(
                      width: 32,
                      height: 32,
                      decoration: ShapeDecoration(
                        color: borderColor == AppColors.primaryPurple
                            ? AppColors.primaryOrange.withOpacity(0.15)
                            : AppColors.primaryPurple.withOpacity(0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Item Image
                Container(
                  width: double.infinity,
                  height: 256,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 256,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image, size: 64),
                            ),
                          );
                        },
                      ),
                      // Gradient overlay at bottom
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Description
                Text(
                  description,
                  style: AppTextStyles.cardDescription,
                ),
                const SizedBox(height: 12),
                // Location Badge
                Container(
                  padding: const EdgeInsets.only(left: 12, top: 4, right: 12, bottom: 4),
                  decoration: ShapeDecoration(
                    color: AppColors.locationBadgeBg,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1.17,
                        color: AppColors.borderPurpleSolid,
                      ),
                      borderRadius: BorderRadius.circular(16.4),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: AppColors.shadowPurpleLight,
                        blurRadius: 16,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        location,
                        style: AppTextStyles.cardLocation,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((tag) {
                    final isFirstTag = tags.indexOf(tag) == 0;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1.17,
                            color: isFirstTag
                                ? AppColors.primaryPurple
                                : AppColors.primaryOrange,
                          ),
                          borderRadius: BorderRadius.circular(16.4),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: AppColors.shadowPurpleSubtle,
                            blurRadius: 16,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Text(
                        tag,
                        style: AppTextStyles.tagText,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                // LQitha Button
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => PaymentPopup(
                        userName: userName,
                        itemTitle: description,
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: ShapeDecoration(
                      color: AppColors.primaryPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: AppColors.shadowBlack,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          spreadRadius: -2,
                        ),
                        BoxShadow(
                          color: AppColors.shadowBlack,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                          spreadRadius: -1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.lqitha,
                        style: AppTextStyles.buttonText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}