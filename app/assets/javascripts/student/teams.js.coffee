init = ->
  return unless App.pageHasElement('.step')

  $('.step > a.toggle').click ->
    $('.step > main').hide()
    $(this).next().toggle()

App.ready(init)