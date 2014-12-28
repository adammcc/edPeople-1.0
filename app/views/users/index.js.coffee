<% new_html = render(partial: 'users/users', locals: { users: @users}) %>
$(".ep-index").html("<%= j new_html %>")