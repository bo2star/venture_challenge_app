TeamCommentsCtrl = ($scope, $http) ->

  studentName = App.jsonMeta('admin').name

  commentsUrl = document.location.href + '/team_comments'

  $scope.newBody = ''
  $scope.comments = []

  $http.get(commentsUrl).success (data) ->
    $scope.comments = data.team_comments

  $scope.submit = ->
    body = $scope.newBody
    $scope.newBody = ''

    comment = { body: body, creator_name: studentName, created_at: new Date().getTime() }
    $scope.comments.push(comment)

    $http.post(commentsUrl, {body: body})


app = angular.module('teamApp', [])
app.filter('friendlyDate', ['$filter', FriendlyDateFilter])
app.controller('TeamCommentsCtrl', ['$scope', '$http', TeamCommentsCtrl])