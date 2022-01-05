// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "startDate", "endDate", "location" ]

  // No trigger event needed as we initialize a tooltip using tippy.js where trigger event is included

  selection() {
    $(".choice").removeClass("selected")
    event.currentTarget.classList.add("selected")
    this.startDateTarget.value = event.params["start"]
    this.endDateTarget.value = event.params["end"]
    this.locationTarget.value = event.params["location"]
  }

}
