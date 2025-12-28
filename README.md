# 運転代行管理システム

運転代行業務で使用する情報を管理するWebアプリケーションです。ドライバーはスマートフォンやPCから運転記録の登録・閲覧・編集を行い、管理者は全ドライバーの記録管理やマスタデータの管理を行います。

## 目的

- **手入力を減らす業務改善**：現在地取得機能やマスタデータ活用で入力負担を軽減
- **記録の一元管理**：運転記録・顧客情報・車両情報を統合管理
- **警察署提出用の日報作成**：必要な情報を簡単にCSVエクスポート

## 主な機能

### ドライバー機能
- ✅ 運転記録の登録・編集・削除
- 📍 現在地取得機能（GPS連携）
- 👥 顧客管理（よく利用する顧客の情報を登録）
- 🗺️ マップアプリ連携（顧客宅へのナビゲーション）
- 📊 日報閲覧（日付・車両で絞り込み）

### 管理者機能
- 👨‍💼 ドライバー管理
- 🚗 車両管理
- 🏪 店舗管理
- 📥 CSVエクスポート（警察署提出用・社内管理用）
- ⚙️ 日報範囲設定（営業時間の設定）

## 技術スタック

### バックエンド
- **言語**: Ruby 3.4.5
- **フレームワーク**: Ruby on Rails 8.1.1
- **認証**: devise
- **データベース**: PostgreSQL 15（Neon）

### フロントエンド
- **UI**: daisyUI（Tailwind CSS）
- **JavaScript**: Hotwire / Stimulus
- **位置情報**: HTML5 Geolocation API
- **住所変換**: Google Maps Geocoding API

### インフラ
- **仮想環境**: Docker / Docker Compose
- **PaaS**: Render
- **エラー監視**: Sentry

## セットアップ

### 必要な環境
- Docker Desktop
- Git

### 1. リポジトリのクローン

```bash
git clone https://github.com/dochin26/driving-agency.git
cd driving-agency
```

### 2. 環境変数の設定

`.env.example` をコピーして `.env` を作成：

```bash
cp .env.example .env
```

`.env` を編集して以下の値を設定：

```env
# データベース（Neon）
DATABASE_URL=postgresql://username:password@host/database

# Google Maps API
GOOGLE_MAPS_API_KEY=your_api_key_here

# Sentry（オプション）
SENTRY_DSN=your_sentry_dsn_here

# Rails
SECRET_KEY_BASE=your_secret_key_here
```

### 3. Dockerコンテナの起動

```bash
# コンテナをビルド・起動
docker-compose up -d

# データベース作成
docker-compose exec web bin/rails db:create

# マイグレーション実行
docker-compose exec web bin/rails db:migrate

# 初期データ投入
docker-compose exec web bin/rails db:seed
```

### 4. アプリケーションへアクセス

ブラウザで [http://localhost:3000](http://localhost:3000) を開きます。

### 初期ログイン情報

```
メールアドレス: admin@example.com
パスワード: password
```

**⚠️ 本番環境では必ずパスワードを変更してください**

## 開発コマンド

### Docker環境

```bash
# コンテナ起動
docker-compose up -d

# コンテナ停止
docker-compose down

# ログ確認
docker-compose logs -f web

# コンソール起動
docker-compose exec web bin/rails console

# テスト実行
docker-compose exec web bin/rails test

# コンテナ内でコマンド実行
docker-compose exec web [コマンド]
```

### データベース

```bash
# マイグレーション作成
docker-compose exec web bin/rails generate migration MigrationName

# マイグレーション実行
docker-compose exec web bin/rails db:migrate

# ロールバック
docker-compose exec web bin/rails db:rollback

# データベースリセット（開発環境のみ）
docker-compose exec web bin/rails db:reset
```

### コード生成

```bash
# モデル生成
docker-compose exec web bin/rails generate model ModelName

# コントローラー生成
docker-compose exec web bin/rails generate controller ControllerName

# スキャフォールド生成
docker-compose exec web bin/rails generate scaffold ResourceName
```

## プロジェクト構成

```
driving-agency/
├── app/
│   ├── controllers/      # コントローラー
│   ├── models/           # モデル
│   ├── views/            # ビュー（ERBテンプレート）
│   ├── javascript/       # Stimulus コントローラー
│   └── assets/           # CSS、画像
├── config/
│   ├── routes.rb         # ルーティング
│   ├── database.yml      # DB設定
│   └── initializers/     # 初期化設定
├── db/
│   ├── migrate/          # マイグレーションファイル
│   └── seeds.rb          # 初期データ
├── docs/                 # ドキュメント
│   ├── database_schema.md    # データベース設計書
│   ├── screen_design.md      # 画面設計書
│   └── wireframes.md         # ワイヤーフレーム
├── .claude/              # Claude Skills
│   └── skills/
├── docker-compose.yml    # Docker設定
├── Dockerfile
├── CLAUDE.md             # 要件定義書
└── README.md             # このファイル
```

## データベース設計

詳細は [docs/database_schema.md](docs/database_schema.md) を参照してください。

### 主要テーブル

- **drivers**: ドライバー情報（認証・権限管理）
- **vehicles**: 車両情報
- **stores**: 店舗情報
- **customers**: 顧客情報
- **driving_records**: 運転記録
- **daily_report_settings**: 日報範囲設定

### ER図
<img width="12006" height="8137" alt="driving-agency-er" src="https://github.com/user-attachments/assets/4dd10fad-f4a9-4a0a-b06d-e97440b72f5e" />

## 画面設計

詳細は以下のドキュメントを参照してください：
- [画面設計書](docs/screen_design.md)
- [ワイヤーフレーム](docs/wireframes.md)

### 主要画面

1. **ダッシュボード**: 本日の統計・最近の運転記録
2. **運転記録登録**: 現在地取得・顧客選択機能付き
3. **日報**: 日付・車両・ドライバーで絞り込み
4. **顧客管理**: 顧客情報・利用履歴・マップ連携
5. **管理画面**: ドライバー・車両・店舗管理（管理者のみ）

## 権限管理

### ドライバー（driver）
- 自分の運転記録の登録・閲覧・編集・削除
- 他人の運転記録の閲覧のみ
- 顧客の登録・編集（削除は管理者のみ）

### 管理者（admin）
- 全ての運転記録の閲覧・編集・削除
- ドライバー管理
- 車両・店舗・顧客管理
- CSVエクスポート

## デプロイ（Render）

### 1. Renderアカウント作成
[https://render.com](https://render.com) でアカウント作成

### 2. PostgreSQLデータベース作成（Neon使用）
[https://neon.tech](https://neon.tech) でデータベース作成し、DATABASE_URLを取得

### 3. Web Serviceの作成

**Build Command:**
```bash
bundle install && bin/rails assets:precompile && bin/rails db:migrate
```

**Start Command:**
```bash
bin/rails server -b 0.0.0.0 -p $PORT
```

### 4. 環境変数の設定

Renderのダッシュボードで以下を設定：
- `DATABASE_URL`: NeonのPostgreSQL接続URL
- `SECRET_KEY_BASE`: `bin/rails secret` で生成
- `RAILS_ENV`: `production`
- `GOOGLE_MAPS_API_KEY`: Google Maps APIキー
- `SENTRY_DSN`: SentryのDSN（オプション）

### 5. デプロイ

GitHubリポジトリと連携し、自動デプロイを設定。

## トラブルシューティング

### データベース接続エラー

```bash
# DATABASE_URLが正しく設定されているか確認
docker-compose exec web bin/rails runner "puts ENV['DATABASE_URL']"

# データベースが起動しているか確認
docker-compose ps
```

### アセットが読み込めない

```bash
# アセットをプリコンパイル
docker-compose exec web bin/rails assets:precompile
```

### マイグレーションエラー

```bash
# マイグレーション状態を確認
docker-compose exec web bin/rails db:migrate:status

# ロールバックして再実行
docker-compose exec web bin/rails db:rollback
docker-compose exec web bin/rails db:migrate
```

### Dockerコンテナが起動しない

```bash
# ログを確認
docker-compose logs web
docker-compose logs db

# コンテナを再ビルド
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## テスト

```bash
# 全テスト実行
docker-compose exec web bin/rails test

# 特定のテストファイル実行
docker-compose exec web bin/rails test test/models/driver_test.rb

# カバレッジ確認（SimpleCov使用）
docker-compose exec web bin/rails test
# coverage/index.html を確認
```

## Claude Skills

このプロジェクトは開発効率化のためのClaude Skillsを含んでいます。

`.claude/skills/` ディレクトリ内のスキル：
- `review-requirements`: 要件定義レビュー
- `generate-migration`: マイグレーションファイル生成
- `generate-model`: モデルファイル生成
- `generate-controller`: コントローラー生成
- `generate-view`: ビューファイル生成
- `setup-docker`: Docker環境構築
- `review-code`: コードレビュー
- `explain-rails`: Rails概念の説明
- `debug-help`: デバッグ支援
- `suggest-next-step`: 次のステップ提案

使い方：
```
/skill suggest-next-step
```

## 将来的な拡張機能（フェーズ2）

- 📝 監査証跡（編集履歴テーブル）
- 📊 売上集計機能（グラフ付き）
- 📄 月次レポートPDF出力
- 💡 前回入力値のデフォルト表示
- 🔔 プッシュ通知（コンポーネント化）
- 🗺️ ルート表示（地図上に出発地〜目的地を表示）
- 📏 距離の自動計算（緯度経度から）
- 💼 会計ソフト連携
- 📝 TypeScript化（学習コストとバランスを見て判断）

## ライセンス

このプロジェクトは個人利用・学習目的で作成されています。

## 貢献

Issue や Pull Request を歓迎します。

## 作者

[@dochin26](https://github.com/dochin26)

## 参考ドキュメント

- [要件定義書（CLAUDE.md）](CLAUDE.md)
- [データベース設計書](docs/database_schema.md)
- [画面設計書](docs/screen_design.md)
- [ワイヤーフレーム](docs/wireframes.md)
- [Rails Guides（日本語）](https://railsguides.jp/)
- [daisyUI公式ドキュメント](https://daisyui.com/)
- [Hotwire公式ドキュメント](https://hotwired.dev/)

## サポート

質問や問題がある場合は、Issueを作成してください。
