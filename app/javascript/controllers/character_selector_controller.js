import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "image", "container"]

  connect() {
    console.log("Character selector connected", this.element)

    // 初期値がある場合のみ処理
    if (this.selectTarget.value && this.selectTarget.value !== '') {
      console.log("Loading initial character from value:", this.selectTarget.value)
      this.loadCharacterImage(this.selectTarget.value)
    }
  }

  change(event) {
    const characterId = event.target.value
    if (!characterId) {
      this.containerTarget.classList.add("hidden")
      return
    }

    this.loadCharacterImage(characterId)
  }

  loadCharacterImage(characterId) {
    console.log("Fetching character:", characterId)
    fetch(`/characters/${characterId}.json`)
      .then(response => {
        console.log("Response status:", response.status)
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`)
        }
        return response.json()
      })
      .then(data => {
        console.log("Character data received:", data)
        this.imageTarget.src = data.character_img
        this.containerTarget.classList.remove("hidden")
      })
      .catch(error => {
        console.error("Error loading character image:", error)
        this.containerTarget.classList.add("hidden")
      })
  }
}
