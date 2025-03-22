/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/assets/stylesheets/**/*.css',
    './app/views/**/*.{html,html.erb,erb}'
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
  }
}
