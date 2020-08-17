import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemEdit extends StatefulWidget {
  final int id;

  ItemEdit({this.id});

  @override
  ItemEditState createState() => ItemEditState();
}

/// # [ItemEdit] ウィジェットから呼ばれる State(状態) クラス
class ItemEditState extends State<ItemEdit> {
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
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          // 日付入力
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('日付'),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      // 選択した日付をダイアログに表示
                      setState(() {
                        _selectDate(context).then(
                          (date) => _dateController.text = date != null
                              ? DateFormat('yyyy-MM-dd').format(date)
                              : '',
                        );
                      });
                    },
                    // TextField タップ時にキーボードを表示しないように AbsorbPointer でラップ
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _dateController,
                        maxLines: 1,
                        decoration:
                            const InputDecoration(hintText: '日付を入力してください'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // 項目名入力
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('項目'),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    // 項目入力
                    controller: _nameController,
                    maxLines: 1,
                    decoration: const InputDecoration(hintText: '項目名を入力してください'),
                  ),
                ),
              ),
            ],
          ),
          // 金額入力
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('金額'),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    // 金額入力
                    controller: _priceController,
                    keyboardType: TextInputType.number, // 入力キーボードを数字のみに制限
                    maxLines: 1,
                    // 入力は数字のみ受け付ける
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(hintText: '金額を入力してください'),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
