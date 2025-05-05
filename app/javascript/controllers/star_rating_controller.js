import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "display", "rating"]

  connect() {
    // 初期値の設定
    const initialValue = this.inputTarget.value || 0
    this.updateDisplay(initialValue)
  }

  // 星をクリックした時の処理
  selectRating(event) {
    const target = event.currentTarget
    let value = parseFloat(target.dataset.value)

    // 同じ値をクリックした場合は値をリセット
    if (parseFloat(this.inputTarget.value) === value) {
      value = 0
    }

    // 入力値の更新
    this.inputTarget.value = value
    this.updateDisplay(value)
  }
  
  // 星の半分をクリックした時の処理
  selectHalfRating(event) {
    event.stopPropagation() //親要素へのイベントを防止

    const parent = event.currentTarget.closest('.star-input-item')
    let value = parseFloat(parent.dataset.value) - 0.5

    // 同じ値を再度クリックした場合は値をリセット
    if (parseFloat(this.inputTarget.value) == value) {
      value = 0
    }

    // 入力値の更新
    this.inputTarget.value = value
    this.updateDisplay(value)
  }

  // 表示の更新
  updateDisplay(value) {
    console.log("updateDisplay called with value:", value);
    
    // 数値表示の更新
    if (this.hasDisplayTarget) {
      this.displayTarget.textContent = parseFloat(value).toFixed(1);
    }
    
    // 入力用星の更新
    const starItems = this.element.querySelectorAll('.star-input-item');
    
    // すべての星をリセット（重要：既存の状態をクリア）
    starItems.forEach(item => {
      item.classList.remove('active', 'half-active');
    });
    
    // 現在の値に基づいて星を塗りつぶす
    starItems.forEach((item, index) => {
      const itemValue = parseFloat(item.dataset.value);
      const fullStarValue = Math.floor(value);
      const hasHalfStar = (value % 1) >= 0.5;
      
      // 整数部分までの星を完全に塗りつぶす
      if (itemValue <= fullStarValue) {
        item.classList.add('active');
      } 
      // 半端な部分（0.5）があれば、次の星を半分だけ塗りつぶす
      else if (hasHalfStar && itemValue === fullStarValue + 1) {
        item.classList.add('half-active');
      }
    });
    
    // 評価表示用星の更新（星のクラスを設定）
    if (this.hasRatingTarget) {
      // すべてのstar-*クラスを削除
      const classNames = this.ratingTarget.className.split(' ').filter(c => !c.startsWith('star-'));
      this.ratingTarget.className = classNames.join(' ');
      
      // 現在の評価値に応じたクラスを追加
      const ratingClass = `star-${value.toString().replace('.', '-')}`;
      this.ratingTarget.classList.add(ratingClass);
    }
  }
}
