$ ->
  $('.js-create-an-org').click ->
    $('#js-signin-signup--org-name').attr("required")
    $('#js-signin-signup--first-name').removeAttr("required")
    $('#js-signin-signup--last-name').removeAttr("required")
    $('#js-signin-signup--first-name').val("org_first")
    $('#js-signin-signup--last-name').val("org_last")
    $('#js-signin-signup--org-name').prop("required", true)

    $('.js-user-name-fields, .js-create-an-org').hide()
    $('.js-org-field, .js-create-a-user').show()
    $('.js-signin-signup h2').text('Create an organization account')
    $('<input />').attr('type', 'hidden')
      .attr('name', "user[as_org]")
      .attr('value', "1")
      .attr('class', "js-as-org-field")
      .appendTo('.new_user')

  $('.js-create-a-user').click ->
    $('#js-signin-signup--first-name').val('')
    $('#js-signin-signup--last-name').val('')
    $('#js-signin-signup--first-name').prop("required", true)
    $('#js-signin-signup--last-name').prop("required", true)
    $('#js-signin-signup--org-name').removeAttr("required")
    $('.js-user-name-fields, .js-create-an-org').show()
    $('.js-org-field, .js-create-a-user').hide()
    $('.js-signin-signup h2').text('Create an account')
    $('.js-as-org-field').remove()

