import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../cubits/user_profile/user_profile_cubit.dart';
import '../../cubits/user_profile/user_profile_state.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProfileCubit>().state.user;
    _usernameCtrl = TextEditingController(text: user?.username ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
    _phoneCtrl = TextEditingController(text: user?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _saveProfile(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await context.read<UserProfileCubit>().updateProfile(
            username: _usernameCtrl.text,
            email: _emailCtrl.text,
            phoneNumber: _phoneCtrl.text,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileUpdatedSuccessfully),
            backgroundColor: AppColors.primaryPurple,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.primaryPurple),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.editProfile,
          style: AppTextStyles.pageTitle.copyWith(
            color: AppColors.primaryPurple,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundStart,
              AppColors.backgroundMid,
              AppColors.backgroundEnd,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 100,
            left: 16,
            right: 16,
            bottom: 32,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture Section with Gradient Border
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Gradient border background
                    Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryPurple,
                            AppColors.primaryOrange,
                          ],
                        ),
                      ),
                    ),
                    // Profile image
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: BlocBuilder<UserProfileCubit, UserProfileState>(
                        builder: (context, state) {
                          return ClipOval(
                            child: state.user?.photo != null
                                ? Image.network(
                                    state.user!.photo!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.person,
                                      color: AppColors.primaryPurple,
                                      size: 60,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    color: AppColors.primaryPurple,
                                    size: 60,
                                  ),
                          );
                        },
                      ),
                    ),
                    // Edit button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryOrange.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () async {
                            final picker = ImagePicker();
                            final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                            if (image != null) {
                              try {
                                if (mounted) {
                                  await context.read<UserProfileCubit>().updatePhoto(image.path);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.profilePictureUpdated),
                                      backgroundColor: AppColors.primaryPurple,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${l10n.error}: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          constraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Form Fields Container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Username Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.fullName,
                            style: AppTextStyles.cardUserName.copyWith(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _usernameCtrl,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: AppColors.primaryPurple,
                              ),
                              hintText: l10n.enterFullName,
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE8E6F0),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: AppColors.primaryPurple,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF9F8FF),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.nameCannotBeEmpty;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Email Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.emailAddress,
                            style: AppTextStyles.cardUserName.copyWith(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _emailCtrl,
                            enabled: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: AppColors.primaryPurple,
                              ),
                              hintText: l10n.enterYourEmail,
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE8E6F0),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: AppColors.primaryPurple,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF9F8FF),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Phone Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.phoneNumber,
                            style: AppTextStyles.cardUserName.copyWith(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.phone_outlined,
                                color: AppColors.primaryPurple,
                              ),
                              hintText: l10n.enterPhoneNumber,
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE8E6F0),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: AppColors.primaryPurple,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF9F8FF),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Save Button
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryPurple, Color(0xFF7B2CBF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _saveProfile(l10n),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.saveChanges,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
