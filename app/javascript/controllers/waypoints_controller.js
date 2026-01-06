import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]
  static values = {
    count: { type: Number, default: 0 },
    maxWaypoints: { type: Number, default: 10 }
  }

  connect() {
    // 初期表示時に経由地が0の場合、1つ追加
    if (this.countValue === 0) {
      this.addWaypoint()
    }
  }

  addWaypoint(event) {
    if (event) event.preventDefault()

    // 最大数チェック
    if (this.countValue >= this.maxWaypointsValue) {
      alert(`経由地は最大${this.maxWaypointsValue}箇所までです`)
      return
    }

    const content = this.templateTarget.innerHTML
      .replace(/NEW_RECORD/g, new Date().getTime())
      .replace(/SEQUENCE/g, this.countValue + 1)

    this.containerTarget.insertAdjacentHTML('beforeend', content)
    this.countValue++
  }

  removeWaypoint(event) {
    event.preventDefault()

    const item = event.target.closest('[data-waypoint-item]')

    if (item) {
      // 削除フラグを立てる（既存レコードの場合）
      const destroyInput = item.querySelector('input[name*="_destroy"]')
      if (destroyInput) {
        destroyInput.value = '1'
        item.style.display = 'none'
      } else {
        // 新規レコードの場合は単純に削除
        item.remove()
      }

      this.countValue--
      this.reorderSequences()
    }
  }

  // 経由地の順序を再設定
  reorderSequences() {
    const items = this.containerTarget.querySelectorAll('[data-waypoint-item]:not([style*="display: none"])')
    items.forEach((item, index) => {
      const sequenceInput = item.querySelector('input[name*="[sequence]"]')
      const label = item.querySelector('label')

      if (sequenceInput) {
        sequenceInput.value = index + 1
      }

      if (label) {
        label.textContent = `経由地${index + 1}`
      }
    })
  }
}
