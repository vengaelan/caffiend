import { initFlatpickr } from "../plugins/flatpickr";

const init_add_fields = () => {

  $('.simple_form').on('click', '.add_fields', function(event) {
    console.log("clicked!")
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data("fields").replace(regexp, time));
    event.preventDefault();
    return initFlatpickr(); // we need to run initFlatpickr plugin after field is added again 
  });
}

export { init_add_fields }
