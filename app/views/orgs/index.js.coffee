<% new_html = render(partial: 'orgs/orgs', locals: { users: @orgs}) %>
$(".ep-index__items").html("<%= j new_html %>")
$('.js-will-page').html('<div class="pagination"><%= j will_paginate(@jobs) %></div>')