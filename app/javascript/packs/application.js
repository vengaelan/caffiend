// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';
import { initFlatpickr } from "../plugins/flatpickr"; // Flatpickr for date time fields in form
import { initUpdateNavbarOnScroll } from '../components/navbar'; //navbar.js
import "tippy.js/dist/tippy.css";
import { init_add_fields } from "../plugins/init_add_fields"; // Add fields in nested form
import { init_remove_fields } from "../plugins/init_remove_fields"; //Remove fields in nested form
import { init_copy_to_clipboard } from "../plugins/init_copy_to_clipboard";
import 'animate.css';
import { reveal } from "../components/scroll";

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initSelect2();
  initFlatpickr(); // Flatpickr
  initUpdateNavbarOnScroll(); // navbar.js
  init_add_fields(); // Add fields in nested form
  init_remove_fields(); // Remove fields in nested form
  //init_copy_to_clipboard();
  reveal;
});

import "controllers"
