<% new_html = render(partial: 'users/certs', locals: { user: @user }) %>
$(".ep-profile-section--cert").html("<%= j new_html %>")

$(".js-section-container").each ->
    $(this).on 'click', '.js-edit-section-item', ->
      $(this).siblings('.js-section-item').hide()
      $(this).siblings('.js-edit-form').show()

$('.ep-cancel-edit').click ->
  $('.js-edit-form').hide()
  $('.js-section-item').show()

$(".ep-profile-image__placeholder").click ->
  $(".js-profile-image__file-field").click()

$(".js-profile-image__file-field").change ->
  $('.ep-profile-image__placeholder-input').attr('placeholder', $(this).val().split('\\').pop())

$('.js-delete').click ->
    $(this).parent().hide()

$('.js-edit').show()
$('.ep-datepicker').datepicker()

$('.autocomplete_field').on 'autocompleteresponse', (event, ui) ->
  $(this).autocomplete('close') if ui.content?[0].id.length == 0

<% if flash[:notice] %>
_ep.notify.success("<%= flash[:notice] %>")
<% end %>

<% if flash[:alert] %>
_ep.notify.success("<%= flash[:alert] %>")
<% end %>