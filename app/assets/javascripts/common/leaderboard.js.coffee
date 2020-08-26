init = ->
  return unless App.pageHasElement('#points-chart')

  # Zip data into the format expected by AmCharts.
  #
  # We provide an array of dates, array of team names, and
  # array of values arrays for each team. AmCharts expects the
  # following:
  #
  # [{'date': '2014-02-1', 'Team A': 1, 'Team B': 2}, {...}, ...]
  #
  zipChartData = (dates, valuesList, teams) ->
    for i in [0...dates.length]
      h = { date: dates[i] }
      for j in [0...teams.length]
        h[teams[j].name] = valuesList[j][i]
      h

  chartGraph = (team) ->
    {
      "id": team.name,
      "bullet": "round",
      "bulletBorderAlpha": 1,
      "bulletColor": "#FFFFFF",
      "bulletSize": 5,
      "hideBulletsCount": 50,
      "lineThickness": 2,
      "title": team.name,
      "useLineColorForBulletBorder": true,
      "valueField": team.name,
      "color": team.color,
      "lineColor": team.color
    }

  makeChart = (elementId) ->
    chartEl = $('#' + elementId)
    dates = chartEl.data('dates')
    valuesList = chartEl.data('values-list')
    teams = chartEl.data('teams')

    data = zipChartData(dates, valuesList, teams)

    graphs = _.map(teams, chartGraph)

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
      "graphs": graphs,
      "legend": { "useGraphSettings": true },
      "categoryField": "date",
      "categoryAxis": {
        "parseDates": true,
        "dashLength": 1,
        "minorGridEnabled": true,
        "position": "bottom"
      },
      "dataProvider": data
    }

    AmCharts.makeChart(elementId, options)

  chart = makeChart('points-chart', 'Points')

  $('.history-tab').click ->
    chart.handleResize()


App.ready(init)