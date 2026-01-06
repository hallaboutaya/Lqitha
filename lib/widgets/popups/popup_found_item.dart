/// Popup dialog for reporting a new found item.
/// 
/// Displayed when user taps the floating action button (+) on Founds page.
/// Contains form fields for:
/// - Upload photos (image picker - TODO: implement)
/// - Description of the found item
/// - Location where item was found
/// - Tags/categories for the item
/// 
/// Has "Cancel" and "Submit Post" buttons.
/// Styled with purple theme to match found items.
library;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import 'dart:io';
import '../../theme/app_colors.dart';
import '../../cubits/found/found_cubit.dart';
import '../../data/models/found_post.dart';
import '../../services/auth_service.dart';
import '../../core/utils/image_helper.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/logging/app_logger.dart';

class FoundItemPopup extends StatefulWidget {
  const FoundItemPopup({super.key});

  @override
  State<FoundItemPopup> createState() => _FoundItemPopupState();
}

class _FoundItemPopupState extends State<FoundItemPopup> {
  /// Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  /// Controller for description text field
  final _descriptionController = TextEditingController();
  
  /// Controller for location text field
  final _locationController = TextEditingController();
  
  /// Controller for tags text field
  final _tagsController = TextEditingController();
  
  /// Selected image path
  String? _selectedImagePath;

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
              width: 3.82,
              color: AppColors.primaryPurple,
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
                                  color: AppColors.primaryPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                AppLocalizations.of(context)!.reportFoundItem,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.primaryPurple,
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
                        AppLocalizations.of(context)!.fillDetailsFoundItem,
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
                        onTap: () async {
                          try {
                            final imagePath = await ImageHelper.pickImage();
                            if (imagePath != null && mounted) {
                              setState(() {
                                _selectedImagePath = imagePath;
                              });
                            }
                          } on ImageException catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            AppLogger.e('Error picking image', e);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to pick image. Please try again.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 122.53,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF9FAFB),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1.27,
                                color: AppColors.primaryPurple,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _selectedImagePath != null
                              ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.file(
                                        File(_selectedImagePath!),
                                        width: double.infinity,
                                        height: 122.53,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: IconButton(
                                        icon: const Icon(Icons.close, color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            _selectedImagePath = null;
                                          });
                                        },
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
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
                        height: 64,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: ShapeDecoration(
                          color: const Color(0x4CE5E5E5),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1.27,
                              color: Color(0xFFD0D5DB),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.describeFoundItemDetail,
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
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: ShapeDecoration(
                          color: const Color(0x4CE5E5E5),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1.27,
                              color: Color(0xFFD0D5DB),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: TextField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.whereDidYouFindIt,
                            hintStyle: const TextStyle(
                              color: AppColors.textLight,
                              fontSize: 14,
                              fontFamily: 'Arimo',
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            prefixIcon: const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppColors.textLight,
                            ),
                          ),
                          style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 14,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                          ),
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
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: ShapeDecoration(
                          color: const Color(0x4CE5E5E5),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1.27,
                              color: Color(0xFFD0D5DB),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
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
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            prefixIcon: const Icon(
                              Icons.tag_outlined,
                              size: 16,
                              color: AppColors.textLight,
                            ),
                          ),
                          style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 14,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                          ),
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
                                  final foundCubit = context.read<FoundCubit>();
                                  
                                  // Create FoundPost from form data
                                  final post = FoundPost(
                                    photo: _selectedImagePath,
                                    description: _descriptionController.text.trim(),
                                    location: _locationController.text.trim(),
                                    category: _tagsController.text.trim(),
                                    createdAt: DateTime.now().toIso8601String(),
                                    userId: AuthService().currentUserId ?? 1,
                                    status: 'pending', // New posts start as pending
                                  );
                                  
                                  // Save to database via cubit
                                  await foundCubit.addPost(post);
                                  
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(AppLocalizations.of(context)!.foundItemPostedSuccessfully),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Container(
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
