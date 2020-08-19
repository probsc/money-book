import 'package:intl/intl.dart';

/// # 項目クラス
///
/// 引数は [id] を設定、項目を新規に登録する場合は、引数を省略
///
/// 項目の情報を保持
///
/// id:[id], 項目名:[name], 金額:[price],
/// 日付:[date], 登録日付:[createdAt],  更新日付:[updatedAt]
class Item {
  int id;
  String name;
  int price;
  String date;
  DateTime createdAt;
  DateTime updatedAt;

  Item(this.name, this.price, this.date, this.createdAt, this.updatedAt,
      [this.id]);

  /// # item を Map<String, dynamic> に変換
  ///
  /// ```
  /// item.toMap();
  /// ```
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'price': price,
      'date': date,
      // DateTime 型 から String 型に変換
      'created_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt),
      'updated_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(updatedAt),
    };
    return map;
  }

  /// # Map<String, dynamic> を item に変換
  ///
  /// ```
  /// Item.fromMap(item);
  /// ```
  Item.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        price = map['price'],
        date = map['date'],
        // String 型 から DateTime 型に変換
        createdAt = DateTime.parse(map['created_at']),
        updatedAt = DateTime.parse(map['updated_at']);
}
