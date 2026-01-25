---
skill: responsive-design
description: レスポンシブデザイン（スマホファースト）でUIコンポーネントを作成・改善する
tags: [frontend, ui, tailwind, daisyui, responsive]
---

# レスポンシブデザインスキル

このスキルは、運転代行管理システムのレスポンシブUIを作成・改善するために使用します。

## デザインシステム

### コンセプト
**スマホファースト・レスポンシブデザイン（サイドバー＋ボトムナビのハイブリッド型）**

### ブレークポイント
```
- スマホ: 〜768px (デフォルト)
- タブレット: md (768px〜1024px)
- PC: lg (1024px〜)
```

## ナビゲーション構造

### スマホ
- トップバー（シンプル）
- ボトムナビゲーション（固定）
- FABボタン（新規登録）

### PC/タブレット
- 左固定サイドバー（256px / 288px）
- メインコンテンツエリア（サイドバー分オフセット）

## カラーシステム（daisyUI）

```javascript
primary: "#3b82f6"    // ブルー
secondary: "#64748b"  // スレートグレー
accent: "#06b6d4"     // シアン
base-100: "#ffffff"   // 白
base-200: "#f1f5f9"   // 薄灰
warning: "#f59e0b"    // 警告
error: "#ef4444"      // エラー
```

## コンポーネントパターン

### レイアウト
```erb
<!-- スマホ＋PC対応レイアウト -->
<div class="min-h-screen bg-base-200 pb-20 md:pb-0">
  <%= render "shared/navbar" %>

  <!-- FAB（スマホのみ） -->
  <%= link_to new_path, class: "btn btn-primary btn-circle btn-lg fixed bottom-20 right-4 md:hidden shadow-xl z-30" do %>
    <svg>...</svg>
  <% end %>

  <div class="p-4 md:p-6 lg:p-8">
    <div class="max-w-7xl mx-auto">
      <!-- コンテンツ -->
    </div>
  </div>
</div>
```

### カード
```erb
<!-- ホバーエフェクト付きカード -->
<div class="card bg-base-100 shadow-md hover:shadow-lg transition-shadow">
  <div class="card-body p-4 md:p-6">
    <h2 class="font-bold text-base md:text-lg">タイトル</h2>
    <!-- 内容 -->
  </div>
</div>
```

### グリッド（統計情報など）
```erb
<!-- 2カラム→4カラム -->
<div class="grid grid-cols-2 lg:grid-cols-4 gap-3 md:gap-4">
  <div class="card bg-base-100 shadow-md">...</div>
</div>
```

### レスポンシブ表示切り替え
```erb
<!-- スマホ：カード型 -->
<div class="space-y-3 md:hidden">
  <% records.each do |record| %>
    <div class="card bg-base-100 shadow-md">...</div>
  <% end %>
</div>

<!-- PC：テーブル型 -->
<div class="overflow-x-auto hidden md:block">
  <table class="table">...</table>
</div>
```

### ボタン
```erb
<!-- レスポンシブサイズ -->
<%= f.submit "登録", class: "btn btn-primary btn-lg md:btn-md" %>
```

## スペーシング

### コンテナ
```
スマホ: p-3 or p-4
タブレット: md:p-6
PC: lg:p-8
```

### 要素間
```
スマホ: gap-3 mb-4
PC: gap-4 md:gap-6 mb-6 md:mb-8
```

## 実装チェックリスト

新しいビューを作成する際は以下を確認：

- [ ] スマホファースト（基本スタイルはスマホ向け）
- [ ] `md:` `lg:` プレフィックスでPC対応
- [ ] FABボタン（新規登録系の画面）
- [ ] `pb-20 md:pb-0`（ボトムナビの余白）
- [ ] カードとテーブルの切り替え（一覧画面）
- [ ] レスポンシブパディング（p-4 md:p-6 lg:p-8）
- [ ] グリッドのカラム数調整（grid-cols-2 lg:grid-cols-4）
- [ ] フォントサイズ（text-sm md:text-base）

## ビルドコマンド

デザイン変更後は必ずビルド：

```bash
yarn build:css && yarn build
```

## 参考ファイル

- `app/views/shared/_sidebar.html.erb` - サイドバー
- `app/views/shared/_navbar.html.erb` - トップバー＋ボトムナビ
- `app/views/dashboard/index.html.erb` - ダッシュボード例
- `app/views/driving_records/new.html.erb` - フォーム例
- `app/views/driving_records/index.html.erb` - 一覧例
- `config/tailwind.config.js` - Tailwind設定
