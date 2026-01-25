import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fareAmount", "highwayFee", "parkingFee", "otherFee", "totalAmount"]

  connect() {
    this.calculate()
  }

  calculate() {
    const fareAmount = parseInt(this.fareAmountTarget.value) || 0
    const highwayFee = parseInt(this.highwayFeeTarget.value) || 0
    const parkingFee = parseInt(this.parkingFeeTarget.value) || 0
    const otherFee = parseInt(this.otherFeeTarget.value) || 0

    const total = fareAmount + highwayFee + parkingFee + otherFee

    this.totalAmountTarget.textContent = total.toLocaleString()
  }
}
