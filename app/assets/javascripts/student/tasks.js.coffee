init = ->
  return unless App.pageHasElement('#tasks-index')

  $('#toggle-completed').click ->
    $('.completed-tasks').show()
    $(this).hide()
    false

App.ready(init)