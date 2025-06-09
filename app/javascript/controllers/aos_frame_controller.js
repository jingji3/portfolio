import { Controller } from "@hotwired/stimulus"
import AOS from 'aos'

export default class extends Controller {
  connect() {
    // 少し待ってからAOSを初期化
    setTimeout(() => {
      this.initAOS()
    }, 500)
  }

  initAOS() {
    AOS.refresh()
    AOS.init({
      duration: 600,
      once: true,
      offset: 50,
      disable: false,
      mirror: false
    })
  }
}
