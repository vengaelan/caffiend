import { initFlatpickr } from "../plugins/flatpickr";

const init_add_fields = () => {

  $('.simple_form').on('click', '.add_fields', function(event) {
    var regexp, time;

    // Save a unique timestamp to ensure the key of the associated array is unique.
    time = new Date().getTime();

    // Create a new regular expression needed to find any instance of the `new_object.object_id` used in the fields data attribute
    regexp = new RegExp($(this).data('id'), 'g');

    // Replace all instances of the `new_object.object_id` with `time`, and save markup into a variable if there's a value in `regexp`.
    $(this).before($(this).data("fields").replace(regexp, time));
    event.preventDefault();

    // Hide button after click
    $(this).hide();

    // Flatpickr plugin needs to run again to capture new fields
    return initFlatpickr();
  });
}

export { init_add_fields }
