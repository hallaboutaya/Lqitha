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
/// - "LQitou" button (orange) that shows confirmation to mark item as found
/// 
/// Used in the Losts page to display list of lost items.
/// Styled with orange theme to match Figma design.
library;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../services/auth_service.dart';
import '../../services/service_locator.dart';
import '../../data/repositories/lost_repository.dart';
import '../../data/repositories/found_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/models/found_post.dart';
import '../../data/models/notification.dart';
import '../../cubits/lost/lost_cubit.dart';
import '../../cubits/lost/lost_state.dart';
import '../../cubits/found/found_cubit.dart';
import '../popups/popup_payment.dart';
import '../popups/popup_contact_unlocked.dart';

class LostItemCard extends StatelessWidget {
  /// ID of the lost post
  final dynamic postId;
  
  /// ID of the user who posted this lost item
  final dynamic postOwnerId;
  
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
  
  /// Photo URL for the post
  final String? photoUrl;

  const LostItemCard({
    super.key,
    required this.postId,
    required this.postOwnerId,
    required this.userName,
    required this.timeAgo,
    required this.description,
    required this.location,
    required this.tags,
    required this.imageUrl,
    this.borderColor = AppColors.primaryOrange,
    this.hasReward = false,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = AuthService().currentUserId;

    return BlocBuilder<LostCubit, LostState>(
      builder: (context, state) {
        final isUnlocked = state is LostLoaded && (state.isUnlocked(postId.toString()) || postOwnerId == currentUserId);

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
                        child: Text(
                          AppLocalizations.of(context)!.rewardOffered,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                          ),
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
                // LQitou Button
                InkWell(
                  onTap: () {
                    final lostCubit = context.read<LostCubit>();
                    
                    if (isUnlocked) {
                      // Already unlocked, show contact info directly
                      // Reuse ContactUnlockedPopup since it just shows user info
                      showDialog(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: context.read<LostCubit>(),
                          child: ContactUnlockedPopup(
                            userName: userName,
                            postId: postId,
                            postType: 'lost',
                          ),
                        ),
                      );
                      return;
                    }

                    // For lost posts, the "LQitou" flow usually means the finder is reporting it.
                    // But if it's already "found" by someone else, we might want to "Pay" to see contact.
                    // Actually, the user's rule says: "When user taps 'LQITHA / LQITOU': Simulate payment success"
                    
                    showDialog(
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                        value: lostCubit,
                        child: PaymentPopup(
                          userName: userName,
                          itemTitle: description,
                          postId: postId,
                          postType: 'lost',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: ShapeDecoration(
                      color: isUnlocked ? Colors.green : AppColors.primaryOrange,
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
                        isUnlocked ? 'View Contact' : AppLocalizations.of(context)!.lqitou,
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
      },
    );
  }
  
  /// Show confirmation dialog when user clicks "Lqitou"
  void _showFoundItemConfirmation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          l10n.foundThisItem,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textTertiary,
          ),
        ),
        content: Text(
          l10n.areYouSureFoundItem,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _handleFoundItem(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              l10n.yesIFoundIt,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Handle when user confirms they found the item
  Future<void> _handleFoundItem(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final currentUserId = AuthService().currentUserId ?? 1;
      
      // Get repositories
      final lostRepository = getIt<LostRepository>();
      final foundRepository = getIt<FoundRepository>();
      final notificationRepository = getIt<NotificationRepository>();
      
      // 1. Get the lost post data
      final lostPost = await lostRepository.getPostById(postId);
      if (lostPost == null) {
        throw Exception('Lost post not found');
      }
      
      // 2. Create a found post with the same data (approved status)
      final foundPost = FoundPost(
        photo: lostPost.photo,
        description: lostPost.description,
        status: 'approved', // Automatically approve since someone found it
        location: lostPost.location,
        category: lostPost.category,
        createdAt: DateTime.now().toIso8601String(),
        userId: currentUserId, // The person who found it
      );
      await foundRepository.insertPost(foundPost);
      
      // 4. Delete the lost post
      await lostRepository.deletePost(postId);
      
      // 5. Create notification for the original owner
      print('🔔 Creating notification for user ID: $postOwnerId');
      print('🔔 Notification message: ${l10n.goodNewsSomeoneFound(description)}');
      
      final notification = NotificationModel(
        title: l10n.someoneFoundYourItem,
        message: l10n.goodNewsSomeoneFound(description),
        relatedPostId: postId,
        type: 'item_found',
        isRead: false,
        createdAt: DateTime.now().toIso8601String(),
        userId: postOwnerId,
      );
      
      final notificationId = await notificationRepository.insertNotification(notification);
      print('🔔 Notification created with ID: $notificationId for user: $postOwnerId');
      
      // 6. Refresh both Lost and Found cubits to update UI
      if (context.mounted) {
        try {
          context.read<LostCubit>().refresh();
        } catch (e) {
          print('LostCubit not available in context: $e');
        }
        
        // Try to refresh FoundCubit if available (might not be in context on LostsPage)
        try {
          context.read<FoundCubit>().refresh();
        } catch (e) {
          print('FoundCubit not available in context: $e');
          // That's okay - user can manually refresh Found page
        }
      }
      
      // 7. Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.ownerNotifiedItemMoved),
            backgroundColor: AppColors.primaryOrange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error handling found item: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
