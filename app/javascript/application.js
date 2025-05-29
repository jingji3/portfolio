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
