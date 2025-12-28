# ビューファイル生成

docs/wireframes.md のワイヤーフレームを参照して、daisyUIを使ったビューファイルを生成してください。

## 要件

1. **daisyUIコンポーネント使用**
   - ボタン: btn, btn-primary, btn-secondary
   - カード: card, card-body
   - フォーム: form-control, label, input, select
   - テーブル: table, table-zebra
   - モーダル: modal, modal-box

2. **レスポンシブ対応**
   - Tailwind CSSのブレークポイント使用
   - sm:, md:, lg: で表示切り替え

3. **Hotwire/Turbo対応**
   - data-turbo-method, data-turbo-confirm
   - Turbo Framesで部分更新

4. **フォームヘルパー**
   - form_with を使用
   - エラーメッセージ表示

5. **アクセシビリティ**
   - labelとinputの紐付け
   - aria-label の設定

## 出力形式

各ビューファイルをERB形式で生成してください。

例：
```erb
<%# app/views/driving_records/new.html.erb %>
<div class="container mx-auto px-4 py-8">
  <div class="max-w-2xl mx-auto">
    <h1 class="text-2xl font-bold mb-6">運転記録 新規登録</h1>

    <%= form_with model: @driving_record, local: true, class: "space-y-4" do |f| %>
      <div class="form-control">
        <%= f.label :store_name, "店舗名", class: "label" %>
        <%= f.select :store_id,
                     options_for_select(@stores.map { |s| [s.name, s.id] }),
                     { include_blank: "選択してください" },
                     class: "select select-bordered w-full" %>
      </div>

      <div class="form-control">
        <%= f.label :distance, "走行距離 (km)", class: "label" %>
        <%= f.number_field :distance,
                          step: 0.01,
                          class: "input input-bordered w-full" %>
      </div>

      <div class="flex gap-2">
        <%= f.submit "確認画面へ", class: "btn btn-primary flex-1" %>
        <%= link_to "キャンセル", root_path, class: "btn btn-ghost" %>
      </div>
    <% end %>
  </div>
</div>
```
