$ ->
  $('.best_in_place').bind 'ajax:success', ->
    $(this).siblings('.js-add-bip').addClass('js-edit').text(' Edit')

    if $('.js-exit-edit-mode').is(':visible')
      $('.js-edit').show()

