お小遣い帳 Flutter アプリ
===

# 環境

- Flutter 1.20.2
- Dart 2.9.1
- SQLite

## 導入ライブラリ
- [fl_chart 0.11.0](https://pub.dev/packages/fl_chart)
- [path 1.6.4](https://pub.dev/packages/path)
- [path_provider 1.6.11](https://pub.dev/packages/path_provider)
- [sqflite 1.3.1](https://pub.dev/packages/sqflite)

## ライブラリインストール
- pubspec.yaml ファイルの dependencies: のセクションに使用するライブラリを追加

- 以下、記述例
    ```
    dependencies:
        sqflite: ^1.3.1
    ```

# 機能

## メイン画面
- タブの一覧/月表示で表示する一覧を切替ることが可能
- 項目は入力、編集、削除が可能
- フローティングボタン(+ボタン)、項目行をタップすると項目入力ダイアログを表示

### 一覧
- 一覧には登録した項目内容を全て表示
- 各項目行に日付、項目名、金額、削除ボタンを表示

### 月表示
- 画面上部の日付の両端の矢印ボタンをタップすると前の月、次の月に移動
- 月表示には表示月ごとの項目、円グラフ、合計金額を表示
- 円グラフは項目名ごとに集計され項目名と合計金額を表示
- 各項目行に日付、項目名、金額、削除ボタンを表示
