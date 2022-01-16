import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["url"]

  copy() {
    this.urlTarget.select();
    document.execCommand('copy');
  }
}
