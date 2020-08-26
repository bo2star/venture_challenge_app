init = ->
  return unless App.pageHasElement('#team-charts')

  # Zip data into the format expected by AmCharts.
  #
  # We provide an array of dates, and array of values. AmCharts
  # expects the following:
  #
  # [{'date': '2014-02-1', 'value': 1}, {...}, ...]
  #
  zipChartData = (dates, values) ->
    { date: dates[i], value: values[i] } for i in [0...dates.length]

  makeChart = (elementId, title) ->
    chartEl = $('#' + elementId)

    values = chartEl.data('values')
    dates = chartEl.data('dates')
    color = chartEl.data('color')
    data = zipChartData(dates, values)

    options = {
      "type": "serial",
      "theme": "none",
      "pathToImages": "http://www.amcharts.com/lib/3/images/",
      "dataDateFormat": "YYYY-MM-DD",
      "valueAxes": [{
        "id":"v1",
        "axisAlpha": 0,
        "position": "left"
      }],
      "graphs": [{
        "id": "g1",
        "bullet": "round",
        "bulletBorderAlpha": 1,
        "bulletColor": "#FFFFFF",
        "bulletSize": 5,
        "hideBulletsCount": 50,
        "lineThickness": 2,
        "fillAlphas": 0.3,
        "title": "red line",
        "useLineColorForBulletBorder": true,
        "valueField": "value",
        "lineColor": color
      }],
      "categoryField": "date",
      "categoryAxis": {
        "gridAlpha": 0,
        "parseDates": true,
        "dashLength": 1,
        "minorGridEnabled": false,
        "axisColor": "#FFFFFF",
        "position": "bottom"
      },
      "dataProvider": data
    }

    AmCharts.makeChart(elementId, options)

  revenueChart = makeChart('revenue-chart', 'Revenue ($)')
  customersChart = makeChart('customers-chart', 'Customers')
  ordersChart = makeChart('orders-chart', 'Orders')

  $('#team-charts-tabs a').click ->
    revenueChart.handleResize()
    customersChart.handleResize()
    ordersChart.handleResize()

App.ready(init)