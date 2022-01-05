const init_remove_fields = () => {

  $('.simple_form').on('click', '.remove_fields', function (event) {
    $(this).prev().find('input[type=hidden]').val('true');
    $(this).closest('.fields').hide();
    return event.preventDefault();
  });
}

export { init_remove_fields }
