import '../databases/db_helper.dart';
import '../models/lost_post.dart';
import '../models/found_post.dart';
import '../local/dummy_data.dart';

class AdminRepository {
  Future<List<LostPost>> getPendingLostPosts() async {
    // For demo purposes, using dummy data
    // In production, use:
    // final db = await DBHelper.getDatabase();
    // final List<Map<String, dynamic>> maps = await db.rawQuery('''
    //   SELECT lp.*, u.username, u.photo as user_photo
    //   FROM lost_posts lp
    //   LEFT JOIN users u ON lp.user_id = u.id
    //   WHERE lp.status = ?
    //   ORDER BY lp.created_at DESC
    // ''', ['pending']);
    // return List.generate(maps.length, (i) => LostPost.fromMap(maps[i]));

    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.getPendingLostPosts();
  }

  Future<List<FoundPost>> getPendingFoundPosts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.getPendingFoundPosts();
  }

  Future<List<LostPost>> getApprovedLostPosts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  Future<List<FoundPost>> getApprovedFoundPosts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  Future<List<LostPost>> getRejectedLostPosts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  Future<List<FoundPost>> getRejectedFoundPosts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  Future<void> approvePost(int id, String type) async {
    // In production:
    // final db = await DBHelper.getDatabase();
    // await db.update(
    //   type == 'lost' ? 'lost_posts' : 'found_posts',
    //   {'status': 'approved'},
    //   where: 'id = ?',
    //   whereArgs: [id],
    // );

    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> rejectPost(int id, String type) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<Map<String, int>> getStatistics() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyData.getStatistics();
  }
}
