import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ['button', 'info', 'form'];

  displayForm() {
    this.infoTarget.classList.add('d-none');
    this.formTarget.classList.remove('d-none');
  }
}
