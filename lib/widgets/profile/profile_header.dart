import 'package:flutter/material.dart';
import '../../screens/profile/edit_profile_screen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(Icons.edit_outlined, color: Colors.grey[700]),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
        ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.deepPurple.shade50,
          ),
          child: ClipOval(
            child: Image.network(
              'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=400',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.person, color: Colors.deepPurple, size: 36),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Amina Kader',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text(
          'amina.kader@email.com',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
