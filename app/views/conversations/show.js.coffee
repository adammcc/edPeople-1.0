<% new_html = render(partial: 'conversations/messages', locals: { user: @user, messages: @messages }) %>
$(".ep-index__messages").append("<%= j new_html %>")

<% if @messages.next_page %>
$('.pagination').replaceWith('<%= j will_paginate(@messages) %>');
<% else %>
$('.pagination').remove();
<% end %>