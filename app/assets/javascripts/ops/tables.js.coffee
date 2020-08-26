init = ->
  # Toggle seed rows in a table when the #toggle-seeds checkbox is checked.
  $('#toggle-seeds').change ->
    active = $(this).prop('checked')

    seedRows = $('table tr[data-seed]')

    if active
      seedRows.show()
    else
      seedRows.hide()

App.ready(init)