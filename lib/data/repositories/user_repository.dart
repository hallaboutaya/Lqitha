import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../databases/db_helper.dart';

class UserRepository {
  Future<User?> getUserProfile(String userId) async {
    final db = await DBHelper.getDatabase();
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) return User.fromMap(maps.first);
    return null;
  }

  Future<void> updateUserProfile({
    required String userId,
    required String username,
    required String email,
    String? phoneNumber,
    String? photo,
  }) async {
    final db = await DBHelper.getDatabase();
    final current = await getUserProfile(userId);
    if (current == null) throw Exception("User not found");

    final updatedUser = User(
      id: userId,
      username: username,
      email: email,
      password: current.password,
      phoneNumber: phoneNumber ?? current.phoneNumber,
      photo: photo ?? current.photo,
      role: current.role,
      points: current.points,
      createdAt: current.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );

    await db.update(
      'users',
      updatedUser.toMap(),
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> updateUserPhoto(String userId, String photoPath) async {
    final db = await DBHelper.getDatabase();
    await updateUserProfile(
      userId: userId,
      username: (await getUserProfile(userId))!.username,
      email: (await getUserProfile(userId))!.email,
      phoneNumber: (await getUserProfile(userId))!.phoneNumber,
      photo: photoPath,
    );
  }

  Future<void> logout() async {
    // Clear any local "current user" data if needed
  }
}
