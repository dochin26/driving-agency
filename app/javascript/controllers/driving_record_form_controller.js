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

  // 現在地取得（HTML5 Geolocation API）
  getCurrentLocation(event) {
    event.preventDefault()
    const target = event.target.dataset.target

    if (!navigator.geolocation) {
      alert("お使いのブラウザは位置情報に対応していません")
      return
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const lat = position.coords.latitude
        const lng = position.coords.longitude

        // 緯度経度をフォームに設定
        if (target === "departure") {
          document.querySelector('[name="driving_record[departure_latitude]"]').value = lat
          document.querySelector('[name="driving_record[departure_longitude]"]').value = lng
        } else if (target === "waypoint") {
          document.querySelector('[name="driving_record[waypoint_latitude]"]').value = lat
          document.querySelector('[name="driving_record[waypoint_longitude]"]').value = lng
        } else if (target === "destination") {
          document.querySelector('[name="driving_record[destination_latitude]"]').value = lat
          document.querySelector('[name="driving_record[destination_longitude]"]').value = lng
        }

        alert(`位置情報を取得しました (${lat.toFixed(6)}, ${lng.toFixed(6)})`)
      },
      (error) => {
        alert("位置情報の取得に失敗しました: " + error.message)
      }
    )
  }
}
