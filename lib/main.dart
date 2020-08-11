import 'package:flutter/material.dart';

import 'package:money_book/input_dialog.dart';
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
  const MyHomePage({ Key key }) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with  SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    Tab(text: '一覧'),
    Tab(text: '月表示'),
  ];
  
  TabController _tabController;
  
  int _index = 0;
  
   @override
   void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
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
          child: Column(
          children: <Widget>[
           Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // 一覧/月表示ボタンを配置
                  FlatButton(
                    color: _index == 0 ? Colors.white : Colors.blue,
                    onPressed: () {
                      _tabController.animateTo(0);
                      setState(() {
                        _index = 0;
                      });
                    },
                    child: Text(tabs[0].text),
                  ),
                  FlatButton(
                    color: _index == 1 ? Colors.white : Colors.blue,
                    onPressed: () {
                      _tabController.animateTo(1);
                      setState(() {
                        _index = 1;
                      });
                    },
                    child: Text(tabs[1].text),
                  )
                ],
              ),
            ),
          ]
         )
        )
      ),
      body: TabBarView(
        controller: _tabController,
        // タブ以外で画面をスクロールさせないように設定
        physics: const NeverScrollableScrollPhysics(),
        children: tabs.map((tab) {
          if (tab.text.contains(tabs[0].text)) {
            // 一覧表示
            return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.all(1.0),
                child: ItemRow(),
              );
            });
          } else {
            // 月表示
            return Column(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.arrow_left),
                        Text(
                          '2020年 08月',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 20,
                          )
                        ),
                        Icon(Icons.arrow_right),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(  // 合計金額
                    '¥xxxxx',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                    )
                  ),
                ),
                // 月ごとの一覧を表示
                Flexible(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(1.0),
                        child: ItemRow(),
                      );
                    }
                  ),
                ),
              ],
            );
          }  
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) {
              return InputDialog();
            }
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
