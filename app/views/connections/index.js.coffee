<% new_html = render(partial: 'more_connections', locals: { user: @user, connections: @connections, title: @title }) %>
$(".ep-connection-modal").html("<%= j new_html %>")
$(".ep-connection-modal").modal('show')
