import 'package:flutter/material.dart';

import 'package:money_book/input_dialog.dart';
import 'package:money_book/item.dart';

/// # 項目表示行ウィジェット
///
/// 日付、項目名、金額、削除アイコンを表示
///
/// 引数:[item],[onDeleteTapped],[onItemEdited]
/// また、[onDeleteTapped],[onItemEdited]はコールバック関数
///
/// ```
/// child: ItemRow(
///   item: Item
/// )
/// ```
class ItemRow extends StatefulWidget {
  final Item item;
  final Function(int) onDeleteTapped;
  final Function(Item) onItemEdited;

  // @required を引数につけると必須パラメータになる
  ItemRow({
    @required this.item,
    @required this.onDeleteTapped,
    @required this.onItemEdited,
  });

  @override
  ItemRowState createState() => ItemRowState();
}

/// # [ItemRow] ウィジェットから呼ばれる State(状態) クラス
class ItemRowState extends State<ItemRow> {
  // ウィジェットが作成時に呼ばれるメソッド
  @override
  Widget build(BuildContext context) {
    // 項目行の UI を実装
    return Container(
        child: Material(
      color: Colors.transparent,
      child: GestureDetector(
        // 項目行押下時の処理
        onTap: () {
          // 押下時に項目入力ダイアログを表示
          showDialog(
              barrierDismissible: false, // ダイアログの背景を押しても閉じないように設定
              context: context,
              builder: (_) {
                return InputDialog(
                  id: widget.item.id, // 編集時は項目の id を引数にする
                );
              }).then((item) {
            // 項目編集時に再描画
            setState(() {
              if (item != null) {
                // 項目の編集をコールバックメソッドに通知
                widget.onItemEdited(item);
              }
            });
          });
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          // 項目名
          Expanded(flex: 1, child: Center(child: Text(widget.item.name))),
          // 金額
          Expanded(
              flex: 1,
              child: Center(child: Text('¥${widget.item.price.toString()}'))),
          // 削除アイコン
          Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  // 削除ボタン押下時に処理
                  onPressed: () {
                    // 項目の削除をコールバックメソッドに通知
                    widget.onDeleteTapped(widget.item.id);
                  },
                  // アイコン画像を設定
                  icon: Image.asset(
                    'images/trash.png',
                    color: Colors.black,
                    width: 20,
                    height: 20,
                  ),
                )),
          )
        ]),
      ),
    ));
  }
}
