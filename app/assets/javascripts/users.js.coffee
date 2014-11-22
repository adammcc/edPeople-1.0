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

