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

export default class extends Controller {
  static targets = [ "meeting", "info" ]

  initialize() {

    // this.meeting = this.getMeeting();
    // this.info = this.getInfo();


    this.initPopup();

    this.infoTarget.style.display = "none";
  }

  initPopup() {
    this.popup = tippy(this.meetingTarget, {
    content: this.infoTarget.innerHTML,
    allowHTML: true,
    placement: 'right',
    })
  }

  // getInfo() {
  //   if (this.hasInfoTarget) {
  //     return this.infoTarget;
  //   } else {
  //     var info = document.createElement('div')
  //     info.innerHTML = this.data.get("info");

  //     return info
  //   }
  // }

  // getMeeting() {
  //   if (this.hasMeetingTarget) {
  //     return this.meetingTarget;
  //   } else {
  //     return this.element;
  //   }
  // }
}
