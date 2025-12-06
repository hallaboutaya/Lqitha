import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DBHelper {
  static const _database_name = "lqitha.db";
  static const _database_version = 2;
  static Database? _database;
  static bool _initialized = false;

  static Future<Database> getDatabase() async {
    // Initialize database factory for web
    if (kIsWeb && !_initialized) {
      databaseFactory = databaseFactoryFfiWeb;
      _initialized = true;
    }

    if (_database != null) return _database!;

    _database = await openDatabase(
      kIsWeb ? _database_name : join(await getDatabasesPath(), _database_name),
      version: _database_version,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Drop all tables to force recreation with correct schema
          await db.execute('DROP TABLE IF EXISTS notifications');
          await db.execute('DROP TABLE IF EXISTS found_posts');
          await db.execute('DROP TABLE IF EXISTS lost_posts');
          await db.execute('DROP TABLE IF EXISTS users');
          // Re-create tables will happen in onCreate logic below? 
          // No, onUpgrade replaces onCreate path if db exists.
          // We need to call _createTables(db) here.
          await _createTables(db);
        }
      },
      onCreate: (db, version) async {
        await _createTables(db);
      },
    );

    return _database!;
  }

  static Future<void> _createTables(Database db) async {
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
  }
}
