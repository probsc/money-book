import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// # 項目入力 ダイアログウィジェット
/// 
/// 項目入力ダイアログを表示
class InputDialog extends StatefulWidget {
  @override
  InputDialogState createState() => InputDialogState();
} 

class InputDialogState extends State<InputDialog> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  // DatePicker 表示メソッド
  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
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
                  (date) => _dateController.text = date != null 
                    ? DateFormat('yyyy/MM/dd').format(date)
                    : '',
                );
              }); 
            }, 
            // TextField タップ時にキーボードを表示しないように AbsorbPointer でラップ
            child: AbsorbPointer(
              child: TextField(
                controller: _dateController,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: '日付'
                ),
              ),
            ),
          ),
          TextField(  // 項目入力
            controller: _nameController,
            maxLines: 1,
            decoration: const InputDecoration(
              hintText: '項目'
            ),
          ),
          TextField(  // 金額入力
            controller: _priceController,
            maxLines: 1,
            decoration: const InputDecoration(
              hintText: '金額'
            ),
          ),
        ],
      ),
      actions: <Widget>[
          FlatButton(
            child: Text('キャンセル'),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child:Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
      ],
    ); 
  }
}
