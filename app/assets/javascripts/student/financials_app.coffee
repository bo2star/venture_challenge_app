UUID = {
  generate: ->
    # See http://stackoverflow.com/a/2117523/959833
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
      r = Math.random()*16|0
      v = if c == 'x' then r else (r&0x3|0x8)
      v.toString(16)
}


Product = {
  cost: (p) ->
    Product.unitCostWithDefault(p) * p.quantity

  profit: (p) ->
    p.total_revenue - Product.cost(p)

  unitCostWithDefault: (p) ->
    if _.isNumber(p.unit_cost)
      p.unit_cost
    else
      Product.defaultCost(p)

  defaultCost: (p) ->
    p.total_revenue / p.quantity

}


Expense = {
  build: ->
    {amount: 0, uuid: UUID.generate()}

  isValid: (e) ->
    e.name && e.name.length > 0 &&
      _.isNumber(e.amount) && e.amount >= 0

}


Ctrl = ($scope, $sce, $http) ->

  financials = $('#financials').data('financials')

  # Use the 'id' field as a 'uuid' for expenses loaded from the server.
  expenses = _.map financials.expenses, (exp) ->
    _.extend exp, uuid: exp.id

  model = {
    products: financials.products,
    expenses: expenses,
    newExpense: Expense.build()
  }

  save = ->
    $http.put('/financials', {financials: model})

  addExpense = ->
    if Expense.isValid(model.newExpense)
      model.expenses.push(model.newExpense)
      model.newExpense = Expense.build()
      save()
    else
      alert("Please enter a name and amount for your expense")

  removeExpense = (uuid) ->
    model.expenses = _.reject(model.expenses, (e) -> e.uuid == uuid)
    save()

  totalRevenue = ->
    _.sum(_.pluck(model.products, 'total_revenue'))

  totalCost = ->
    productsCost = _.sum(_.map(model.products, Product.cost))
    expensesCost = _.sum(_.pluck(model.expenses, 'amount'))
    productsCost + expensesCost

  totalProductCosts = ->
    _.sum(_.map(model.products, Product.cost))

  totalExpenses = ->
    _.sum(_.pluck(model.expenses, 'amount'))

  totalProfit = ->
    totalRevenue() - totalCost()

  incompleteProducts = ->
    _.select(model.products, (p) -> !_.isNumber(p.unit_cost))

  incompleteProductsMessage = ->
    names = _.map(incompleteProducts(), (p) -> "<strong>#{p.name}</strong>")
    msg = "<strong>Attention!</strong> You've sold " + names.join(' and ') + ", but we don't know your unit cost for them yet. Fill in the proper amounts below to start earning points."
    $sce.trustAsHtml(msg)

  _.extend($scope, {
    model,
    addExpense,
    removeExpense,
    totalRevenue,
    totalProductCosts,
    totalExpenses,
    totalCost,
    totalProfit,
    incompleteProducts,
    incompleteProductsMessage,
    Product,
    save
  })

app = angular.module('financialsApp', [])
app.controller('FinancialsCtrl', ['$scope', '$sce', '$http', Ctrl])
