<% new_html = render(partial: 'users/user_connection', locals: { user: @friend }) %>
$(".js_users--connection-<%= @friend.id %>").html("<%= j new_html %>")

<% new_html = render(partial: 'users/profile_actions', locals: { user: @friend }) %>
$(".js-profile-actions-<%= @friend.id %>").html("<%= j new_html %>")

<% new_html = render(partial: 'connections/connections', locals: { user: @user, suggestions: @suggestions }) %>
$(".js-profile-section--connections").html("<%= j new_html %>")

$('#ep-show-friends').click()