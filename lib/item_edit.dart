import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:money_book/item.dart';

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

  int _selectedIndex = 0;

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
      // キーボード表示時に、項目入力画面がせり上がらないように設定
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: <Widget>[
          // 編集時のみ削除ボタンを表示
          Visibility(
            visible: widget.id != null, // id があれば表示
            // 削除ボタン
            child: IconButton(
              icon: Image.asset(
                'images/trash.png',
                width: 20,
                height: 20,
              ),
              onPressed: () {
                // 項目を削除
                Navigator.of(context).pop(widget.id);
              },
            ),
          )
        ],
      ),
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
          // ジャンル入力
          Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'ジャンル',
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Container(
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 10.0,
              runSpacing: 4.0,
              children: <Widget>[
                // 各ジャンルのボタンを配置
                genreButton('食費', 0, const Color(0xFFFFFABC)),
                genreButton('住居費', 1, const Color(0xFFE3C2C2)),
                genreButton('光熱費', 2, const Color(0xFFFCFC69)),
                genreButton('交通費', 3, const Color(0xFFBAFFC2)),
                genreButton('被服費', 4, const Color(0xFFB9DFFF)),
                genreButton('趣味', 5, const Color(0xFF7CEBFF)),
                genreButton('日用品', 6, const Color(0xFFFF7979)),
                genreButton('雑費', 7, const Color(0xFFFFD6FC)),
              ],
            ),
          ),
          SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: RaisedButton(
                  onPressed: () {
                    // 項目に全て入力がある場合のみ保存を受け付ける
                    if (_nameController.text.isEmpty ||
                        _priceController.text.isEmpty ||
                        _dateController.text.isEmpty) {
                      Navigator.pop(context);
                    } else {
                      Item item = Item(
                        _selectedIndex + 1,
                        _nameController.text,
                        int.parse(_priceController.text),
                        _dateController.text,
                        DateTime.now(),
                        DateTime.now(),
                        widget?.id,
                      );
                      // 入力した項目データを前画面に返す
                      Navigator.of(context).pop(item);
                    }
                  },
                  child: Text(
                    '保存',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget genreButton(String name, int index, Color color) {
    return RaisedButton(
      onPressed: () {
        changeIndex(index);
      },
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: _selectedIndex == index ? Colors.black : Colors.transparent),
      ),
      color: color,
      child: Text(name),
    );
  }
}
