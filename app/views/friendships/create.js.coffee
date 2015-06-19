<% new_html = render(partial: 'users/profile_actions', locals: { user: @friend }) %>
$(".js-profile-actions-<%= @friend.id %>").html("<%= j new_html %>")

<% new_html = render(partial: 'users/user_connection', locals: { user: @friend }) %>
$(".js_users--connection-<%= @friend.id %>").html("<%= j new_html %>")

_ep.notify.success("<%= flash[:notice] %>")