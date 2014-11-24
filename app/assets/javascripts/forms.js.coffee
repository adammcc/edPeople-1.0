$ ->
  $('.js-edit-college').click ->
    $(this).closest('.js-college').hide()

  $('.js-edit-experience').click ->
    $(this).closest('.js-experience').hide()

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