import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// #  DB 関連クラス
class DbHelper {
  final String dbName = 'money_book.db';
  final String itemsTableName = 'items';
  final String genreTableName = 'genre';

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
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /// DB 作成メソッド
  Future _onCreate(Database db, int version) async {
    var batch = db.batch();
    // 項目テーブル作成
    batch.execute('''
        CREATE TABLE IF NOT EXISTS "items" (
        "id"	INTEGER NOT NULL UNIQUE,
        "genreId"	INTEGER NOT NULL,
        "name"	TEXT NOT NULL,
        "price"	INTEGER NOT NULL,
        "date"	TEXT NOT NULL,
        "created_at"	TEXT NOT NULL,
        "updated_at"	TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("genreId") REFERENCES "genre"("id")
      );
    ''');
    // ジャンルテーブル作成
    batch.execute('''
        CREATE TABLE IF NOT EXISTS "genre" (
        "id"	INTEGER NOT NULL UNIQUE,
        "name"	TEXT NOT NULL,
        "color"	TEXT NOT NULL,
        "created_at"	TEXT NOT NULL,
        "updated_at"	TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
    ''');
    // ジャンルを insert
    batch.rawInsert(
        '''INSERT INTO "genre" VALUES (1,'食費','0xFFFFFABC','2020-08-10 10:00:00','2020-08-10 10:00:00');''');
    batch.rawInsert(
        '''INSERT INTO "genre" VALUES (2,'住居費','0xFFE3C2C2','2020-08-10 10:00:00','2020-08-10 10:00:00');''');
    batch.rawInsert(
        '''INSERT INTO "genre" VALUES (3,'光熱費','0xFFFCFC69','2020-08-10 10:00:00','2020-08-10 10:00:00');''');
    batch.rawInsert(
        '''INSERT INTO "genre" VALUES (4,'交通費','0xFFBAFFC2','2020-08-10 10:00:00','2020-08-10 10:00:00');''');
    batch.rawInsert(
        '''INSERT INTO "genre" VALUES (5,'被服費','0xFFB9DFFF','2020-08-10 10:00:00','2020-08-10 10:00:00');''');
    batch.rawInsert(
        '''INSERT INTO "genre" VALUES (6,'趣味','0xFF7CEBFF','2020-08-10 10:00:00','2020-08-10 10:00:00');''');
    batch.rawInsert(
        '''INSERT INTO "genre" VALUES (7,'日用品','0xFFFF7979','2020-08-10 10:00:00','2020-08-10 10:00:00');''');
    batch.rawInsert(
        '''INSERT INTO "genre" VALUES (8,'雑費','0xFFFFD6FC','2020-08-10 10:00:00','2020-08-10 10:00:00');''');

    // SQL実行
    await batch.commit();
  }

  // 項目テーブル関連
  /// # データ追加 メソッド
  Future<void> insert(Map<String, dynamic> row) async {
    Database db = await instance.db;
    await db.insert(itemsTableName, row);
  }

  /// # 全件取得 メソッド
  Future<List<Map<String, dynamic>>> allRows() async {
    Database db = await instance.db;
    return await db.query(itemsTableName);
  }

  /// # データ更新メソッド
  Future<void> update(int id, Map<String, dynamic> row) async {
    Database db = await instance.db;
    await db.update(itemsTableName, row, where: 'id=?', whereArgs: [id]);
  }

  /// # データ削除メソッド
  Future<void> delete(int id) async {
    Database db = await instance.db;
    await db.delete(itemsTableName, where: 'id=?', whereArgs: [id]);
  }

  // ジャンルテーブル
  /// # 全件取得 メソッド
  Future<List<Map<String, dynamic>>> allRowsGenre() async {
    Database db = await instance.db;
    return await db.query(genreTableName);
  }

  /// # ジャンル取得メソッド
  Future<String> selectGenreName (int id) async {
    Database db = await instance.db;
    await db.query('SELECT genre FROM $genreTableName WHERE id=$id');
  }
}
