$ ->
  $('.js-edit-college').click ->
    $(this).closest('.js-college').hide()

  $(".js-section-container").each ->
    $(this).on 'click', '.js-edit-section-item', ->
      $(this).siblings('.js-section-item').hide()
      $(this).siblings('.js-edit-form').show()

  $('.ep-cancel-edit').click ->
    $('.js-edit-form').hide()
    $('.js-section-item').show()

  $('.js-delete').click ->
    $(this).parent().hide()

  $(".ep-profile-image__placeholder").click ->
    $(".js-profile-image__file-field").click()

  $(".js-profile-image__file-field").change ->
    $('.ep-profile-image__placeholder-input').attr('placeholder', $(this).val().split('\\').pop())

# 	$('.ep-datepicker').datepicker()

# 	$('.checkbox input').iCheck ->
# 		checkboxClass: 'icheckbox_flat',
# 		increaseArea: '20%'

# 	$('.radio input').iCheck ->
# 		radioClass: 'iradio_flat',
# 		increaseArea: '20%'