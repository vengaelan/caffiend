const init_remove_fields = () => {

  $('.simple_form').on('click', '.remove_fields', function (event) {
    // choice instance needs to be destoryed
    $(this).prev().find('input[type=hidden]').val('true');

    // choice fields need to be removed
    $(this).closest('.fields').hide();

    return event.preventDefault();
  });
}

export { init_remove_fields }
