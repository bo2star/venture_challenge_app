init = ->
  return unless App.pageHasElement('.competition-form-fields')

  oneMonthMillis = 1000 * 60 * 60 * 24 * 30

  startPicker = $('#competition-start-date').pickadate({
    clear: false
  }).pickadate('picker')

  endPicker = $('#competition-end-date').pickadate({
    clear: false
  }).pickadate('picker')

  getStartMillis = ->
    startPicker.get('select').pick

  setEndMillis = (millis) ->
    endPicker.set('select', new Date(millis))

  startPicker.on 'set', ->
    endPicker.set('min', startPicker.get('value'))

    setEndMillis( getStartMillis() + oneMonthMillis )


App.ready(init)