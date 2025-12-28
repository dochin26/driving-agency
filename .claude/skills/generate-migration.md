# マイグレーションファイル生成

docs/database_schema.md を参照して、Railsのマイグレーションファイルを生成してください。

## 要件

1. **テーブル作成順序**
   - 外部キー依存を考慮した順序で生成
   - drivers → vehicles → stores → customers → driving_records → daily_report_settings

2. **カラム定義**
   - データ型を正確に指定
   - NOT NULL、UNIQUE、DEFAULT値を設定
   - インデックスを追加

3. **外部キー制約**
   - ON DELETE、ON UPDATE を適切に設定
   - RESTRICT、SET NULL、CASCADEを使い分け

4. **CHECK制約**
   - PostgreSQL特有のCHECK制約を追加
   - 緯度経度の範囲チェック
   - 出発日時 < 到着日時のチェック

5. **コメント**
   - 各カラムに日本語コメントを追加（t.comment）

## 出力形式

各テーブルのマイグレーションファイルをRails形式で生成してください。

例：
```ruby
class CreateDrivers < ActiveRecord::Migration[8.0]
  def change
    create_table :drivers do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :encrypted_password, null: false
      # ...
      t.timestamps
    end
  end
end
```
