window.FriendlyDateFilter = ($filter) ->

  MS_IN_DAY = 1000 * 3600 * 24

  (date) ->
    date = new Date(+date)
    today = new Date()

    daysAgo = (today - date)/MS_IN_DAY

    dateFilter = $filter('date')

    day = if daysAgo > 30
      dateFilter(date, 'MMMM d, y')
    else if daysAgo > 10
      dateFilter(date, 'MMMM d')
    else if daysAgo > 7
      dateFilter(date, 'EEE, MMM d')
    else if daysAgo > 2
      dateFilter(date, 'EEEE')
    else if daysAgo > 1
      'yesterday'
    else
      'today'

    day + ' at ' + dateFilter(date, 'h:mm a')