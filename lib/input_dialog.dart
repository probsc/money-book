import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:money_book/item.dart';

/// # 項目入力 ダイアログウィジェット
///
/// 引数は [id] を設定、項目を新規に登録する場合は、引数を省略
///
/// 項目入力ダイアログを表示
///
/// ```
/// showDialog(
///   context: context,
///   builder: (_) {
///     return InputDialog(
///       id: widget.item.id, // 編集時は引数に id を設定
///     );
/// })
/// ```
class InputDialog extends StatefulWidget {
  final int id;

  InputDialog({this.id});

  @override
  InputDialogState createState() => InputDialogState();
}

/// # [InputDialog] ウィジェットから呼ばれる State(状態) クラス
class InputDialogState extends State<InputDialog> {
  // 各入力項目の controller のインスタンスを生成
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // DatePicker 表示メソッド
  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      locale: const Locale('ja'), // DatePicker を日本語化
      initialDate: DateTime.now(), // 最初に表示する日付
      firstDate: DateTime(DateTime.now().year), // 表示できる最小の日付
      lastDate: DateTime(DateTime.now().year + 1),  // 表示できる最大の日付
    );
    // 選択した日付を返す
    return selected;
  }

  // ウィジェットが作成時に呼ばれるメソッド
  @override
  Widget build(BuildContext context) {
    // 入力項目ダイアログの UI を実装
    return AlertDialog(
      // ダイアログのタイトル
      title: Text('項目入力'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // 日付入力フォームを配置
          GestureDetector(
            // 日付入力フォーム押下時の処理
            onTap: () {
              // 選択した日付をフォームに表示
              setState(() {
                _selectDate(context).then(
                  (date) => _dateController.text =
                      date != null ? DateFormat('yyyy-MM-dd').format(date) : '',
                );
              });
            },
            // フォーム押下時にキーボードを表示しないように AbsorbPointer でラップ
            child: AbsorbPointer(
              child: TextField(
                controller: _dateController,
                maxLines: 1,
                // フォームが未入力の場合、ヒントを表示
                decoration: const InputDecoration(hintText: '日付'),
              ),
            ),
          ),
          // 項目入力フォームを配置
          TextField(
            controller: _nameController,
            maxLines: 1,
            // フォームが未入力の場合、ヒントを表示
            decoration: const InputDecoration(hintText: '項目'),
          ),
          // 金額入力フォームを配置
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number, // 入力キーボードを数字のみに制限
            maxLines: 1,
            // フォームの入力は数字のみ受け付ける
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            // フォームが未入力の場合、ヒントを表示
            decoration: const InputDecoration(hintText: '金額'),
          ),
        ],
      ),
      // キャンセル, OK ボタンを配置
      actions: <Widget>[
        // キャンセルボタン
        FlatButton(
          child: Text('キャンセル'),
          // ボタン押下時に、ダイアログを閉じる
          onPressed: () => Navigator.pop(context),
        ),
        // OK ボタン
        FlatButton(
            child: Text('OK'),
            // ボタン押下時の処理
            onPressed: () {
              // 項目に全て入力がある場合のみ保存を受け付ける
              if (_nameController.text.isEmpty ||
                  _priceController.text.isEmpty ||
                  _dateController.text.isEmpty) {
                // ダイアログを閉じる
                Navigator.pop(context);
              } else {
                Item item = Item(
                  _nameController.text,
                  int.parse(_priceController.text),
                  _dateController.text,
                  DateTime.now(),
                  DateTime.now(),
                  widget?.id,
                );
                // ダイアログを閉じる際に、item 遷移元の画面に渡す
                Navigator.pop(context, item);
              }
            }),
      ],
    );
  }
}
