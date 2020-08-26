scrollToBottom = (el) ->
  el.animate({scrollTop: el.prop('scrollHeight')}, '500', ->)

TeamCommentsCtrl = ($scope, $http) ->

  studentName = App.jsonMeta('student').student.name

  $scope.newBody = ''
  $scope.comments = []

  $http.get('team_comments').success (data) ->
    $scope.comments = data.team_comments

    setTimeout((->
      scrollToBottom($('.comments'))
    ), 0)
    

  $scope.submit = ->
    body = $scope.newBody
    $scope.newBody = ''

    comment = { body: body, creator_name: studentName, created_at: new Date().getTime() }
    $scope.comments.push(comment)

    scrollToBottom($('.comments'))

    $http.post("/team_comments", {body: body})


app = angular.module('teamApp', [])
app.filter('friendlyDate', ['$filter', FriendlyDateFilter])
app.controller('TeamCommentsCtrl', ['$scope', '$http', TeamCommentsCtrl])