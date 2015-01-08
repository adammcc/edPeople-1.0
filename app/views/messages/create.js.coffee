<% new_html = render(partial: 'conversations/conversation_messages', locals: { conversation: @conversation }) %>
$(".js-conversation-messages").html("<%= j new_html %>")
