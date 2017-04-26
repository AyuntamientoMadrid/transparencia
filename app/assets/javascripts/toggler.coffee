App.Toggler =
  initialize: ->
    $('[data-toggle]').on 'click', ->
      $($(this).data('toggle')).toggle()
      false # needed to avoid scroll up when clicking link

