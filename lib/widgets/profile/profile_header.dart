import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../cubits/user_profile/user_profile_cubit.dart';
import '../../cubits/user_profile/user_profile_state.dart';
import '../../screens/settings/settings_page.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        final user = state.user;
        final isLoading = state.loading;

        return Column(
          children: [
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.settings_outlined, color: Colors.grey[700]),
                onPressed: () {
                  final cubit = context.read<UserProfileCubit>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: cubit,
                        child: const SettingsPage(),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isLoading)
              const CircularProgressIndicator()
            else if (state.error != null)
              Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    '${l10n.error} loading profile',
                    style: const TextStyle(color: Colors.red),
                  ),
                  Text(
                    state.error!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            else ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple.shade50,
                ),
                child: ClipOval(
                  child: user?.photo != null
                      ? Image.network(
                          user!.photo!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            color: Colors.deepPurple,
                            size: 36,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: Colors.deepPurple,
                          size: 36,
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                user?.username ?? '...',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                user?.email ?? '',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ],
        );
      },
    );
  }
}
