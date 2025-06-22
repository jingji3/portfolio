import { Controller } from "@hotwired/stimulus"
/**
 * 【目的】
 * キャラクター選択機能を提供するStimulusコントローラー
 * - Tom-Selectの選択ボックスを定義
 * - 複数フィールド（日本語名、カナ、英語名）での検索
 * - キャラクター画像の動的表示
 * - 同じキャラクターの重複選択防止
 */

export default class extends Controller {
  static targets = ["select", "image", "container"]
  static values = { characters: Array } // キャラクター情報を配列で受け取る

  connect() {
    // Tom Selectを初期化(tom-selectで検索できるようにする)
    this.initializeSelect()

    // 初期値がある場合にキャラクター画像をロード
    if (this.selectTarget.value && this.selectTarget.value !== '') {
      this.loadCharacterImage(this.selectTarget.value)
    }

    // 少し遅延させてから重複防止処理も実行（他の選択欄の初期化完了を待つ）
    setTimeout(() => {
      this.updateAllSelects()
    }, 100)
  }

  // Tom-Selectライブラリを使用して選択ボックスをリッチにするためのメソッド
  initializeSelect() {
    // 現在の選択値を保存（検索後も選択状態を維持するため）
    const currentValue = this.selectTarget.value;
    // Tom-Selectを初期化（通常の<select>をtom-select選択ボックスに変換）
    const tomSelect = new TomSelect(this.selectTarget, {
      create: false,
      maxOptions: null,                 //　表示数に制限を設けない
      sortField: {
        field: "text",
        direction: "asc"
      },
      searchField: ["searchable_name"], // 検索対象フィールドを指定(日本語名、カナ、英語名検索を可能にしたキャラクター情報を使用)
      options: []                       // 初期オプションは空にしておく(後で追加する)
    });

    // オプションをクリアしてから、キャラクター情報を追加
    tomSelect.clearOptions();

    // キャラクター情報をオプションとして追加
    this.charactersValue.forEach(character => {
      tomSelect.addOption({
        value: character.id,                       // キャラクターIDをvalueに設定
        text: character.name,                      // 表示名は日本語名
        searchable_name: character.searchable_name // 検索用の名前（日本語名、カナ、英語名を結合したもの）
      });
    });

    // もしvalueがあれば、選択状態のままにする
    if (currentValue && currentValue !== '') {
      tomSelect.setValue(currentValue, true);
    }
  }

  // キャラクター選択欄の値が変更されたときのイベントハンドラ
  change(event) {
    const characterId = event.target.value
    if (!characterId) {
      // 選択が解除された場合はhiddenを追加して画像を非表示にする
      this.containerTarget.classList.add("hidden")
    } else {
      // ①選択されたキャラクターIDに基づいて画像をロード
      this.loadCharacterImage(characterId)
    }
    // ②他の選択欄でのキャラクター重複防止のため、選択一覧更新を行う
    this.updateAllSelects()
  }

  // ②他の選択欄でのキャラクター重複防止のため、選択一覧更新を行うソッド
  updateAllSelects() {
    // 全ての選択欄の値を取得
    const allSelects = document.querySelectorAll('[data-character-selector-target="select"]')
    const selectedValues = Array.from(allSelects)
      .map(select => select.value)
      .filter(value => value !== '')

    // 各選択欄を処理
    allSelects.forEach(select => {
      if (select.tomselect) {
        // まず全て記入欄でキャラクター情報を復元
        this.charactersValue.forEach(character => {
          if (!select.tomselect.options[character.id]) {
            select.tomselect.addOption({
              value: character.id,
              text: character.name,
              searchable_name: character.searchable_name
            });
          }
        });
        // その後、他の選択欄で選択済みのオプションを削除（自分以外）
        selectedValues.forEach(selectedValue => {
          if (selectedValue !== select.value) {
            select.tomselect.removeOption(selectedValue)
          }
        })
      }
    })
  }

  // ①選択されたキャラクターIDに基づいて画像をロードするメソッド
  loadCharacterImage(characterId) {
    // キャラ情報をJSON形式で取得（ダメならエラー）
    fetch(`/characters/${characterId}.json`)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`)
        }
        return response.json()
      })
      .then(data => {
        // 成功時はhiddenを削除して画像を表示
        this.imageTarget.src = data.character_img
        this.containerTarget.classList.remove("hidden")
      })
      .catch(error => {
        // エラー時は画像を非表示にし、コンソールにエラーメッセージを表示
        this.containerTarget.classList.add("hidden")
        console.error(`Error loading character image: ${error.message}`)
      })
  }
}
