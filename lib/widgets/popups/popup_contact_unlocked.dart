/// Success popup displayed after payment is completed.
/// 
/// Shows:
/// - Success header with celebration emoji
/// - Success icon with decorative background
/// - Contact information card with user name and phone number
/// - Info box with instructions for contacting the user
/// - "Got it!" button to dismiss
/// - Footer message
/// 
/// This popup appears automatically after user completes payment
/// in the PaymentPopup dialog.
library;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../cubits/found/found_cubit.dart';
import '../../services/service_locator.dart';
import '../../data/repositories/found_repository.dart';
import '../../data/repositories/lost_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../cubits/lost/lost_cubit.dart';

class ContactUnlockedPopup extends StatelessWidget {
  /// Name of the user whose contact was unlocked
  final String userName;
  
  /// ID of the found post to delete when user clicks "Got it"
  final dynamic postId;
  
  /// Type of post ('found' or 'lost')
  final String postType;

  ContactUnlockedPopup({
    super.key,
    required this.userName,
    this.postId,
    this.postType = 'found',
  });

  void _deletePost() async {
    try {
      final foundRepository = getIt<FoundRepository>();
      await foundRepository.deletePost(postId);
      print('🗑️ ContactUnlockedPopup: Auto-deleted found post $postId');
    } catch (e) {
      print('❌ ContactUnlockedPopup: Failed to auto-delete post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: 360.59,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white.withOpacity(0.95),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1.27,
              color: Color(0xFFE5E5E5),
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 10,
              offset: Offset(0, 8),
              spreadRadius: -6,
            ),
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 25,
              offset: Offset(0, 20),
              spreadRadius: -5,
            )
          ],
        ),
        child: Stack(
          children: [
            // Close Button
            Positioned(
              right: 13,
              top: 13,
              child: IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
                color: const Color(0xFF2D2433).withOpacity(0.7),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(17.27),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Contact Information Unlocked! 🎉',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryPurple,
                              fontSize: 18,
                              fontFamily: 'Arimo',
                              fontWeight: FontWeight.w700,
                              height: 1.56,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'You can now contact $userName to collect your item',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                fontFamily: 'Arimo',
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Success Icon
                    Center(
                      child: _buildSuccessIcon(),
                    ),
                    const SizedBox(height: 32),
                    // Contact Information Card - Fetch phone number from database
                    FutureBuilder<String?>(
                      future: _fetchPhoneNumber(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            width: double.infinity,
                            height: 150,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                            ),
                          );
                        }
                        
                        if (snapshot.hasError) {
                          print('❌ ContactUnlockedPopup: Snapshot error: ${snapshot.error}');
                        }

                        final phoneNumber = snapshot.data ?? 'Phone number not available';
                        return _buildContactCard(phoneNumber);
                      },
                    ),
                    const SizedBox(height: 32),
                    // Info Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(13.26),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF9FAFB),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1.27,
                            color: Color(0xFFE5E7EB),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Please contact $userName to arrange pickup. Be respectful and confirm the item details before meeting.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.tagText.copyWith(
                          color: AppColors.textTertiary,
                          height: 1.62,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Got it Button
                    InkWell(
                      onTap: () async {
                        // Delete post when user clicks Got it
                        if (postId != null && postType == 'found') {
                          _deletePost();
                        }
                        
                        // We still try to refresh cubit if possible
                        if (context.mounted) {
                          try {
                            if (postType == 'found') {
                              final cubit = context.read<FoundCubit>();
                              await cubit.refresh();
                            } else {
                              final cubit = context.read<LostCubit>();
                              await cubit.refresh();
                            }
                          } catch (e) {
                            print('Cubit not available in context: $e');
                          }
                        }
                        
                        // Close the popup
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 44,
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
                        child: const Center(
                          child: Text(
                            'Got it!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Arimo',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const ShapeDecoration(
                          color: AppColors.primaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(999)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Good luck collecting your item!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 12,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const ShapeDecoration(
                          color: AppColors.primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(999)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildSuccessIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background decorative shapes
        Positioned(
          child: Transform.rotate(
            angle: 0.05,
            child: Opacity(
              opacity: 0.08,
              child: Container(
                width: 105.51,
                height: 105.51,
                decoration: ShapeDecoration(
                  color: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          child: Transform.rotate(
            angle: -0.12,
            child: Opacity(
              opacity: 0.08,
              child: Container(
                width: 87.95,
                height: 87.95,
                decoration: ShapeDecoration(
                  color: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Main icon container
        Container(
          width: 72.02,
          height: 72.02,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1.27,
                color: Color(0xFFE5E5E5),
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            shadows: const [
              BoxShadow(
                color: AppColors.shadowBlack,
                blurRadius: 6,
                offset: Offset(0, 4),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: AppColors.shadowBlack,
                blurRadius: 15,
                offset: Offset(0, 10),
                spreadRadius: -3,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const ShapeDecoration(
                        color: AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(999)),
                        ),
                      ),
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.check_circle_outline,
                      color: AppColors.primaryPurple,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Fetch phone number from database using postId
  Future<String?> _fetchPhoneNumber() async {
    if (postId == null) {
      print('⚠️ ContactUnlockedPopup: postId is null');
      return null;
    }
    
    try {
      print('🔍 ContactUnlockedPopup: Fetching contact for $postType post $postId');
      
      if (postType == 'found') {
        final foundRepository = getIt<FoundRepository>();
        final post = await foundRepository.getPostById(postId!);
        
        if (post == null) {
          print('⚠️ ContactUnlockedPopup: Found post not found for ID $postId');
          return null;
        }
        
        if (post.userId == null) {
          print('⚠️ ContactUnlockedPopup: post.userId is null for post $postId');
          return null;
        }
        
        final userRepository = getIt<UserRepository>();
        final user = await userRepository.getUserById(post.userId!);
        
        if (user == null) {
          print('⚠️ ContactUnlockedPopup: User not found for ID ${post.userId}');
          return null;
        }
        
        print('✅ ContactUnlockedPopup: Found phone number: ${user.phoneNumber}');
        return user.phoneNumber;
      } else {
        final lostRepository = getIt<LostRepository>();
        final post = await lostRepository.getPostById(postId!);
        
        if (post == null) {
          print('⚠️ ContactUnlockedPopup: Lost post not found for ID $postId');
          return null;
        }
        
        if (post.userId == null) {
          print('⚠️ ContactUnlockedPopup: post.userId is null for post $postId');
          return null;
        }
        
        final userRepository = getIt<UserRepository>();
        final user = await userRepository.getUserById(post.userId!);
        
        if (user == null) {
          print('⚠️ ContactUnlockedPopup: User not found for ID ${post.userId}');
          return null;
        }
        
        print('✅ ContactUnlockedPopup: Found phone number: ${user.phoneNumber}');
        return user.phoneNumber;
      }
    } catch (e, stackTrace) {
      print('❌ ContactUnlockedPopup: Error fetching phone number: $e');
      print('📚 ContactUnlockedPopup: Stack trace: $stackTrace');
      return null;
    }
  }

  Widget _buildContactCard(String phoneNumber) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17.27),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1.27,
            color: Color(0xFFE5E5E5),
          ),
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
      child: Column(
        children: [
          // Name Field
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11.99),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1.27,
                  color: Color(0xFFE5E7EB),
                ),
                borderRadius: BorderRadius.circular(16.4),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                        ),
                      ),
                      Text(
                        userName,
                        style: AppTextStyles.cardUserName,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Phone Field
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11.99),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1.27,
                  color: Color(0xFFE5E7EB),
                ),
                borderRadius: BorderRadius.circular(16.4),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(
                    Icons.phone_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Phone Number',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                        ),
                      ),
                      Text(
                        phoneNumber,
                        style: AppTextStyles.cardUserName,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // TODO: Implement call functionality
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF3F4F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Icon(
                      Icons.phone,
                      color: AppColors.primaryPurple,
                      size: 16,
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

