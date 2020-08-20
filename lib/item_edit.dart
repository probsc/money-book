import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:money_book/db_helper.dart';
import 'package:money_book/genre.dart';
import 'package:money_book/item.dart';

/// # 項目入力画面
///
/// 引数は [id] を設定、項目を新規に登録する場合は、引数を省略
///
/// 項目入力画面を表示
///
/// ```
/// final item = await Navigator.of(context).push(MaterialPageRoute(
///   builder: (context) => ItemEdit(
///     id: widget.item.id, // 編集時は項目の id を引数にする
///   ),
/// ));
/// ```
class ItemEdit extends StatefulWidget {
  final int id;

  ItemEdit({this.id});

  @override
  ItemEditState createState() => ItemEditState();
}

/// # [ItemEdit] ウィジェットから呼ばれる State(状態) クラス
class ItemEditState extends State<ItemEdit> {
  // 各入力項目の controller のインスタンスを生成
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // DB ヘルパーのインスタンスを生成
  DbHelper _dbHelper = DbHelper.instance;

  // 選択したジャンルのインデックスを保持
  int _selectedIndex = 0;

  // DatePicker 表示メソッド
  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      locale: const Locale('ja'), // DatePicker を日本語化
      initialDate: DateTime.now(), // 最初に表示する日付
      firstDate: DateTime(DateTime.now().year), // 表示できる最小の日付
      lastDate: DateTime(DateTime.now().year + 1), // 表示できる最大の日付
    );
    // 選択した日付を返す
    return selected;
  }

  // DB からジャンルを読出
  Future<List<Genre>> _loadGenre() async {
    var genres = <Genre>[];
    var map = await _dbHelper.allRowsGenre();
    map.forEach((genre) {
      genres.add(Genre.fromMap(genre));
    });
    return genres;
  }

  // ウィジェットが作成時に呼ばれるメソッド
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // キーボード表示時に、項目入力画面がせり上がらないように設定
      resizeToAvoidBottomInset: false,
      // 画面の背景色を設定
      backgroundColor: Color(0xFFD9FCFF),
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
          // 日付入力フォームの UI を実装
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('日付'),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      // 日付入力フォームを配置
                      child: GestureDetector(
                        // 日付入力フォーム押下時の処理
                        onTap: () {
                          // 選択した日付をフォームに表示
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
                            // フォームが未入力の場合、ヒントを表示
                            decoration:
                                const InputDecoration(hintText: '日付を入力してください'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 項目名入力フォームの UI を実装 
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('項目'),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      // 項目入力フォームを配置
                      child: TextField(
                        controller: _nameController,
                        maxLines: 1,
                        // フォームが未入力の場合、ヒントを表示
                        decoration:
                            const InputDecoration(hintText: '項目名を入力してください'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 金額入力フォームの UI を実装
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('金額'),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      // 金額入力フォームを配置
                      child: TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number, // 入力キーボードを数字のみに制限
                        maxLines: 1,
                        // 入力は数字のみ受け付ける
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                        // フォームが未入力の場合、ヒントを表示
                        decoration:
                            const InputDecoration(hintText: '金額を入力してください'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // ジャンル入力ボタンの UI を実装
          Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              // ジャンル入力ボタンを配置
              child: Text(
                'ジャンル',
                textAlign: TextAlign.left,
              ),
            ),
          ),
          // DB からジャンルの一覧を読出してから、ジャンル入力ボタンを描画するため、FutureBuilder を使用
          FutureBuilder(
            future: _loadGenre(), // 処理完了を待つメソッドを設定
            builder: (context, snapshot) {
              // future に設定したメソッドの返り値は snapshot.data から取得
              // メソッドの返り値を取得していればジャンルボタンを描画する
              if (snapshot.hasData) {
                var genres = snapshot.data;
                return Container(
                  child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 10.0,
                      runSpacing: 4.0,
                      // ジャンル入力ボタンを生成
                      children: List.generate(genres.length, (index) {
                        return genreButton(
                            genres[index].name, index, genres[index].color);
                      })),
                );
              } else {
                return Text('データが存在しません');
              }
            },
          ),

          // 保存ボタンの UI を実装
          SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                // 保存ボタンを配置
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

  // 選択したジャンルのインデックスをセット
  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ジャンルボタン
  Widget genreButton(String name, int index, int color) {
    return RaisedButton(
      onPressed: () {
        changeIndex(index);
      },
      // ボタンの外線を設定
      shape: RoundedRectangleBorder(
        // 選択したジャンルボタンの外線を黒に変更する
        side: BorderSide(
            color: _selectedIndex == index ? Colors.black : Colors.transparent),
      ),
      color: Color(color),  // ボタンの色設定
      child: Text(name),  // ボタンに表示するテキストの設定
    );
  }
}
