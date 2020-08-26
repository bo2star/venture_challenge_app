TasksService = (http) ->

  svc = this

  baseUrl = document.location.href + '/tasks'

  svc.fetch = (callback) ->
    http.get(baseUrl).success (data) ->
      callback(data.learning_resource_tasks)

  svc.sort = (orderedIds) ->
    http.put(baseUrl + '/sort', {ordered_ids: orderedIds})

  svc.delete = (task, callback) ->
    http.delete("#{baseUrl}/#{task.id}").success(callback)

  svc.create = (title, callback) ->
    http.post(baseUrl, { title: title} ).success (data) ->
      callback(data.learning_resource_task)

  svc


QuestionsService = (http) ->

  svc = this

  baseUrl = document.location.href + '/questions'

  svc.fetch = (callback) ->
    http.get(baseUrl).success (data) ->
      callback(data.learning_resource_questions)

  svc.sort = (orderedIds) ->
    http.put(baseUrl + '/sort', {ordered_ids: orderedIds})

  svc.delete = (question, callback) ->
    http.delete("#{baseUrl}/#{question.id}").success(callback)

  svc.create = (title, callback) ->
    http.post(baseUrl, { title: title} ).success (data) ->
      callback(data.learning_resource_question)

  svc


TasksCtrl = (Task) ->

  vm = this

  vm.newTitle = ""

  vm.tasks = []

  Task.fetch (tasks) ->
    vm.tasks = tasks

  vm.sortableOptions = {
    stop: (e, ui) ->
      ids = _.map vm.tasks, (o) -> o.id
      Task.sort(ids)
  }

  vm.addTask = ->
    return unless vm.newTitle.length > 0

    Task.create vm.newTitle, (task) ->
      vm.tasks.push(task)

    vm.newTitle = ''

  vm.removeTask = (task) ->
    Task.delete task, ->
      index = vm.tasks.indexOf(task)
      vm.tasks.splice(index, 1)

  vm.tasksEmpty = ->
    vm.tasks.length == 0


QuestionsCtrl = (Question) ->

  vm = this

  vm.newTitle = ""

  vm.questions = []

  Question.fetch (questions) ->
    vm.questions = questions

  vm.sortableOptions = {
    stop: (e, ui) ->
      ids = _.map vm.questions, (o) -> o.id
      Question.sort(ids)
  }

  vm.addQuestion = ->
    return unless vm.newTitle.length > 0

    Question.create vm.newTitle, (question) ->
      vm.questions.push(question)

    vm.newTitle = ''

  vm.removeQuestion = (question) ->
    Question.delete question, ->
      index = vm.questions.indexOf(question)
      vm.questions.splice(index, 1)

  vm.questionsEmpty = ->
    vm.questions.length == 0


app = angular.module('learningResourceApp', ['ui.sortable'])
app.factory('tasksService', ['$http', TasksService])
app.factory('questionsService', ['$http', QuestionsService])
app.controller('TasksCtrl', ['tasksService', TasksCtrl])
app.controller('QuestionsCtrl', ['questionsService', QuestionsCtrl])