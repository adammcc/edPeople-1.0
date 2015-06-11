$ ->
	if $('#ep-show-suggested-friends').length
		$('#ep-friends').hide()
		$('#ep-show-friends').removeClass('ep-active-connections')

		$('#ep-invited').hide()
		$('#ep-invited_by').hide()

		$(".js-profile-section--connections").on 'click', '#ep-show-friends', ->
			$('.ep-active-connections').removeClass('ep-active-connections')
			$(this).addClass('ep-active-connections')
			$('#ep-friends').show()
			$('#ep-invited').hide()
			$('#ep-invited_by').hide()
			$('#ep-friend-suggestions').hide()

		$(".js-profile-section--connections").on 'click', '#ep-show-invites', ->
			$('.ep-active-connections').removeClass('ep-active-connections')
			$(this).addClass('ep-active-connections')
			$('#ep-invited').show()
			$('#ep-invited_by').hide()
			$('#ep-friends').hide()
			$('#ep-friend-suggestions').hide()

		$(".js-profile-section--connections").on 'click', '#ep-show-inviters', ->
			$('.ep-active-connections').removeClass('ep-active-connections')
			$(this).addClass('ep-active-connections')
			$('#ep-invited_by').show()
			$('#ep-invited').hide()
			$('#ep-friends').hide()
			$('#ep-friend-suggestions').hide()

		$(".js-profile-section--connections").on 'click', '#ep-show-suggested-friends', ->
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

	$('.ep-profile-image').hover (->
	  $('.ep-change-image.js-edit').show()
	), ->
	  $('.ep-change-image.js-edit').hide()

	if $('#js-show-add-password-form').length
		$("#ep-confirm__add_password").modal('show');

@imgError = (image) ->
  image.onerror = ""
  image.src = "/assets/missing_user.png"
  $('.ep-change-image').show()

@orgImgError = (image) ->
  image.onerror = ""
  image.src = "/assets/missing_org.png"
  $('.ep-change-image').show()


