tour = {

  id: 'admin-tour'

  steps: [
    {
      title: 'Learning Resources'
      content: 'First you’ll want to check out the learning resources. These are customizable content modules that will guide students through starting their business.'
      target: '#nav-item-learning-resources'
      placement: 'bottom'
      multipage: true
      onNext: ->
        window.location = '/learning_resources'
    },
    {
      title: 'Create, Edit or Re-order'
      content: "You can not adjust the learning resources of a pre-existing competition, so select which learning resources you want to use and make any changes to the content as you see fit."
      target: '.page-header'
      placement: 'bottom'
      multipage: true
      onNext: ->
        # Follow to the first learning resource.
        url = $('.learning-resource-item:first-child .learning-resource-link').attr('href')
        window.location = url
    },
    {
      title: 'Edit'
      content: 'You can add content, tasks and questions. Students responses will show up in your dashboard for review.'
      target: '.page-header'
      placement: 'bottom'
      multipage: true
      onNext: ->
        window.location = '/competitions'
    },
    {
      title: 'Create a new competition'
      content: 'After you have setup the Learning Resources, you can create a new competition. Once you have selected the dates of the competition, you will receive a unique link that you can send to your students that will allow them to register for the Venture Challenge.'
      target: '#new-competition'
      placement: 'bottom'
    }
  ],

  onClose: -> hopscotch.endTour(true)

}

$('#new-user-tour').click ->
  hopscotch.startTour(tour, 0)

state = hopscotch.getState()

# Start tour on second page.
if state == 'admin-tour:1' && App.pageHasElement('#learning-resources-index')
  hopscotch.startTour(tour)

# Start tour on third page.
if state == 'admin-tour:2' && App.pageHasElement('#learning-resources-show')
  hopscotch.startTour(tour)

# Start tour on fourth page.
if state == 'admin-tour:3' && App.pageHasElement('#competitions-index')
  hopscotch.startTour(tour)