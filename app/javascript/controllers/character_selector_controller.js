import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "image", "container"]

  connect() {
    // Tom Selectを初期化
    this.initializeSelect()

    // 初期値がある場合のみ処理
    if (this.selectTarget.value && this.selectTarget.value !== '') {
      this.loadCharacterImage(this.selectTarget.value)
    }
  }

  initializeSelect() {
    new TomSelect(this.selectTarget, {
      create: false,
      maxOptions: null,
      language: {
        noresults: "該当なし"
      },
      sortField: {
        field: "text",
        direction: "asc"
      }
    });
  }

  change(event) {
    const characterId = event.target.value
    if (!characterId) {
      this.containerTarget.classList.add("hidden")
    } else {
      this.loadCharacterImage(characterId)
    }

    this.updateAllSelects()
  }

  // 他の選択欄でキャラ選択を絞るメソッド
  updateAllSelects() {
    // 全ての選択欄の値を取得
    const allSelects = document.querySelectorAll('[data-character-selector-target="select"]')
    const selectedValues = Array.from(allSelects)
      .map(select => select.value)
      .filter(value => value !== '')

    // 各選択欄を処理
    allSelects.forEach(select => {
      if (select.tomselect) {
        // 選択済みのオプションを削除
        selectedValues.forEach(selectedValue => {
          if (selectedValue !== select.value) {
            select.tomselect.removeOption(selectedValue)
          }
        })
      }
    })
  }

  loadCharacterImage(characterId) {
    fetch(`/characters/${characterId}.json`)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`)
        }
        return response.json()
      })
      .then(data => {
        this.imageTarget.src = data.character_img
        this.containerTarget.classList.remove("hidden")
      })
      .catch(error => {
        this.containerTarget.classList.add("hidden")
      })
  }
}
