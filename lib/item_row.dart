import 'package:flutter/material.dart';

import 'package:money_book/item.dart';

/// # 項目表示行ウィジェット
/// 
/// 日付、項目名、金額、削除アイコンを表示
/// 
/// ```
/// child: ItemRow(
///   item: Item
/// )
/// ``` 
class ItemRow extends StatefulWidget {
  final Item item;
  final Function(int) onDeleteTaped;

  ItemRow({@required this.item, @required this.onDeleteTaped});

  @override
  ItemRowState createState() => ItemRowState();
}

class ItemRowState extends State<ItemRow> {
 @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // 日付
            Expanded(
              flex: 1, 
              child: Text(widget.item.date)
            ),
            // 項目名
            Expanded(
              flex: 1,
              child: Text(widget.item.name)
            ),
            // 金額
            Expanded(
              flex: 1, 
              child: Text(widget.item.price.toString())
            ),
            // 削除アイコン
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  widget.onDeleteTaped(widget.item.id);
                },
                icon: Icon(Icons.android)
              )
            ),
          ]
        )
      )
    );
  }
}
