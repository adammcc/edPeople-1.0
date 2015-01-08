<% new_html = render(partial: 'conversations/conversations', locals: { conversations: @conversations }) %>
$(".ep-index").html("<%= j new_html %>")