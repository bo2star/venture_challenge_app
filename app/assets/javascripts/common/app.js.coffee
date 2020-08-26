App = {}

App.ready = (fn) ->
  $(document).ready(fn)
  $(document).on('page:load', fn)

App.pageHasElement = (selector) ->
  $(selector).length > 0

App.hasMeta = (name) -> App.pageHasElement("meta[name=#{name}]")

App.meta = (name) ->
  if App.hasMeta(name)
    $("meta[name=#{name}]").attr('content')
  else
    undefined

App.jsonMeta = (name) ->
  meta = App.meta(name)
  meta && JSON.parse(meta)

window.App = App