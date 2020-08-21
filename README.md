お小遣い帳 Flutter アプリ
===

# 環境

- Flutter 1.20.2
- Dart 2.9.1
- SQLite

## 導入ライブラリ
- [fl_chart 0.11.0](https://pub.dev/packages/fl_chart)
- [grouped_list 3.3.0](https://pub.dev/packages/grouped_list)
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
- 項目は登録、編集、削除が可能
- フローティングボタン(+ボタン)、項目行をタップすると項目入力画面を表示

### 一覧
- 一覧には登録した項目内容を全て表示
- ヘッダーに日付を表示
- 同じ日付ごとにグループ化し項目行を表示
- 各項目行にジャンル、項目名、金額を表示

### 月表示
- 画面上部の日付の両端の矢印ボタンをタップすると前の月、次の月に移動
- 月表示には表示月ごとの項目、合計金額が表示
- ヘッダーに日付を表示
- 同じ日付ごとにグループ化し項目行を表示
- 各項目行にジャンル、項目名、金額を表示

## 項目入力画面
- 日付、項目名、金額、ジャンルの入力が可能
- 登録済みの項目行はヘッダー右の削除ボタンから削除が可能
- 保存ボタンで項目を登録
