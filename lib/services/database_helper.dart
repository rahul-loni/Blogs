import 'package:sqflite/sqflite.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqllite_db/model/blog_model.dart';

class DataBaseHelper {
  static const int _version = 1;
  static const String _dbName = "Blogs.db";

  static Future<Database> _getDb() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async => await db.execute(
          "CREATE TABLE Blog(id INTEGER PRIMARY KEY, title TEXT NOT NULL , description  TEXT NOT NULL,image TEXT NOT NULL)"),
      version: _version,
    );
  }

  static Future<int> addBlog(Blog blog) async {
    final db = await _getDb();
    return await db.insert("Blog", blog.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateBlog(Blog blog) async {
    final db = await _getDb();
    return await db.update(
      "Blog",
      blog.toJson(),
      where: 'id=?',
      whereArgs: [blog.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> deleteBlog(Blog blog) async {
    final db = await _getDb();
    return await db.delete(
      "Blog",
      where: 'id=?',
      whereArgs: [blog.id],
    );
  }

  static Future<List<Blog>?> getAllBlog() async {
    final db = await _getDb();
    final List<Map<String, dynamic>> maps = await db.query("Blog");
    if (maps.isEmpty) {
      return null;
    }
    return List.generate(
      maps.length,
      (index) => Blog.fromJson(
        maps[index],
      ),
    );
  }
}
