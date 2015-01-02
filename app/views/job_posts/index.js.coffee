<% new_html = render(partial: 'job_posts/job_posts', locals: { jobs: @jobs}) %>
$(".ep-index").html("<%= j new_html %>")