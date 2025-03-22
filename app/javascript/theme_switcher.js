document.addEventListener("turbo:load", initTheme);
document.addEventListener("DOMContentLoaded", initTheme);

function initTheme() {
  // テーマの初期化
  const savedTheme = localStorage.getItem("theme") ||
                     (window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light");

  // テーマを適用
  applyTheme(savedTheme);

  // 初回のみローカルストレージに保存
  if (!localStorage.getItem("theme")) {
    localStorage.setItem("theme", savedTheme);
  }

  // ボタンにイベントリスナーを追加
  const themeToggle = document.getElementById("theme-toggle");
  if (themeToggle) {
    // 既存のイベントリスナーをクリア（重複防止）
    themeToggle.onclick = null;

    // 新しいイベントリスナーを追加
    themeToggle.onclick = function() {
      const currentTheme = document.documentElement.getAttribute("data-theme");
      const newTheme = currentTheme === "light" ? "dark" : "light";
      applyTheme(newTheme);
      localStorage.setItem("theme", newTheme);
    };
  }
}

function applyTheme(theme) {
  // HTML要素にdata-theme属性を設定
  document.documentElement.setAttribute("data-theme", theme);

  // Tailwindのダークモードクラスを設定
  if (theme === "dark") {
    document.documentElement.classList.add("dark");
  } else {
    document.documentElement.classList.remove("dark");
  }

  // アイコンを更新
  updateThemeIcon(theme);
}

function updateThemeIcon(theme) {
  const themeToggle = document.getElementById("theme-toggle");
  if (!themeToggle) return;

  // 現在のテーマに基づいてアイコンを設定
  if (theme === "dark") {
    // ダークモード時に表示するアイコン（太陽）
    themeToggle.innerHTML = `
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" style="width: 1.5rem; height: 1.5rem;">
        <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v2.25m6.364.386l-1.591 1.591M21 12h-2.25m-.386 6.364l-1.591-1.591M12 18.75V21m-4.773-4.227l-1.591 1.591M5.25 12H3m4.227-4.773L5.636 5.636M15.75 12a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0z" />
      </svg>
    `;
  } else {
    // ライトモード時に表示するアイコン（月）
    themeToggle.innerHTML = `
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" style="width: 1.5rem; height: 1.5rem;">
        <path stroke-linecap="round" stroke-linejoin="round" d="M21.752 15.002A9.718 9.718 0 0118 15.75c-5.385 0-9.75-4.365-9.75-9.75 0-1.33.266-2.597.748-3.752A9.753 9.753 0 003 11.25C3 16.635 7.365 21 12.75 21a9.753 9.753 0 009.002-5.998z" />
      </svg>
    `;
  }
}

// システムのダークモード設定が変更された時の処理
window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", (e) => {
  // ユーザーが明示的に設定していない場合のみシステム設定に従う
  if (!localStorage.getItem("theme")) {
    applyTheme(e.matches ? "dark" : "light");
  }
});
