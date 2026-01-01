import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["storeSelect", "departureLocation", "customerSelect", "destination"]

  connect() {
    console.log("Driving record form controller connected")
  }

  // 店舗選択時に出発地点を自動入力
  updateDepartureLocation() {
    const selectedOption = this.storeSelectTarget.selectedOptions[0]
    if (selectedOption && selectedOption.dataset.address) {
      this.departureLocationTarget.value = selectedOption.dataset.address
    }
  }

  // 顧客選択時に目的地を自動入力
  updateDestination() {
    const selectedOption = this.customerSelectTarget.selectedOptions[0]
    if (selectedOption && selectedOption.dataset.address) {
      this.destinationTarget.value = selectedOption.dataset.address
    }
  }
}
