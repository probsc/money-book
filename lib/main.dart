import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'package:money_book/db_helper.dart';
import 'package:money_book/input_dialog.dart';
import 'package:money_book/item.dart';
import 'package:money_book/item_row.dart';

void main() {
  runApp(MyApp());
}

/// # MyApp クラス
///
/// ## アプリ本体
/// アプリのメイン画面を表示
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // MaterialApp で日本語対応をサポート
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ja'),
      ],
      home: MyHomePage(),
    );
  }
}

/// # メイン画面ウィジェット
///
/// ## お小遣い帳のメイン画面
/// タブ、項目一覧、月表示を表示
///
/// ```
/// home: MyHomePage()
/// ```
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

/// # [MyHomePage] ウィジェットから呼ばれる State(状態) クラス
///
/// TabBarView を使用するため SingleTickerProviderStateMixin を継承
class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    Tab(text: '一覧'),
    Tab(text: '月表示'),
  ];
  TabController _tabController;

  // DB ヘルパーのインスタンスを生成
  final _dbHelper = DbHelper.instance;

  // 各項目を保持するリスト
  List<Item> _listViewItems = <Item>[];

  // 月表示用リスト
  List<Item> _monthViewItems = <Item>[];

  // 月表示の合計金額を保持
  int _totalPrice = 0;

  // タブのインデックスを保持
  int _tabIndex = 0;

  // 表示月を保持
  DateTime _currentDate = DateTime.now();

  // DB から項目を読出して一覧に加える
  void _loadItems() {
    _listViewItems = <Item>[];
    _dbHelper.allRows().then((map) {
      // 読出時に一覧を再描画
      setState(() {
        _updateListView(map);
        _updateMonthView();
      });
    });
  }

  // 一覧を更新
  void _updateListView(List<Map<String, dynamic>> map) {
    map.forEach((item) {
      _listViewItems.add(Item.fromMap(item));
    });
  }

  // 表示月の一覧を更新
  void _updateMonthView() {
    var firstOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    var lastOfMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0);
    _monthViewItems = <Item>[];
    _totalPrice = 0;

    // 表示月に該当する日付で項目を絞り込む
    _monthViewItems = _listViewItems.where((item) {
      var date = DateTime.parse(item.date);
      return date.compareTo(firstOfMonth) >= 0 &&
          date.compareTo(lastOfMonth) < 0;
    }).toList();

    // 表示月の合計金額を算出
    _monthViewItems.forEach((item) {
      _totalPrice += item.price;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);

    // DB から既存の項目を読出
    _loadItems();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar にタブを配置
      appBar: AppBar(
          flexibleSpace: Padding(
              padding: EdgeInsets.only(top: 27),
              child: Column(children: <Widget>[
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // 一覧ボタン
                      FlatButton(
                        // 選択された場合はボタンの背景色を白に変更する
                        color: _tabIndex == 0 ? Colors.white : Colors.blue,
                        onPressed: () {
                          _tabController.animateTo(0);
                          setState(() {
                            _tabIndex = 0;
                          });
                        },
                        child: Text(tabs[0].text),
                      ),
                      // 月表示ボタン
                      FlatButton(
                        // 選択された場合はボタンの背景色を白に変更する
                        color: _tabIndex == 1 ? Colors.white : Colors.blue,
                        onPressed: () {
                          _tabController.animateTo(1);
                          setState(() {
                            _tabIndex = 1;
                          });
                        },
                        child: Text(tabs[1].text),
                      )
                    ],
                  ),
                ),
              ]))),
      body: TabBarView(
        controller: _tabController,
        // タブのみでスクロールするように設定
        physics: const NeverScrollableScrollPhysics(),
        children: tabs.map((tab) {
          if (tabs[0] == tab) {
            // 一覧表示
            return ListView.builder(itemBuilder: (context, index) {
              if (index >= _listViewItems.length) {
                return null;
              }

              return Padding(
                padding: EdgeInsets.all(1.0),
                // 項目表示行を配置
                child: ItemRow(
                  item: _listViewItems[index],
                  onDeleteTapped: (id) {
                    setState(() {
                      // 選択した項目を削除
                      _dbHelper.delete(id);
                      _listViewItems.removeAt(index);
                      _updateMonthView();
                    });
                  },
                  onItemEdited: (item) {
                    setState(() {
                      // 選択した項目を更新
                      _dbHelper.update(item.id, item.toMap());
                      _listViewItems[index] = item;
                      _updateMonthView();
                    });
                  },
                ),
              );
            });
          } else {
            // 月表示
            // 「< 2020年 08月 >」の UI を実装
            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // 左矢印ボタン
                      IconButton(
                        onPressed: () {
                          // 先月に変更
                          setState(() {
                            var newDate = DateTime(_currentDate.year,
                                _currentDate.month - 1, _currentDate.day);
                            _currentDate = newDate;
                            _updateMonthView();
                          });
                        },
                        icon: Image.asset(
                          'images/left_arrow.png',
                          color: Colors.black,
                          width: 20,
                          height: 20,
                        ),
                      ),
                      Text(DateFormat('yyyy年 MM月').format(_currentDate),
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 20,
                          )),
                      // 右矢印ボタン
                      IconButton(
                        onPressed: () {
                          // 来月に変更
                          setState(() {
                            var newDate = DateTime(_currentDate.year,
                                _currentDate.month + 1, _currentDate.day);
                            _currentDate = newDate;
                            _updateMonthView();
                          });
                        },
                        icon: Image.asset(
                          'images/right_arrow.png',
                          color: Colors.black,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                      // 合計金額
                      '¥${_totalPrice.toString()}',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20,
                      )),
                ),
                // 月ごとの一覧を表示
                Flexible(
                  child: ListView.builder(itemBuilder: (context, index) {
                    if (index >= _monthViewItems.length) {
                      return null;
                    }

                    return Padding(
                      padding: EdgeInsets.all(1.0),
                      child: ItemRow(
                        item: _monthViewItems[index],
                        onDeleteTapped: (id) {
                          setState(() {
                            // 選択した項目を削除
                            _dbHelper.delete(id);
                            _listViewItems.removeAt(index);
                            _updateMonthView();
                          });
                        },
                        onItemEdited: (item) {
                          setState(() {
                            // 選択して項目を更新
                            _dbHelper.update(item.id, item.toMap());
                            _listViewItems[index] = item;
                            _updateMonthView();
                          });
                        },
                      ),
                    );
                  }),
                ),
              ],
            );
          }
        }).toList(),
      ),
      // フローティングボタン(新規項目追加)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 項目入力ダイアログを表示
          showDialog(
              barrierDismissible: false, // ダイアログの背景を押しても閉じないように設定
              context: context,
              builder: (_) {
                return InputDialog();
              }).then((item) {
            setState(() {
              if (item != null) {
                // 新規項目を DB に保存
                _dbHelper.insert(item.toMap());

                // 一覧を更新
                _loadItems();
              }
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
