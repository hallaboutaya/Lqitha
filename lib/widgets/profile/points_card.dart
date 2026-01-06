import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../cubits/user_profile/user_profile_cubit.dart';
import '../../cubits/user_profile/user_profile_state.dart';

class PointsCard extends StatelessWidget {
  const PointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        final points = state.user?.points ?? 0;
        
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.orange],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.emoji_events_outlined, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(l10n.totalPoints, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  Text(l10n.active, style: const TextStyle(color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '$points',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.keepHelpingOthers,
                style: TextStyle(color: Colors.white.withOpacity(0.9)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                child: Text(l10n.reclaimMyPoints),
              )
            ],
          ),
        );
      },
    );
  }
}
