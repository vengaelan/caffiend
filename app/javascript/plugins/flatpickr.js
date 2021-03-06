// app/javascript/plugins/flatpickr.js

import flatpickr from "flatpickr";

const initFlatpickr = () => {
  flatpickr(".datepicker", {
    altInput: true,
    altFormat: "F j, Y",
    dateFormat: "Y-m-d",
    minDate: "today",
  });

  flatpickr(".timepicker", {
    enableTime: true,
    noCalendar: true,
    dateFormat: "H:i",
  });

  flatpickr(".datetimepicker", {
    enableTime: true,
    dateFormat: "Y-m-d H:i",
  });
}

export { initFlatpickr };
