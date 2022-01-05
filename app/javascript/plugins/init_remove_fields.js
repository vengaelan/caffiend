const init_remove_fields = () => {

  $('.simple_form').on('click', '.remove_fields', function (event) {
    console.log("clicked!")
    $(this).prev('input[type="hidden"]').val('1');
    $(this).closest('.fields').hide();
    return event.preventDefault();
  });
}

export { init_remove_fields }
