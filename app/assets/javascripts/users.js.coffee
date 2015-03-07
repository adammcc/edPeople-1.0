$ ->
	if $('#ep-show-suggested-friends').length
		$('#ep-friends').hide()
		$('#ep-show-friends').removeClass('ep-active-connections')

		$('#ep-invited').hide()
		$('#ep-invited_by').hide()

		$('#ep-show-friends').click ->
			$('.ep-active-connections').removeClass('ep-active-connections')
			$(this).addClass('ep-active-connections')
			$('#ep-friends').show()
			$('#ep-invited').hide()
			$('#ep-invited_by').hide()
			$('#ep-friend-suggestions').hide()

		$('#ep-show-invites').click ->
			$('.ep-active-connections').removeClass('ep-active-connections')
			$(this).addClass('ep-active-connections')
			$('#ep-invited').show()
			$('#ep-invited_by').hide()
			$('#ep-friends').hide()
			$('#ep-friend-suggestions').hide()

		$('#ep-show-inviters').click ->
			$('.ep-active-connections').removeClass('ep-active-connections')
			$(this).addClass('ep-active-connections')
			$('#ep-invited_by').show()
			$('#ep-invited').hide()
			$('#ep-friends').hide()
			$('#ep-friend-suggestions').hide()

		$('#ep-show-suggested-friends').click ->
			$('.ep-active-connections').removeClass('ep-active-connections')
			$(this).addClass('ep-active-connections')
			$('#ep-friend-suggestions').show()
			$('#ep-friends').hide()
			$('#ep-invited').hide()
			$('#ep-invited_by').hide()

	$('.js-edit-mode').click ->
		$('.js-edit-mode').hide()
		$('.js-exit-edit-mode').show()
		$('.js-edit').show()

	$('.js-edit-resume').click ->
		$('.js-edit-resume-options').show()

	$('.js-cancel-edit-resume').click ->
		$('.js-edit-resume-options').hide()

	$('.js-exit-edit-mode').click ->
		$('.js-edit-mode').show()
		$('.js-exit-edit-mode').hide()
		$('.js-edit').hide()
		$('.js-edit-form').hide()
		$('.js-edit-form--file-upload').removeClass('in')

@imgError = (image) ->
  image.onerror = ""
  image.src = "/assets/missing.png"


