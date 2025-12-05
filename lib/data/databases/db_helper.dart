import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _database_name = "lqitha.db";
  static const _database_version = 1;
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), _database_name),
      version: _database_version,
      onCreate: (db, version) async {
        // USERS TABLE
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            phone_number TEXT,
            photo TEXT,
            role TEXT DEFAULT 'user',
            points INTEGER DEFAULT 0,
            created_at TEXT,
            updated_at TEXT
          )
        ''');

        // LOST POSTS TABLE
        await db.execute('''
          CREATE TABLE lost_posts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            photo TEXT,
            description TEXT,
            status TEXT DEFAULT 'pending',
            location TEXT,
            category TEXT,
            created_at TEXT,
            user_id INTEGER,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');

        // FOUND POSTS TABLE
        await db.execute('''
          CREATE TABLE found_posts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            photo TEXT,
            description TEXT,
            status TEXT DEFAULT 'pending',
            location TEXT,
            category TEXT,
            created_at TEXT,
            user_id INTEGER,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');

        // NOTIFICATIONS TABLE
        await db.execute('''
          CREATE TABLE notifications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            message TEXT NOT NULL,
            related_post_id INTEGER,
            type TEXT,
            is_read INTEGER DEFAULT 0,
            created_at TEXT,
            user_id INTEGER,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');
      },
    );
    print('📍 DATABASE PATH: ${_database!.path}');

    return _database!;
  }
}
