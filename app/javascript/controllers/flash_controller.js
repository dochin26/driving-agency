import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    duration: { type: Number, default: 3000 }
  }

  connect() {
    setTimeout(() => {
      this.element.remove()
    }, this.durationValue)
  }
}
