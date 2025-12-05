/// Card widget displaying a lost item with all its details.
/// 
/// Shows:
/// - User avatar and name who lost the item
/// - Time ago (e.g., "Yesterday", "2 days ago")
/// - Optional "Reward offered" badge if hasReward is true
/// - Item image with gradient overlay
/// - Item description
/// - Location badge with map icon (orange-themed)
/// - Category tags (e.g., "Wallet", "Phone")
/// - "LQitou" button (orange) that opens payment popup to unlock contact info
/// 
/// Used in the Losts page to display list of lost items.
/// Styled with orange theme to match Figma design.
library;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../popups/popup_payment.dart';

class LostItemCard extends StatelessWidget {
  /// Name of the user who lost the item
  final String userName;
  
  /// Relative time string (e.g., "Yesterday", "2 days ago")
  final String timeAgo;
  
  /// Description of the lost item
  final String description;
  
  /// Location where the item was lost
  final String location;
  
  /// List of category tags (e.g., ["Wallet", "ID"])
  final List<String> tags;
  
  /// URL of the item image
  final String imageUrl;
  
  /// Border color of the card (defaults to orange for lost items)
  final Color borderColor;
  
  /// Whether a reward is offered for finding this item
  final bool hasReward;

  const LostItemCard({
    super.key,
    required this.userName,
    required this.timeAgo,
    required this.description,
    required this.location,
    required this.tags,
    required this.imageUrl,
    this.borderColor = AppColors.primaryOrange,
    this.hasReward = false,
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
            width: 1.27,
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
                    // Reward Badge or Status indicator
                    if (hasReward)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: ShapeDecoration(
                          color: AppColors.primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.4),
                          ),
                        ),
                        child: const Text(
                          'Reward offered',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 32,
                        height: 32,
                        decoration: ShapeDecoration(
                          color: borderColor == AppColors.primaryOrange
                              ? AppColors.primaryPurple.withOpacity(0.15)
                              : AppColors.primaryOrange.withOpacity(0.15),
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
                // Location Badge (Orange theme)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: ShapeDecoration(
                    color: AppColors.locationBadgeBgOrange,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1.27,
                        color: Color(0x4CFF6B35),
                      ),
                      borderRadius: BorderRadius.circular(16.4),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x19FF6B35),
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
                      Flexible(
                        child: Text(
                          location,
                          style: AppTextStyles.cardLocation,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Tags (First tag orange, others purple)
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
                            width: 1.27,
                            color: isFirstTag
                                ? AppColors.primaryOrange
                                : AppColors.primaryPurple,
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
                // LQitou Button (Orange)
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
                      color: AppColors.primaryOrange,
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
                    child: const Center(
                      child: Text(
                        'LQitou',
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

