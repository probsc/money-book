/// # ジャンルクラス
///
/// ジャンルの情報を保持
///
/// id:[id], ジャンル名:[name], 色:[color],
/// 登録日付:[createdAt],  更新日付:[updatedAt]
class Genre {
  int id;
  String name;
  int color;
  DateTime createdAt;
  DateTime updatedAt;

  /// # Map<String, dynamic> を genre に変換
  ///
  /// ```
  /// Item.fromMap(item);
  /// ```
  Genre.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        color = int.parse(map['color']),
        createdAt = DateTime.parse(map['created_at']),
        updatedAt = DateTime.parse(map['updated_at']);
}
