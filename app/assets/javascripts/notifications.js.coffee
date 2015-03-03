_ep.ns('notify')

note_timeout = null
$note = null

$ ->
  $note = $('#js-notification')
  $notice_container = $('#js-notice-content')
  $alert_container = $('#js-alert-content')
  if $notice_container.length
    _ep.notify.success($notice_container.text())
  if $alert_container.length
    _ep.notify.failure($alert_container.text())

clear_alert_classes = ->
  $note.removeClass('alert-success alert-info alert-warning alert-danger')

hide_note = ->
  $note.removeClass('in')

center_note = ->
  left_marge = 0-($note.width() / 2)
  $note.css('margin-left', "#{left_marge}px")

notify = (type, msg) ->
  clear_alert_classes()
  $note.text(msg).addClass("alert-#{type} in")
  center_note()
  window.clearTimeout(note_timeout)
  note_timeout = window.setTimeout(hide_note, 3000)

_ep.notify.success = (msg) ->
  notify('success', msg)

_ep.notify.failure = (msg) ->
  $note = $('#js-notification')
  notify('failure', msg)
