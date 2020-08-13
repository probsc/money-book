import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// #  DB 関連クラス
class DbHelper {
  final String dbName = 'money_book.db';
  final String tableName = 'items';

  // シングルトン
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  // DB にアクセス
  static Database _db;
  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await _initDatabase();
    return _db;
  }

  /// # DB 初期化 メソッド
  _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, dbName);
    
    // DB が存在しない場合、DB を新規に作成
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate);
  }

  /// DB 作成メソッド
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS "items" (
          "id" INTEGER NOT NULL UNIQUE,
          "name" TEXT NOT NULL,
          "price" INTEGER NOT NULL,
          "date" TEXT NOT NULL,
          "created_at" TEXT NOT NULL,
          "updated_at" TEXT NOT NULL,
          PRIMARY KEY("id" AUTOINCREMENT)
      );
    ''');
  }

  /// # データ追加 メソッド
  Future<void> insert(Map<String, dynamic> row) async {
    Database db = await instance.db;
    await db.insert(tableName, row);
  }

  /// # 全件取得 メソッド
  Future<List<Map<String, dynamic>>> allRows() async {
    Database db = await instance.db; 
    return await db.query(tableName);
  }

  /// # データ更新メソッド
  Future<void> update(int id, Map<String, dynamic> row) async {
    Database db = await instance.db;
    await db.update(tableName, row, where: 'id=?', whereArgs: [id]);
  }

  /// # データ削除メソッド
  Future<void> delete(int id) async {
    Database db = await instance.db;
    await db.delete(tableName, where: 'id=?', whereArgs: [id]);
  }
}
