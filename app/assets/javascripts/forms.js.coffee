$ ->
  $('.ep-datepicker').datepicker({
    format: "mm/yyyy",
    startView: "months",
    minViewMode: "months"
  })

  $(".best_in_place").best_in_place();

  $('.js-edit-college').click ->
    $(this).closest('.js-college').hide()

  $(".js-section-container").each ->
    $(this).on 'click', '.js-edit-section-item', ->
      $(this).siblings('.js-section-item').hide()
      $(this).siblings('.js-edit-form').show()

  $('.js-edit-section-item--job').click ->
    $('.js-section-item').hide()
    $('.js-edit-form').show()

  $('.ep-cancel-edit').click ->
    $('.js-edit-form').hide()
    $('.js-section-item').show()

  $('.js-delete').click ->
    $(this).parent().hide()

  $(".ep-profile-image__placeholder").click ->
    $(".js-profile-image__file-field").click()

  $(".ep-resume__placeholder").click ->
    $(".js-resume__file-field").click()

  $(".js-search-form__text-field").bind "keyup", ->
    $(".js-search-form").submit()

  $(".js-search-form__check-box").each ->
    $(this).change ->
      $(this).closest('.js-search-form').submit()

  $('.autocomplete_field').on 'autocompleteresponse', (event, ui) ->
    $(this).autocomplete('close') if ui.content?[0].id.length == 0

  $(".js-dont-show-add-password-page").change ->
    $('#js-dont-show-add-password-page').submit()

# 	$('.checkbox input').iCheck ->
# 		checkboxClass: 'icheckbox_flat',
# 		increaseArea: '20%'

# 	$('.radio input').iCheck ->
# 		radioClass: 'iradio_flat',
# 		increaseArea: '20%'