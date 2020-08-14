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
  // 各入力項目の controller
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // DatePicker 表示メソッド
  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      locale: const Locale('ja'), // DatePicker を日本語化
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    return selected;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('項目入力'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // 選択した日付をダイアログに表示
              setState(() {
                _selectDate(context).then(
                  (date) => _dateController.text =
                      date != null ? DateFormat('yyyy-MM-dd').format(date) : '',
                );
              });
            },
            // TextField タップ時にキーボードを表示しないように AbsorbPointer でラップ
            child: AbsorbPointer(
              child: TextField(
                controller: _dateController,
                maxLines: 1,
                decoration: const InputDecoration(hintText: '日付'),
              ),
            ),
          ),
          TextField(
            // 項目入力
            controller: _nameController,
            maxLines: 1,
            decoration: const InputDecoration(hintText: '項目'),
          ),
          TextField(
            // 金額入力
            controller: _priceController,
            keyboardType: TextInputType.number, // 入力キーボードを数字のみに制限
            maxLines: 1,
            // 入力は数字のみ受け付ける
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(hintText: '金額'),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('キャンセル'),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
            child: Text('OK'),
            onPressed: () {
              // 項目に全て入力がある場合のみ保存を受け付ける
              if (_nameController.text.isEmpty ||
                  _priceController.text.isEmpty ||
                  _dateController.text.isEmpty) {
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
                Navigator.pop(context, item);
              }
            }),
      ],
    );
  }
}
