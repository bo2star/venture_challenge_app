init = ->
  return unless App.pageHasElement('#learning-resources-new, #learning-resources-edit')

  $('#learning_resource_body').redactor()

App.ready(init)