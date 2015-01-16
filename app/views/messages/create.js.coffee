<% new_html = render(partial: 'conversations/message', locals: { user: @user, message: @message }) %>
$(".js-messages-container").prepend("<%= j new_html %>")
$('.ep-form__text-area').val('')