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
    // Removes the selected class from all choices to prevent multiple choices to have the selected class after clicking
    $(".choice").removeClass("selected")
    // Adds selected class to the clicked choice
    event.currentTarget.classList.add("selected")
    // Submit button enabled once a selection has been clicked
    $(".btn-meeting").prop("disabled", false)
    // Update hidden meeting input fields
    this.startDateTarget.value = event.params["start"]
    this.endDateTarget.value = event.params["end"]
    this.locationTarget.value = event.params["location"]
  }

}
