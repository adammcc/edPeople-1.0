$ ->
  $('.js-create-an-org').click ->
    $('.js-user-name-fields, .js-create-an-org').hide()
    $('.js-org-field, .js-create-a-user').show()
    $('.js-signin-signup h2').text('Create an organization account')
    $('<input />').attr('type', 'hidden')
      .attr('name', "user[as_org]")
      .attr('value', "1")
      .attr('class', "js-as-org-field")
      .appendTo('.new_user')

  $('.js-create-a-user').click ->
    $('.js-user-name-fields, .js-create-an-org').show()
    $('.js-org-field, .js-create-a-user').hide()
    $('.js-signin-signup h2').text('Create an account')
    $('.js-as-org-field').remove()

