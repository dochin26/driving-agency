# モデルファイル生成

docs/database_schema.md のバリデーションルールを参照して、Railsのモデルファイルを生成してください。

## 要件

1. **バリデーション**
   - 必須項目の検証（presence: true）
   - ユニーク制約（uniqueness: true）
   - 形式検証（format, numericality）
   - カスタムバリデーション（出発日時 < 到着日時など）

2. **アソシエーション**
   - belongs_to、has_many を適切に設定
   - dependent: :destroy または :restrict_with_error
   - optional: true（NULLを許可する場合）

3. **スコープ**
   - よく使う検索条件をスコープ化
   - 例：最近の記録、期間指定、車両別など

4. **コールバック**
   - usage_count の更新
   - last_used_at の更新

5. **メソッド**
   - to_csvメソッド（CSVエクスポート用）
   - 表示用のヘルパーメソッド

## 出力形式

各モデルファイルをRails形式で生成してください。

例：
```ruby
class Driver < ApplicationRecord
  # devise
  devise :database_authenticatable, :rememberable, :validatable

  # enum
  enum role: { driver: 0, admin: 1 }

  # associations
  has_many :driving_records, dependent: :restrict_with_error
  has_many :created_records, class_name: 'DrivingRecord', foreign_key: 'created_by_id'

  # validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :employee_number, uniqueness: true, allow_blank: true

  # scopes
  scope :active, -> { where(deleted_at: nil) }
end
```
