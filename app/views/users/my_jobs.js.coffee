<% new_html = render(partial: 'job_posts/job_posts', locals: { jobs: @jobs}) %>
$(".ep-index__items").html("<%= j new_html %>")
$('.js-will-page').html('<div class="pagination"><%= j will_paginate(@jobs) %></div>')