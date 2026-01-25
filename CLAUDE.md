# Claude Code Configuration

## 変更点
これは元々Google Apps Scriptでの作成を予定していました。
しかしうまく動作しなかったため、Webアプリケーションとして再構築します。
Webアプリケーション用に再設計してください。
Line Messaging APIは使用しません。

## 技術スタック
* 言語：Ruby 3.4.5
* フレームワーク：Ruby on Rails 8.1.1
* 認証：devise
* 仮想環境：docker
* PaaS：Render
* データベース：PostgreSQL（Neon）
* UI：daisy UI（Tailwind CSS）
* JavaScript：Hotwire / Stimulus
* 位置情報：HTML5 Geolocation API
* 住所変換：Google Maps Geocoding API
* エラー監視：Sentry

## 検討
フロントをTypeScriptができればやりたい。
私の知見が浅いため学習コストとバランスがあうか考えたい。

## お願い
このアプリの目的は手入力を減らす業務改善が目的です。
ですが私自身の学習の為でもあります。
AIの役割は提案やアドバイス、コードレビューとなります。
バイブコーディングはしないでください。

## 概要
このアプリケーションは運転代行の営業で使用する情報を管理するためのWebアプリケーションです。
ドライバーはWebブラウザから運転記録の登録・閲覧・編集を行います。
管理者は全ドライバーの記録管理やマスタデータ（車両・店舗）の管理を行います。

## 前提条件
回答は日本語で行ってください。
データベースに記録する日時は``yyyy-MM-dd HH:mm:ss``（Rails標準のdatetime型）とする。
画面表示時は``yyyy/MM/dd HH:mm``形式でフォーマットする。
ユーザーが日時を指定するときは``yyyy/MM/dd HHmm``（入力）または``yyyy/MM/dd``とする。

## 引用
作成するにあたり、以下のドキュメントやWebページを参照すること。
* README.md アプリケーションの説明ファイル
* docs/database_schema.md データベース設計書（後述）
* docs/ui_design.md UI設計書（後述）

## データベース設計

### driversテーブル（ドライバー管理）
| カラム名 | 型 | 制約 | 説明 |
|---------|-----|------|------|
| id | bigint | PK | 主キー |
| email | string | NOT NULL, UNIQUE | メールアドレス（devise認証用） |
| encrypted_password | string | NOT NULL | 暗号化パスワード（devise） |
| name | string | NOT NULL | ドライバー名 |
| employee_number | string | UNIQUE | 社員番号（任意） |
| role | integer | NOT NULL, DEFAULT: 0 | 権限（0: driver, 1: admin） |
| created_at | datetime | NOT NULL | 作成日時 |
| updated_at | datetime | NOT NULL | 更新日時 |
| deleted_at | datetime | NULL | 削除日時（論理削除用、将来対応） |

### driving_recordsテーブル（運転記録）
| カラム名 | 型 | 制約 | 説明 |
|---------|-----|------|------|
| id | bigint | PK | 主キー |
| driver_id | bigint | FK, NOT NULL | ドライバーID（運転したドライバー） |
| vehicle_id | bigint | FK, NOT NULL | 車両ID |
| departed_at | datetime | NOT NULL | 出発日時 |
| departure_address | string | NULL | 出発地点（住所） |
| departure_latitude | decimal(10,6) | NULL | 出発地点（緯度） |
| departure_longitude | decimal(10,6) | NULL | 出発地点（経度） |
| store_id | bigint | FK, NULL | 店舗ID |
| store_name | string | NOT NULL | 店舗名（店舗未登録の場合は手入力） |
| customer_id | bigint | FK, NULL | 顧客ID（登録顧客の場合のみ） |
| waypoint_address | string | NULL | 経由地（住所） |
| waypoint_latitude | decimal(10,6) | NULL | 経由地（緯度） |
| waypoint_longitude | decimal(10,6) | NULL | 経由地（経度） |
| arrived_at | datetime | NOT NULL | 到着日時 |
| destination_address | string | NOT NULL | 目的地（住所） |
| destination_latitude | decimal(10,6) | NULL | 目的地（緯度） |
| destination_longitude | decimal(10,6) | NULL | 目的地（経度） |
| distance | decimal(8,2) | NOT NULL | 走行距離（km） |
| amount | integer | NOT NULL | 金額（円） |
| note | text | NULL | 備考 |
| created_by_id | bigint | FK, NOT NULL | 登録者ID |
| updated_by_id | bigint | FK, NULL | 更新者ID |
| exported_at | datetime | NULL | CSVエクスポート日時（将来対応） |
| created_at | datetime | NOT NULL | 作成日時 |
| updated_at | datetime | NOT NULL | 更新日時 |

### vehiclesテーブル（車両管理）
| カラム名 | 型 | 制約 | 説明 |
|---------|-----|------|------|
| id | bigint | PK | 主キー |
| vehicle_number | string | NOT NULL, UNIQUE | 車両番号 |
| vehicle_info | string | NULL | 車種名（例：プリウス） |
| created_at | datetime | NOT NULL | 作成日時 |
| updated_at | datetime | NOT NULL | 更新日時 |

### storesテーブル（店舗登録）
| カラム名 | 型 | 制約 | 説明 |
|---------|-----|------|------|
| id | bigint | PK | 主キー |
| name | string | NOT NULL, UNIQUE | 店舗名 |
| address | string | NOT NULL | 住所 |
| latitude | decimal(10,6) | NULL | 緯度 |
| longitude | decimal(10,6) | NULL | 経度 |
| usage_count | integer | DEFAULT: 0 | 使用回数（よく使う店舗の判定用） |
| created_at | datetime | NOT NULL | 作成日時 |
| updated_at | datetime | NOT NULL | 更新日時 |

### customersテーブル（顧客管理）
| カラム名 | 型 | 制約 | 説明 |
|---------|-----|------|------|
| id | bigint | PK | 主キー |
| name | string | NOT NULL | 顧客名 |
| phone_number | string | NULL | 電話番号 |
| address | string | NOT NULL | 住所 |
| latitude | decimal(10,6) | NULL | 緯度 |
| longitude | decimal(10,6) | NULL | 経度 |
| note | text | NULL | 備考（配慮事項、目印など） |
| usage_count | integer | DEFAULT: 0 | 利用回数 |
| last_used_at | datetime | NULL | 最終利用日時 |
| created_at | datetime | NOT NULL | 作成日時 |
| updated_at | datetime | NOT NULL | 更新日時 |

### daily_report_settingsテーブル（日報範囲設定）
| カラム名 | 型 | 制約 | 説明 |
|---------|-----|------|------|
| id | bigint | PK | 主キー（常に1件のみ） |
| start_hour | integer | NOT NULL, DEFAULT: 19 | 開始時刻（0-23） |
| end_hour | integer | NOT NULL, DEFAULT: 28 | 終了時刻（0-47、翌日対応） |
| created_at | datetime | NOT NULL | 作成日時 |
| updated_at | datetime | NOT NULL | 更新日時 |

## 認証・権限管理

### 認証方式
- devise gemを使用したメール/パスワード認証
- セッション管理（Rails標準のcookie_store）
- セッションタイムアウト：24時間
- HTTPS必須（Render本番環境）

### 権限設計
**管理者（admin）：**
- 全ての運転記録の閲覧・編集・削除
- ドライバー管理（追加・編集・削除）
- 車両管理（追加・編集・削除）
- 店舗管理（追加・編集・削除）
- 顧客管理（追加・編集・削除）
- 日報範囲設定の変更
- CSVエクスポート（警察署提出用・社内管理用）

**ドライバー（driver）：**
- 自分の運転記録の登録・閲覧・編集・削除
- 他人の運転記録の閲覧のみ（編集・削除不可）
- 日報の閲覧（全ドライバー）
- 車両・店舗・顧客の閲覧のみ
- 顧客の登録・編集（削除は管理者のみ）

### 初期ユーザー作成
- seeds.rbで管理者アカウントを作成
- 管理者が他のドライバーを招待・登録

## データ検証
### 必須項目
出発日時、店舗名、到着日時、目的地、走行距離、金額、車両番号

### 任意項目
出発地点、経由地、備考

### 入力形式の検証とエラー処理
- 日時形式（入力）：yyyy/MM/dd または yyyy/MM/dd HHmm 以外はエラー
- 日時形式（保存）：yyyy/MM/dd HH:mm に正規化して保存
- 数値（走行距離・金額）：数値以外はエラー
- 全角数字：半角に自動変換してから検証
- エラー時：「入力形式が正しくありません。もう一度入力してください。」とメッセージを返す

## 画面機能設計

### 1. 運転記録登録（新規）
**画面遷移：** ダッシュボード → 新規登録フォーム → 確認画面 → 完了

**入力項目：**
1. 出発地点（任意）
   - 「現在地取得」ボタン（HTML5 Geolocation API）
   - または手入力（テキストボックス）
   - 現在地取得時は緯度経度も保存

2. 店舗名（必須）
   - 登録済み店舗はドロップダウン表示（usage_count降順、よく使う店舗が上位）
   - 「新規店舗」を選択すると手入力フィールド表示
   - 登録済み店舗選択時は店舗名と住所が自動入力され、出発地点にも反映

3. 顧客名（任意）
   - 登録顧客はドロップダウン表示（usage_count降順、よく利用する顧客が上位）
   - 「顧客なし」「新規顧客」も選択可
   - 登録顧客選択時：
     - customer_idに紐付け
     - 顧客住所を目的地に自動入力（提案）
     - 「マップを開く」ボタン表示（ナビ用）
   - 「新規顧客」選択時：顧客登録画面へ遷移

4. 経由地（任意）
   - 「現在地取得」ボタン
   - または手入力

5. 到着日時（必須）
   - 「現在時刻」ボタン（クリックで現在時刻を自動入力）
   - または手入力（yyyy/MM/dd HHmm または yyyy/MM/dd）

6. 目的地（必須）
   - 「現在地取得」ボタン
   - または手入力

7. 走行距離（必須）
   - 数値入力（小数点第2位まで）
   - 単位：km

8. 金額（必須）
   - 数値入力（整数）
   - 単位：円

9. 車両番号（必須）
   - ドロップダウン（vehiclesテーブルから取得）
   - または手入力

10. 備考（任意）
    - テキストエリア

**確認画面：**
- 入力内容を一覧表示（カード形式、顧客名も表示）
- 「登録する」「修正する」ボタン
- 「登録する」クリック時：
  - データベースに保存
  - driver_idは現在ログイン中のユーザー
  - created_by_idも同様
  - 店舗を使用した場合、storesテーブルのusage_countを+1
  - 顧客を使用した場合、customersテーブルのusage_countを+1、last_used_atを更新
  - 「登録が完了しました」とフラッシュメッセージ表示
  - ダッシュボードへリダイレクト

### 2. 日報（運転記録一覧）
**画面構成：**
- 日付選択（カレンダーまたはプリセット：当日、昨日、3日前〜1週間前）
- 車両選択（全車両、または特定車両）
- ドライバー選択（管理者のみ：全員、または特定ドライバー）
- 絞り込み実行ボタン

**表示形式：**
- **スマホ：** カード形式で縦に並べる
- **PC：** テーブル形式

**表示内容：**
- 出発日時、出発地点、店舗名、顧客名（内部表示用）、経由地、到着日時、目的地、走行距離、金額、車両番号、ドライバー名、備考
- 各レコードに「編集」「削除」ボタン（権限に応じて表示）
- 顧客名のセルに「マップを開く」リンク（顧客が登録されている場合のみ）
- 最下部に合計行（走行距離合計、金額合計）

**該当データ0件の場合：**
- 「該当するデータがありません」と表示

### 3. 編集
**画面遷移：** 日報 → 編集フォーム → 確認画面 → 完了

**動作：**
- 日報から「編集」ボタンをクリック
- 新規登録と同じフォームで既存データを表示
- 入力・確認画面は新規と同様
- 更新時にupdated_by_idを更新

**権限チェック：**
- ドライバー：自分の記録のみ編集可
- 管理者：全ての記録を編集可

### 4. 削除
**動作：**
- 日報から「削除」ボタンをクリック
- 確認モーダル表示「以下のレコードを削除しますか？」
  - 削除対象の詳細（店舗名、出発日時、到着日時、金額など）を表示
  - 「削除する」「キャンセル」ボタン
- 「削除する」クリック時：
  - データベースから削除
  - 「削除が完了しました」とフラッシュメッセージ
  - 日報画面へリダイレクト

**権限チェック：**
- ドライバー：自分の記録のみ削除可
- 管理者：全ての記録を削除可

### 5. CSVエクスポート（管理者のみ）
**機能：**
- 日報画面に2つのエクスポートボタン表示（管理者のみ）
  1. 「警察署提出用CSV」
  2. 「社内管理用CSV」
- 現在の絞り込み条件でCSVダウンロード

**警察署提出用CSVのエクスポート項目：**
- 出発日時、出発地点、店舗名、経由地、到着日時、目的地、走行距離、金額、車両番号、備考
- **顧客名は含めない**

**社内管理用CSVのエクスポート項目：**
- 出発日時、出発地点、店舗名、顧客名、経由地、到着日時、目的地、走行距離、金額、車両番号、ドライバー名、備考
- **顧客名を含める**

**ファイル名：**
- 警察署提出用：`driving_records_police_YYYYMMDD.csv`
- 社内管理用：`driving_records_internal_YYYYMMDD.csv`

### 6. 現在地取得機能
**技術：**
- フロントエンド：HTML5 Geolocation API + Stimulus Controller
- バックエンド：Google Maps Geocoding API（座標→住所変換）

**動作フロー：**
1. 「現在地取得」ボタンをクリック
2. ブラウザが位置情報の許可を求める（初回のみ）
3. 許可されたら緯度経度を取得
4. Ajaxでサーバーに送信
5. サーバー側でGeocoding APIを使って住所に変換
6. フォームに住所を自動入力、hidden fieldに緯度経度も保存

**エラーハンドリング：**
- 位置情報が取得できない場合：「位置情報が取得できませんでした」とアラート表示
- Geocoding API失敗時：緯度経度のみ保存、住所は空

**対応項目：**
- 出発地点、経由地、目的地

### 7. 顧客管理
**アクセス権限：**
- 全ドライバーがアクセス可能
- 登録・編集：全ドライバー可
- 削除：管理者のみ

**一覧画面：**
- 表示項目：顧客名、電話番号、住所、利用回数、最終利用日
- ソート：usage_count降順（よく利用する顧客が上位）
- 検索機能：顧客名・電話番号・住所で部分一致検索
- 各行にボタン：
  - 「詳細」
  - 「編集」
  - 「削除」（管理者のみ）
  - 「マップを開く」

**詳細画面：**
- 顧客情報の表示（顧客名、電話番号、住所、備考、利用回数、最終利用日）
- 「マップを開く」ボタン（大きめに配置）
- この顧客の利用履歴（driving_recordsから抽出、日時降順）

**新規登録・編集画面：**
- 顧客名（必須）
- 電話番号（任意）
- 住所（必須）
  - 「現在地取得」ボタン
  - または手入力
  - 現在地取得時は緯度経度も保存
- 備考（任意、例：「2階建ての茶色い家」「犬がいる」など）

**マップアプリ連携：**
- 緯度経度がある場合：
  ```html
  <a href="https://www.google.com/maps/search/?api=1&query=緯度,経度"
     target="_blank" class="btn btn-primary">
    マップを開く
  </a>
  ```
- 住所のみの場合：
  ```html
  <a href="https://www.google.com/maps/search/?api=1&query=住所"
     target="_blank" class="btn btn-primary">
    マップを開く
  </a>
  ```
- 動作：
  - iPhone：Apple Mapsまたはデフォルトマップアプリで開く
  - Android：Google Mapsで開く
  - PC：ブラウザでGoogle Mapsが開く

### 8. 管理画面（管理者のみ）
**ドライバー管理：**
- 一覧、追加、編集、削除
- パスワードリセット

**車両管理：**
- 一覧、追加、編集、削除

**店舗管理：**
- 一覧、追加、編集、削除

**日報範囲設定：**
- 開始時刻・終了時刻の編集

## UI/UX設計

### レスポンシブデザイン
- **モバイルファースト設計**（主要デバイス：スマートフォン）
- daisyUI + Tailwind CSSのレスポンシブユーティリティを活用
- ブレークポイント：
  - sm: 640px（スマホ横）
  - md: 768px（タブレット）
  - lg: 1024px（PC）

### ナビゲーション
- **スマホ：** ハンバーガーメニュー
- **PC：** サイドバー

### メニュー構成
**ドライバー：**
- ダッシュボード
- 新規登録
- 日報
- 顧客管理
- ログアウト

**管理者：**
- ダッシュボード
- 新規登録
- 日報
- 顧客管理
- 管理（ドライバー、車両、店舗、設定）
- ログアウト

### カラーテーマ（daisyUI）
- 推奨テーマ：light / dark 切り替え対応
- プライマリカラー：任意（後で決定）

## エラーハンドリング

### データベースエラー
- 接続エラー：「データベースに接続できませんでした。しばらく経ってからお試しください。」
- 書き込みエラー：「データの保存に失敗しました。もう一度お試しください。」
- Railsのflashメッセージで表示

### Google Maps Geocoding APIエラー
- API失敗時：緯度経度のみ保存、住所は空
- ユーザーには「住所の自動取得に失敗しました。手入力してください。」と表示

### 入力形式エラー
- 日時形式：yyyy/MM/dd または yyyy/MM/dd HHmm 以外はエラー
- 数値（走行距離・金額）：数値以外はエラー
- 全角数字：半角に自動変換してから検証
- エラー時：フォーム下に赤文字で「入力形式が正しくありません」と表示（Rails標準バリデーション）

### 位置情報取得エラー
- 許可されなかった場合：「位置情報の取得が許可されませんでした」
- タイムアウト：「位置情報の取得がタイムアウトしました」
- その他：「位置情報を取得できませんでした」

### 権限エラー
- 他人のデータ編集時：「この操作は許可されていません」と表示し、リダイレクト

## 複数ドライバー対応
- 想定ユーザー数：2-5人
- deviseでユーザー識別（emailベース）
- 各ドライバーは独立して運転記録を登録・閲覧・編集可能
- 同時ログイン可能

## セキュリティ

### 本番環境（Render）
- HTTPS必須（位置情報取得の要件）
- 環境変数で秘匿情報管理：
  - `GOOGLE_MAPS_API_KEY`
  - `SECRET_KEY_BASE`
  - `DATABASE_URL`（PostgreSQL）

### CSRF保護
- Rails標準機能を使用

### パスワードポリシー
- 最低8文字
- 英数字混在推奨（deviseデフォルト）

## 開発環境構築

### Docker構成
- Ruby 3.4.5
- Rails 8.1.1
- PostgreSQL 15
- Node.js（Hotwire/Stimulus用）

### 必要なGem
- devise（認証）
- pg（PostgreSQL）
- geocoder または google-maps-services-ruby（Geocoding API）
- daisyui-rails または tailwindcss-rails
- hotwire-rails
- stimulus-rails
- sentry-ruby, sentry-rails（エラー監視）

### Development Commands

```bash
# Docker起動
docker-compose up -d

# Rails サーバー起動
bin/rails server

# マイグレーション実行
bin/rails db:migrate

# シード実行（初期管理者作成）
bin/rails db:seed

# テスト実行
bin/rails test
```

## デプロイ（Render）

### 必要な設定
- Build Command: `bundle install && bin/rails assets:precompile && bin/rails db:migrate`
- Start Command: `bin/rails server -b 0.0.0.0 -p $PORT`
- PostgreSQLデータベース接続

### 環境変数
- `GOOGLE_MAPS_API_KEY`
- `SECRET_KEY_BASE`
- `RAILS_ENV=production`
- `DATABASE_URL`（Neonから取得）
- `SENTRY_DSN`（Sentryから取得）

## 運用

### バックアップ戦略
- **Neon無料プラン**の自動バックアップ機能を使用
- 7日間保持
- ストレージ：0.5GB（十分）

### エラー監視
- **Sentry**を使用
- 無料プラン：月5,000エラーまで
- 本番環境でのエラーを自動検知・通知
- スタックトレース・ユーザー情報を記録

**設定：**
```ruby
# config/initializers/sentry.rb
Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = 0.5
  config.environment = Rails.env
end
```

### ログ管理
- Renderの標準ログ機能を使用
- 無料プラン：7日間保持
- Renderダッシュボードから確認可能

## 将来的な拡張機能（フェーズ2）

### MVPリリース後に実装予定

**1. 監査証跡（Audit Trail）**
- 編集履歴テーブル（audit_logs）の実装
- 誰が・いつ・何を変更したかを完全記録
- 変更内容の差分表示
- 削除されたデータの復元機能
- 対象：運転記録、顧客情報

**2. 売上集計機能（グラフ付き）**
- 期間指定での集計（日別・週別・月別）
- 車両別・ドライバー別の集計
- グラフ表示（Chart.js使用）
  - 棒グラフ：日別売上
  - 折れ線グラフ：走行距離推移
  - 円グラフ：ドライバー別割合
- 集計画面の実装

**3. 月次レポートPDF出力**
- 経理提出用PDFレポート生成
- カスタマイズ可能なテンプレート
- メール送信機能

**4. UX改善**
- 前回入力値のデフォルト表示
  - 車両番号、店舗名をセッションから自動選択
- プッシュ通知機能（コンポーネント化）
  - 登録完了通知
  - エラー通知
  - Web Push API使用
  - 用途に合わせて再利用可能な設計

**5. その他**
- ルート表示（地図上に出発地〜目的地を表示）
- 距離の自動計算（緯度経度から）
- 会計ソフト連携
- TypeScript化（学習コストとバランスを見て判断）

---

## UI/UXデザインシステム

### デザインコンセプト
**スマホファースト・レスポンシブデザイン（サイドバー＋ボトムナビのハイブリッド型）**

- **主要ユーザー**: ドライバー（スマホ）、管理者（PC/タブレット）
- **目的**: 各デバイスに最適化されたナビゲーションと操作性
- **実装**: daisyUI（Tailwind CSS） + Stimulus.js

### レスポンシブブレークポイント

```
- スマホ: 〜768px
- タブレット: 768px〜1024px
- PC: 1024px〜
```

### ナビゲーション設計

#### スマホ（〜768px）
- **トップバー**: シンプルなタイトルバー
- **ボトムナビゲーション**:
  - 固定位置（画面下部）
  - アイコン + ラベル
  - アクティブ状態のハイライト
  - メニュー項目: ホーム、記録、日報、管理（管理者のみ）/ログアウト
- **FAB（新規登録ボタン）**:
  - 右下固定（ボトムナビの上）
  - 円形の大きいボタン
  - プライマリカラー

#### タブレット/PC（768px〜）
- **左固定サイドバー**:
  - 幅: 256px（md）/ 288px（lg）
  - 背景: プライマリカラー
  - ユーザー情報表示（アバター + 名前 + 権限）
  - メニュー項目: アイコン + テキスト
  - 管理機能セクション（管理者のみ）
  - ログアウトボタン（下部固定）
- **メインコンテンツエリア**:
  - サイドバー分のオフセット（pl-64/lg:pl-72）
  - 広々としたスペーシング

### レイアウトパターン

#### ダッシュボード
- **ウェルカムカード**: グラデーション背景（primary → secondary）
- **統計情報**:
  - スマホ: 2カラムグリッド
  - PC: 4カラムグリッド
  - カードデザイン + ホバーエフェクト
- **下書き一覧**: 警告カラーの枠線 + 背景
- **最近の記録**:
  - スマホ: カード型（縦積み）
  - PC: テーブル型

#### 運転記録登録フォーム
- **スマホ**:
  - 戻るボタン付きヘッダー
  - コンパクトなパディング（p-3）
  - セクションごとにカード分割
  - 送信ボタンを画面下部に固定
- **PC**:
  - パンくずナビゲーション
  - 広いパディング（p-8）
  - max-width: 4xl（最大幅制限）

#### 運転記録一覧
- **スマホ**:
  - カード型表示
  - 重要情報を強調（出発→目的地、金額）
- **PC**:
  - テーブル型表示
  - ソート・フィルター機能
  - ホバーエフェクト

### カラーシステム（daisyUI カスタムテーマ）

```javascript
{
  light: {
    "primary": "#3b82f6",      // ブルー（メインアクション）
    "secondary": "#64748b",    // スレートグレー（サブ要素）
    "accent": "#06b6d4",       // シアン（強調）
    "neutral": "#1e293b",      // ダークスレート
    "base-100": "#ffffff",     // 背景（白）
    "base-200": "#f1f5f9",     // 背景（薄灰）
    "base-300": "#e2e8f0",     // ボーダー
    "info": "#0ea5e9",         // 情報
    "success": "#10b981",      // 成功
    "warning": "#f59e0b",      // 警告
    "error": "#ef4444",        // エラー
  }
}
```

### コンポーネントガイドライン

#### ボタン
- **プライマリ**: `btn btn-primary` - メインアクション
- **セカンダリ**: `btn btn-secondary` - サブアクション
- **ゴースト**: `btn btn-ghost` - キャンセル、戻る
- **サイズ**:
  - スマホ: `btn-lg`（重要アクション）
  - PC: `btn-md`（標準）

#### カード
- **標準**: `card bg-base-100 shadow-md`
- **ホバー**: `hover:shadow-lg transition-shadow`
- **パディング**:
  - スマホ: `p-4`
  - PC: `p-6`

#### スペーシング
- **コンテナ**:
  - スマホ: `p-3` or `p-4`
  - タブレット: `p-6`
  - PC: `p-8`
- **要素間**:
  - スマホ: `gap-3 mb-4`
  - PC: `gap-4 md:gap-6 mb-6 md:mb-8`

### アイコン設計
- **使用**: Heroicons（SVG inline）
- **サイズ**: `h-5 w-5`（標準）、`h-8 w-8`（FAB）
- **用途**: ナビゲーション、アクション、ステータス表示

### アニメーション
- **トランジション**: `transition-colors`, `transition-shadow`
- **ホバーエフェクト**: shadow elevation、背景色変更
- **控えめ**: 業務アプリのため過度なアニメーションは避ける

### アクセシビリティ
- **タッチターゲット**: 最小44x44px（スマホ）
- **片手操作**: 重要アクションを画面下部に配置
- **コントラスト**: WCAG AA準拠
- **フォーカス**: キーボードナビゲーション対応

### ビルドコマンド

```bash
# CSS（Tailwind + daisyUI）
yarn build:css

# JavaScript（Stimulus）
yarn build

# 両方
yarn build:css && yarn build
```

### 開発時の注意点
1. **レスポンシブクラス**: `md:` `lg:` プレフィックスを活用
2. **モバイルファースト**: 基本はスマホ向け、PCは拡張
3. **daisyUIコンポーネント**: 可能な限り活用（統一感）
4. **カスタムCSS**: 最小限に抑える（Tailwind優先）
