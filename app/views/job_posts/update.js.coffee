<% new_html = render(partial: 'show_job', locals: { job: @job_post }) %>
$(".ep-show-job").html("<%= j new_html %>")

$('.js-edit-section-item--job').click ->
  $('.js-section-item').hide()
  $('.js-edit-form').show()

$('.ep-cancel-edit').click ->
  $('.js-edit-form').hide()
  $('.js-section-item').show()
