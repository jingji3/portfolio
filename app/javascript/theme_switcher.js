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
      <i class="fas fa-sun text-xl"></i>
    `;
  } else {
    // ライトモード時に表示するアイコン（月）
    themeToggle.innerHTML = `
      <i class="fas fa-moon text-xl"></i>
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
