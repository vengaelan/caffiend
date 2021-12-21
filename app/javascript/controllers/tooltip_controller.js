// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"
import tippy from "tippy.js"
import "tippy.js/themes/light.css";

export default class extends Controller {
  static targets = [ "meeting", "info" ]

  // No trigger event needed as we initialize a tooltip using tippy.js where trigger event is included


  initialize() {

    this.initPopup();

    this.infoTarget.style.display = "none";
  }

  initPopup() {
    this.popup = tippy(this.meetingTarget, {
    content: this.infoTarget.innerHTML,
    allowHTML: true,
    placement: 'right',
    theme: 'light',
    })
  }

}
