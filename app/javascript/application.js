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

// DOMContentLoaded時の初期化
document.addEventListener('DOMContentLoaded', function() {
  console.log('DOMContentLoaded: AOSを初期化中...')

  AOS.init({
    duration: 600,
    once: true,
    offset: 50,
    easing: 'ease-out'
  })

  console.log('AOS初期化完了')
})

// Turbo対応（ページ遷移時）
document.addEventListener('turbo:load', function() {
  console.log('turbo:load: AOSをリフレッシュ中...')

  // AOSをリフレッシュ
  if (typeof AOS !== 'undefined') {
    AOS.refresh()
    console.log('AOSリフレッシュ完了')
  }
})

// デバッグ用：AOSが読み込まれているか確認
console.log('AOS library loaded:', typeof AOS !== 'undefined')
