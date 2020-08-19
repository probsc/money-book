import 'package:flutter/material.dart';

import 'package:money_book/genre.dart';
import 'package:money_book/item.dart';
import 'package:money_book/item_edit.dart';

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
  final Genre genre;
  final Function(int) onDeleteTapped;
  final Function(Item) onItemEdited;

  ItemRow({
    @required this.item,
    @required this.genre,
    @required this.onDeleteTapped,
    @required this.onItemEdited,
  });

  @override
  ItemRowState createState() => ItemRowState();
}

class ItemRowState extends State<ItemRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Material(
      color: Colors.transparent,
      child: GestureDetector(
        // 項目入力ダイアログを表示
        onTap: () async {
          // 項目入力画面に遷移
          final result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ItemEdit(
              id: widget.item.id, // 編集時は項目の id を引数にする
            ),
          ));
          setState(() {
            if (result != null) {
              // 項目入力画面から Item を受け取った場合は更新処理,それ以外は削除処理
              if (result is Item) {
                // 項目を編集
                widget.onItemEdited(result);
              } else {
                // 項目を削除
                widget.onDeleteTapped(result);
              }
            }
          });
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          // 日付/ジャンルを表示
          Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  // 日付
                  Text(widget.item.date),
                  // ジャンル
                  Container(
                    width: 60,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        widget.genre.name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // ジャンルごとの色を設定
                    color: Color(widget.genre.color),
                  ),
                ],
              )),
          // 項目名
          Expanded(
              flex: 1,
              child: Text(
                widget.item.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // 金額
          Expanded(flex: 1, child: Text('¥${widget.item.price.toString()}')),
        ]),
      ),
    ));
  }
}
