$ ->
	$('#ep-invited').hide()
	$('#ep-invited_by').hide()

	$('#ep-show-friends').click ->
		$('#ep-friends').show()
		$('#ep-invited').hide()
		$('#ep-invited_by').hide()

	$('#ep-show-invites').click ->
		$('#ep-invited').show()
		$('#ep-invited_by').hide()
		$('#ep-friends').hide()

	$('#ep-show-inviters').click ->
		$('#ep-invited_by').show()
		$('#ep-invited').hide()
		$('#ep-friends').hide()

	$('.js-edit-mode').click ->
		$('.js-edit-mode').hide()
		$('.js-exit-edit-mode').show()
		$('.js-edit').show()

	$('.js-exit-edit-mode').click ->
		$('.js-edit-mode').show()
		$('.js-exit-edit-mode').hide()
		$('.js-edit').hide()
		$('.js-edit-form').hide()
		$('.js-edit-form--profile-image').removeClass('in')


