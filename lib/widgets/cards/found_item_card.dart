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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../cubits/found/found_cubit.dart';
import '../../cubits/found/found_state.dart';
import '../../services/auth_service.dart';
import '../popups/popup_payment.dart';
import '../popups/popup_contact_unlocked.dart';

class FoundItemCard extends StatelessWidget {
  /// ID of the found post
  final dynamic postId;
  
  /// ID of the user who found the item
  final dynamic postOwnerId;
  
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
    required this.postId,
    required this.postOwnerId,
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
    final currentUserId = AuthService().currentUserId;
    
    return BlocBuilder<FoundCubit, FoundState>(
      builder: (context, state) {
        final isPostOwner = postOwnerId == currentUserId;
        final isUnlocked = state is FoundLoaded && (state.isUnlocked(postId.toString()) || isPostOwner);

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
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.person),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // User Name and Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isUnlocked ? userName : 'Lqitha User',
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: ShapeDecoration(
                        color: isUnlocked 
                          ? Colors.green.withOpacity(0.15)
                          : borderColor.withOpacity(0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isUnlocked ? Colors.green : borderColor,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isUnlocked ? Icons.lock_open : Icons.lock_outline,
                            size: 14,
                            color: isUnlocked ? Colors.green : borderColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isUnlocked ? 'Unlocked' : 'Locked',
                            style: TextStyle(
                              color: isUnlocked ? Colors.green : borderColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: 256,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: double.infinity,
                            height: 256,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 64),
                          ),
                        ),
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
                // LQitha Button - Only show if not yours
                if (!isPostOwner) ...[
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      final foundCubit = context.read<FoundCubit>();
                      
                      if (isUnlocked) {
                        // Already unlocked, show contact info directly
                        showDialog(
                          context: context,
                          builder: (dialogContext) => BlocProvider.value(
                            value: foundCubit,
                            child: ContactUnlockedPopup(
                              userName: userName,
                              postId: postId,
                            ),
                          ),
                        );
                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: foundCubit,
                          child: PaymentPopup(
                            userName: userName,
                            itemTitle: description,
                            postId: postId,
                            postType: 'found',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: ShapeDecoration(
                        color: isUnlocked ? Colors.green : AppColors.primaryPurple,
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
                          isUnlocked ? 'View Contact' : AppLocalizations.of(context)!.lqitha,
                          style: AppTextStyles.buttonText,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 12),
                  // Show "Your Post" placeholder or manage button
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: ShapeDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Your Post',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}
