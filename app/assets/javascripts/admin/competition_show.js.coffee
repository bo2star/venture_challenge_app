init = ->
  return unless App.pageHasElement('#competitions-show')

  clip = new ZeroClipboard( $('#clip-url') )

  clip.on 'copy', (event) ->
    clipboard = event.clipboardData
    event.clipboardData.setData('text/plain', $('#join-url').text())
    $('#clip-url').hide()
    $('#clipped-url').show()

App.ready(init)