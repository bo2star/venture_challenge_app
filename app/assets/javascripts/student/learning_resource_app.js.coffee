TasksService = (http) ->

  svc = this

  baseUrl = document.location.href + '/tasks'

  taskUrl = (task) ->
    "#{baseUrl}/#{task.id}"

  svc.fetch = (callback) ->
    http.get(baseUrl).success (data) ->
      callback(data.team_learning_resource_tasks)

  svc.complete = (task) ->
    http.put(taskUrl(task), { is_complete: true })

  svc.uncomplete = (task) ->
    http.put(taskUrl(task), { is_complete: false })

  svc


QuestionsService = (http) ->

  svc = this

  baseUrl = document.location.href + '/questions'

  svc.fetch = (callback) ->
    http.get(baseUrl).success (data) ->
      callback(data.team_learning_resource_questions)

  svc.answer = (question, answerBody) ->
    url = "#{baseUrl}/#{question.id}"
    http.put(url, { answer: answerBody })

  svc


TasksCtrl = (Task) ->

  vm = this

  vm.tasks = []

  Task.fetch (tasks) ->
    vm.tasks = tasks

  vm.taskToggled = (task) ->
    if task.is_complete
      Task.complete(task)
    else
      Task.uncomplete(task)


QuestionsCtrl = ($scope, Question) ->

  $scope.questions = []

  Question.fetch (questions) ->
    $scope.questions = questions


AnswersCtrl = ($scope, Question) ->

  studentName = App.jsonMeta('student').student.name

  $scope.newBody = ''

  $scope.submit = ->
    answer = { body: $scope.newBody, student_name: studentName, created_at: new Date().getTime() }
    $scope.question.answers.push(answer)
    Question.answer($scope.question, answer.body)
    $scope.newBody = ''


app = angular.module('learningResourceApp', [])

app.factory('tasksService', ['$http', TasksService])
app.factory('questionsService', ['$http', QuestionsService])

app.filter('friendlyDate', ['$filter', FriendlyDateFilter])

app.controller('TasksCtrl', ['tasksService', TasksCtrl])
app.controller('QuestionsCtrl', ['$scope', 'questionsService', QuestionsCtrl])
app.controller('AnswersCtrl', ['$scope', 'questionsService', AnswersCtrl])