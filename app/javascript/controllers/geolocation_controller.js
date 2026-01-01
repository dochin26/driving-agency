import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["addressField", "latitudeField", "longitudeField", "button"]

  connect() {
    // 位置情報が利用可能かチェック
    if (!navigator.geolocation) {
      this.disableButton("位置情報が利用できません")
    }
  }

  getCurrentLocation(event) {
    event.preventDefault()

    const button = this.buttonTarget
    const originalText = button.textContent

    // ボタンを無効化してローディング表示
    button.disabled = true
    button.textContent = "取得中..."

    navigator.geolocation.getCurrentPosition(
      (position) => this.handleSuccess(position, button, originalText),
      (error) => this.handleError(error, button, originalText),
      {
        enableHighAccuracy: true,
        timeout: 10000,
        maximumAge: 0
      }
    )
  }

  async handleSuccess(position, button, originalText) {
    const latitude = position.coords.latitude
    const longitude = position.coords.longitude

    // 座標をフィールドに設定
    if (this.hasLatitudeFieldTarget) {
      this.latitudeFieldTarget.value = latitude
    }
    if (this.hasLongitudeFieldTarget) {
      this.longitudeFieldTarget.value = longitude
    }

    // 住所を取得
    try {
      const address = await this.reverseGeocode(latitude, longitude)
      if (address && this.hasAddressFieldTarget) {
        this.addressFieldTarget.value = address
      }

      button.disabled = false
      button.textContent = originalText

      // 成功フィードバック
      this.showFeedback(button, "success")
    } catch (error) {
      console.error("住所変換エラー:", error)
      button.disabled = false
      button.textContent = originalText

      // 座標は取得できたが住所変換に失敗
      if (this.hasAddressFieldTarget) {
        this.addressFieldTarget.value = `${latitude}, ${longitude}`
      }

      alert("住所の取得に失敗しました。座標を設定しました。")
    }
  }

  handleError(error, button, originalText) {
    button.disabled = false
    button.textContent = originalText

    let message = "位置情報の取得に失敗しました。"

    switch(error.code) {
      case error.PERMISSION_DENIED:
        message = "位置情報の使用が許可されていません。ブラウザの設定を確認してください。"
        break
      case error.POSITION_UNAVAILABLE:
        message = "位置情報が利用できません。"
        break
      case error.TIMEOUT:
        message = "位置情報の取得がタイムアウトしました。"
        break
    }

    alert(message)
  }

  async reverseGeocode(latitude, longitude) {
    const csrfToken = document.querySelector("[name='csrf-token']").content

    const response = await fetch("/api/geocoding/reverse_geocode", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({ latitude, longitude })
    })

    if (!response.ok) {
      throw new Error("Geocoding request failed")
    }

    const data = await response.json()
    return data.address
  }

  showFeedback(button, type) {
    const originalClass = button.className

    if (type === "success") {
      button.classList.remove("btn-primary")
      button.classList.add("btn-success")

      setTimeout(() => {
        button.className = originalClass
      }, 1000)
    }
  }

  disableButton(message) {
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = true
      this.buttonTarget.textContent = message
    }
  }
}
