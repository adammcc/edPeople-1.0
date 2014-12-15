<% new_html = render(partial: 'users/user_connection', locals: { user: @friend }) %>
$(".js_users--connection-<%= @friend.id %>").html("<%= j new_html %>")