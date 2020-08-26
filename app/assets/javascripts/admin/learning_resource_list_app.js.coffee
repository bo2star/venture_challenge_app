LearningResourcesService = (http) ->

  svc = this

  baseUrl = document.location.href

  resourcePath = (resource) ->
    "#{baseUrl}/#{resource.id}"

  svc.fetch = (callback) ->
    http.get(baseUrl + '.json').success (data) ->
      callback(data.learning_resources)

  svc.sort = (orderedIds) ->
    http.put(baseUrl + '/sort', {ordered_ids: orderedIds})

  svc.publish = (resource) ->
    http.put(resource.url + '/publish')

  svc.unpublish = (resource) ->
    http.put(resource.url + '/unpublish')

  svc


AppCtrl = (resourcesService, $scope) ->

  vm = this

  vm.resources = []

  resourcesService.fetch (resources) ->
    vm.resources = resources

  vm.sortableOptions = {
    stop: (e, ui) ->
      ids = _.map vm.resources, (o) -> o.id
      resourcesService.sort(ids)
  }

  vm.publishToggled = (resource) ->
    if resource.is_published
      resourcesService.publish(resource)
    else
      resourcesService.unpublish(resource)


app = angular.module('learningResourceListApp', ['ui.sortable'])
app.factory('learningResourcesService', ['$http', LearningResourcesService])
app.controller('AppCtrl', ['learningResourcesService', '$scope', AppCtrl])