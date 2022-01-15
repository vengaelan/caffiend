import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["url"]

  // No trigger event needed as we initialize a tooltip using tippy.js where trigger event is included

  copy() {
    this.urlTarget.select();
    document.execCommand('copy');
  }
}
