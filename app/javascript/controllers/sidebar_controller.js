import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    // ページ読み込み時：保存された状態を復元
    this.restoreSidebarState()
  }

  toggle() {
    // ハンバーガーメニューがクリックされた時の処理

    // 1. 必要な要素を取得
    const sidebar = document.querySelector('aside')
    const mainContent = document.querySelector('.lg\\:ml-52, .lg\\:ml-16')

    // 2. 要素が見つからない場合は処理を中止
    if (!sidebar || !mainContent) return

    // 3. 現在の状態を確認
    const isCurrentlyCollapsed = sidebar.classList.contains('w-16')

    if (isCurrentlyCollapsed) {
      // 現在縮小状態 → 展開する
      this.expandSidebar(sidebar, mainContent)
      this.saveState('expanded')
    } else {
      // 現在展開状態 → 縮小する
      this.collapseSidebar(sidebar, mainContent)
      this.saveState('collapsed')
    }
  }

  // サイドバーを縮小する
  collapseSidebar(sidebar, mainContent) {
    // サイドバーの幅を小さく
    sidebar.classList.remove('w-52')
    sidebar.classList.add('w-16')

    // メインコンテンツのマージンを調整
    mainContent.classList.remove('lg:ml-52')
    mainContent.classList.add('lg:ml-16')

    // 縮小版のHTMLを読み込み
    this.loadSidebarContent('mini')
  }

  // サイドバーを展開する
  expandSidebar(sidebar, mainContent) {
    // サイドバーの幅を大きく
    sidebar.classList.remove('w-16')
    sidebar.classList.add('w-52')

    // メインコンテンツのマージンを調整
    mainContent.classList.remove('lg:ml-16')
    mainContent.classList.add('lg:ml-52')

    // 通常版のHTMLを読み込み
    this.loadSidebarContent('full')
  }

  // サイドバーのHTMLを読み込む
  loadSidebarContent(type) {
    const sidebarContainer = document.querySelector('[data-sidebar-target="sidebar"]')

    if (!sidebarContainer) return

    // サーバーからHTMLを取得
    const url = type === 'mini' ? '/sidebar_mini' : '/sidebar_full'

    fetch(url)
      .then(response => {
        if (!response.ok) {
          throw new Error('サーバーからの応答がエラーでした')
        }
        return response.text()
      })
      .then(html => {
        // 取得したHTMLを画面に表示
        sidebarContainer.innerHTML = html
      })
      .catch(error => {
        console.error('サイドバーの読み込みに失敗しました:', error)
      })
  }

  // 状態をブラウザに保存
  saveState(state) {
    // localStorage: ブラウザを閉じても残る
    localStorage.setItem('sidebarState', state)

    // Cookie: サーバーサイドでも読み取れる 3日間
    document.cookie = `sidebar_collapsed=${state === 'collapsed'}; path=/; max-age=259200`
  }

  // 保存された状態を復元
  restoreSidebarState() {
    // 保存された状態を取得
    const savedState = localStorage.getItem('sidebarState')

    // 保存された状態がない場合は何もしない（デフォルト：展開状態）
    if (!savedState) return

    // 縮小状態で保存されていた場合のみ復元
    if (savedState === 'collapsed') {
      const sidebar = document.querySelector('aside')
      const mainContent = document.querySelector('.lg\\:ml-52, .lg\\:ml-16')

      if (sidebar && mainContent) {
        this.collapseSidebar(sidebar, mainContent)
      }
    }
  }
}
