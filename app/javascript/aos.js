import AOS from 'aos'

// 初回ページ読み込み時のみ（非Turbo Frame）
document.addEventListener('DOMContentLoaded', function() {
  AOS.init({
    duration: 600,
    once: true,
    offset: 50,
    easing: 'ease-out'
  })
})
