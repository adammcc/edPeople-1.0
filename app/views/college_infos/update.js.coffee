<% new_html = render(partial: 'users/education', locals: { user: @user, colleges: @colleges }) %>
$(".ep-profile-section--education").html("<%= j new_html %>")

$(".js-section-container").each ->
    $(this).on 'click', '.js-edit-section-item', ->
      $(this).siblings('.js-section-item').hide()
      $(this).siblings('.js-edit-form').show()

$('.ep-cancel-edit').click ->
  $('.js-edit-form').hide()
  $('.js-section-item').show()

$('.js-delete').click ->
    $(this).parent().hide()

$('.js-edit').show()
$('.ep-datepicker').datepicker({
  format: "mm/yyyy",
  startView: "months",
  minViewMode: "months"
})

$('.autocomplete_field').on 'autocompleteresponse', (event, ui) ->
  $(this).autocomplete('close') if ui.content?[0].id.length == 0

<% if flash[:notice] %>
_ep.notify.success("<%= flash[:notice] %>")
<% end %>

<% if flash[:alert] %>
_ep.notify.success("<%= flash[:alert] %>")
<% end %>