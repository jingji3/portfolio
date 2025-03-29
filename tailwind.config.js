/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/assets/stylesheets/**/*.{css,scss}',
    './app/views/**/*.{html,html.erb,erb}'
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
    require('daisyui')
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
