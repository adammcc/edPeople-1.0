<% new_html = render(partial: 'users/user_connection', locals: { user: @friend }) %>
$(".js_users--connection-<%= @friend.id %>").html("<%= j new_html %>")

<% new_html = render(partial: 'users/profile_actions', locals: { user: @friend }) %>
$(".js-profile-actions").html("<%= j new_html %>")

<% new_html = render(partial: 'users/connections', locals: { user: @user }) %>
$(".js-profile-section--connections").html("<%= j new_html %>")