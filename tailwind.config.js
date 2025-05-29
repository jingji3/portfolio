/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/assets/stylesheets/**/*.{css,scss}',
    './app/views/**/*.{html,html.erb,erb}',
    './app/views/admin/**/*.erb',
  ],
  safelist: [
    { pattern: /alert-.*/ },
    { pattern: /btn-.*/ },
  ],
  darkMode: 'class',
  theme: {
    extend: {},
  },
  plugins: [
    require('daisyui'),
    require('@tailwindcss/line-clamp'),
  ],
  daisyui: {
    themes: ["light", "dark", "silk"],
    darkTheme: "dark",
    base: true,        // ベーススタイルを適用
    styled: true,      // コンポーネントのスタイルを適用
    utils: true,       // ユーティリティクラスを有効化
    themeRoot: ":root"
  }
}
