init = ->

  $(document).foundation orbit:
    animation: "slide"
    resume_on_mouseout: false
    next_on_click: true
    animation_speed: 500
    stack_on_small: false
    navigation_arrows: true
    slide_number: false
    orbit_transition_class: "orbit-transitioning"
    timer: false
    variable_height: true
    swipe: true

App.ready(init)