import 'package:intl/intl.dart';

class Item {
  int id;
  String name;
  int price;
  String date;
  DateTime createdAt;
  DateTime updatedAt;

  Item(
    this.name,
    this.price,
    this.date,
    this.createdAt,
    this.updatedAt,
    [this.id]
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'name': name,
      'price': price,
      'date': date,
      'created_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt),
      'updated_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(updatedAt),
    };
    return map;
  }

  Item.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      price = map['price'],
      date = map['date'],
      createdAt = DateTime.parse(map['created_at']),
      updatedAt = DateTime.parse(map['updated_at']);
}