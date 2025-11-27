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
import '../../theme/app_colors.dart';

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
                              const Text(
                                'Report Found Item',
                                textAlign: TextAlign.center,
                                style: TextStyle(
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
                      const Text(
                        'Fill in the details about the found item',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Upload Photos Section
                      const Text(
                        'Upload Photos',
                        style: TextStyle(
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
                                color: AppColors.primaryPurple,
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
                              const Text(
                                'Click to upload images',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textTertiary,
                                  fontSize: 12,
                                  fontFamily: 'Arimo',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'PNG, JPG up to 10MB',
                                textAlign: TextAlign.center,
                                style: TextStyle(
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
                      const Text(
                        'Description',
                        style: TextStyle(
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
                          decoration: const InputDecoration(
                            hintText: 'Describe the found item in detail...',
                            hintStyle: TextStyle(
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
                      const Text(
                        'Location',
                        style: TextStyle(
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
                          decoration: const InputDecoration(
                            hintText: 'Where did you find it?',
                            hintStyle: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 14,
                              fontFamily: 'Arimo',
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            prefixIcon: Icon(
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
                      const Text(
                        'Tags (comma separated)',
                        style: TextStyle(
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
                          decoration: const InputDecoration(
                            hintText: 'wallet, keys, phone...',
                            hintStyle: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 14,
                              fontFamily: 'Arimo',
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            prefixIcon: Icon(
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
                                child: const Center(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
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
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  // TODO: Handle submission with backend
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Found item posted successfully!'),
                                    ),
                                  );
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
                                child: const Center(
                                  child: Text(
                                    'Submit Post',
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
