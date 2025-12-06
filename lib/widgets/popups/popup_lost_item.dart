/// Popup dialog for reporting a new lost item.
/// 
/// Displayed when user taps the floating action button (+) on Losts page.
/// Contains form fields for:
/// - Upload photos (image picker - TODO: implement)
/// - Description of the lost item
/// - Location where item was lost
/// - Tags/categories for the item
/// 
/// Has "Cancel" and "Submit Post" buttons.
/// Styled with orange theme to match lost items.
library;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../cubits/lost/lost_cubit.dart';
import '../../data/models/lost_post.dart';

class LostItemPopup extends StatefulWidget {
  const LostItemPopup({super.key});

  @override
  State<LostItemPopup> createState() => _LostItemPopupState();
}

class _LostItemPopupState extends State<LostItemPopup> {
  /// Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  /// Controller for description text field
  final _descriptionController = TextEditingController();
  
  /// Controller for location text field
  final _locationController = TextEditingController();
  
  /// Controller for tags text field
  final _tagsController = TextEditingController();
  // List<String> _uploadedImages = []; // TODO: Use when implementing image picker

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: 360.59,
        height: 624.87,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white.withOpacity(0.95),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 3.52,
              color: AppColors.primaryOrange,
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
            // Content
            Padding(
              padding: const EdgeInsets.all(19.82),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 40,
                                decoration: ShapeDecoration(
                                  color: AppColors.primaryOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                AppLocalizations.of(context)!.reportLostItem,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.primaryOrange,
                                  fontSize: 18,
                                  fontFamily: 'Arimo',
                                  fontWeight: FontWeight.w700,
                                  height: 1.56,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => Navigator.pop(context),
                            color: AppColors.textTertiary,
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFFF3F4F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.fillDetailsLostItem,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Upload Photos Section
                      Text(
                        AppLocalizations.of(context)!.uploadPhotos,
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          // TODO: Implement image picker
                        },
                        child: Container(
                          width: double.infinity,
                          height: 122.53,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF9FAFB),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1.27,
                                color: AppColors.primaryOrange,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 28,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)!.clickToUploadImages,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.textTertiary,
                                  fontSize: 12,
                                  fontFamily: 'Arimo',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppLocalizations.of(context)!.pngJpgUpTo10MB,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 12,
                                  fontFamily: 'Arimo',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Description Section
                      Text(
                        AppLocalizations.of(context)!.description,
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 63.98,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1.17,
                              color: Color(0xFFD0D5DB),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.describeLostItemDetail,
                                hintStyle: const TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 14,
                                  fontFamily: 'Arimo',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                ),
                                border: InputBorder.none,
                              ),
                          style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 14,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                            height: 1.43,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Location Section
                      Text(
                        AppLocalizations.of(context)!.location,
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 43.99,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1.17,
                              color: Color(0xFFD0D5DB),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _locationController,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.whereDidYouLoseIt,
                                  hintStyle: const TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 14,
                                    fontFamily: 'Arimo',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: const TextStyle(
                                  color: AppColors.textTertiary,
                                  fontSize: 14,
                                  fontFamily: 'Arimo',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tags Section
                      Text(
                        AppLocalizations.of(context)!.tagsCommaSeparated,
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 43.99,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1.17,
                              color: Color(0xFFD0D5DB),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.tag_outlined,
                              size: 16,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _tagsController,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.walletKeysPhone,
                                  hintStyle: const TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 14,
                                    fontFamily: 'Arimo',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: const TextStyle(
                                  color: AppColors.textTertiary,
                                  fontSize: 14,
                                  fontFamily: 'Arimo',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 44,
                                decoration: ShapeDecoration(
                                  color: const Color(0x4CE5E5E5),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1.27,
                                      color: Color(0xFFE5E5E5),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                    style: const TextStyle(
                                      color: AppColors.textTertiary,
                                      fontSize: 14,
                                      fontFamily: 'Arimo',
                                      fontWeight: FontWeight.w400,
                                      height: 1.43,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Get cubit from context
                                  final lostCubit = context.read<LostCubit>();
                                  
                                  // Create LostPost from form data
                                  final post = LostPost(
                                    photo: null, // TODO: Add image picker support
                                    description: _descriptionController.text.trim(),
                                    location: _locationController.text.trim(),
                                    category: _tagsController.text.trim(),
                                    createdAt: DateTime.now().toIso8601String(),
                                    userId: 1, // TODO: Replace with actual logged-in user ID
                                    status: 'pending', // New posts start as pending
                                  );
                                  
                                  // Save to database via cubit
                                  await lostCubit.addPost(post);
                                  
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(AppLocalizations.of(context)!.lostItemPostedSuccessfully),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Container(
                                height: 44,
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
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.submitPost,
                                    style: const TextStyle(
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

