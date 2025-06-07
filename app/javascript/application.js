import "@hotwired/turbo-rails"
import "./controllers"

// テーマ切り替え機能をインポート
import "./theme_switcher"

// コメント返信
import "./reply_comment"

// tomselectのインポート
import TomSelect from "tom-select"
window.TomSelect = TomSelect

// YouTube動画プレーヤーの時間を更新する関数
import "./controllers/youtube_start_controller.js"

// AOSライブラリのインポート
import AOS from 'aos'
import 'aos/dist/aos.css'

// AOS初期化関数
function initAOS() {
  AOS.init({
    duration: 600,
    once: true,
    offset: 50,
    easing: 'ease-out'
  })
}

// 初回ページ読み込み時
document.addEventListener('DOMContentLoaded', function() {
  initAOS()
})

// Turbo遷移時（重要！）
document.addEventListener('turbo:load', function() {
  AOS.refresh()

  setTimeout(() => {
    initAOS()
  }, 100)
})
