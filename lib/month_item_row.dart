import 'package:flutter/material.dart';

import 'package:money_book/input_dialog.dart';
import 'package:money_book/item.dart';

/// # 月表示_項目表示行ウィジェット
///
/// 日付、項目名、金額、削除アイコンを表示
///
/// ```
/// child: MonthItemRow(
///   item: Item
/// )
/// ```
class MonthItemRow extends StatefulWidget {
  final Item item;
  final Function(int) onDeleteTapped;
  final Function(Item) onItemEdited;

  MonthItemRow({
    @required this.item,
    @required this.onDeleteTapped,
    @required this.onItemEdited,
  });

  @override
  MonthItemRowState createState() => MonthItemRowState();
}

class MonthItemRowState extends State<MonthItemRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Material(
      color: Colors.transparent,
      child: GestureDetector(
        // 項目入力ダイアログを表示
        onTap: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return InputDialog(
                  id: widget.item.id, // 編集時は項目の id を引数にする
                );
              }).then((item) {
            setState(() {
              if (item != null) {
                // 項目を編集
                widget.onItemEdited(item);
              }
            });
          });
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          // 日付
          Expanded(flex: 1, child: Text(widget.item.date)),
          // 項目名
          Expanded(flex: 1, child: Text(widget.item.name)),
          // 金額
          Expanded(flex: 1, child: Text('¥${widget.item.price.toString()}')),
          // 削除アイコン
          Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  widget.onDeleteTapped(widget.item.id);
                },
                icon: Image.asset(
                  'images/trash.png',
                  color: Colors.black,
                  width: 20,
                  height: 20,
                ),
              )),
        ]),
      ),
    ));
  }
}