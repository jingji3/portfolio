import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "image", "container"]

  connect() {
    console.log("Character selector connected")
  }

  change(event) {
    const characterId = event.target.value
    if (!characterId) {
      this.containerTarget.classList.add("hidden")
      return
    }

    fetch(`/characters/${characterId}.json`)
      .then(response => response.json())
      .then(data => {
        this.imageTarget.src = data.character_img
        this.containerTarget.classList.remove("hidden")
      })
  }
}
