<% new_html = render(partial: 'users/users', locals: { users: @users}) %>
$(".ep-users").html("<%= j new_html %>")