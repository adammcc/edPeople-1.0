<% new_html = render(partial: 'users/user_connection', locals: { user: @friend }) %>
$(".js_users--connection-<%= @friend.id %>").html("<%= j new_html %>")

<% new_html = render(partial: 'users/connections', locals: { user: @user, suggestions: @suggestions }) %>
$(".js-profile-section--connections").html("<%= j new_html %>")

$('#ep-invited').hide()
$('#ep-invited_by').hide()

$('#ep-show-friends').click ->
  $('#ep-friends').show()
  $('#ep-invited').hide()
  $('#ep-invited_by').hide()

$('#ep-show-invites').click ->
  $('#ep-invited').show()
  $('#ep-invited_by').hide()
  $('#ep-friends').hide()

$('#ep-show-inviters').click ->
  $('#ep-invited_by').show()
  $('#ep-invited').hide()
  $('#ep-friends').hide()

