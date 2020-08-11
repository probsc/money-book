import 'package:flutter/material.dart';

/// # 項目表示行ウィジェット
/// 
/// 日付、項目名、金額、削除アイコンを表示
/// 
/// ```
/// child: ItemRow()
/// ``` 
class ItemRow extends StatefulWidget {
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
            Expanded(
              flex: 1, 
              child: Text('2020/08/10')
            ),
            Expanded(
              flex: 1,
              child: Text('食費')
            ),
            Expanded(
              flex: 1, 
              child: Text('¥1000')
            ),
            Expanded(
              flex: 1,
              child: Icon(Icons.android)
            ),
          ]
        )
      )
    );    
  }
}
