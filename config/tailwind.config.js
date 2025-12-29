const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('daisyui'),
  ],
  daisyui: {
    themes: [
      {
        light: {
          "primary": "#3b82f6",      // 落ち着いたブルー
          "secondary": "#64748b",    // スレートグレー
          "accent": "#06b6d4",       // シアン
          "neutral": "#1e293b",      // ダークスレート
          "base-100": "#ffffff",     // ホワイト
          "base-200": "#f1f5f9",     // ライトグレー
          "base-300": "#e2e8f0",     // グレー
          "info": "#0ea5e9",         // 情報ブルー
          "success": "#10b981",      // グリーン
          "warning": "#f59e0b",      // アンバー
          "error": "#ef4444",        // レッド
        },
      },
    ],
  },
}
