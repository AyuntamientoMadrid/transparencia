ready = ->
  $('.show-more').click ->
    if $('.show-more').text() == 'Leer más'
      $('.show-more').text 'Leer menos'
    else
      $('.show-more').text 'Leer más'
    $.each $('.description'), (index, description) ->
      $(description).toggle()
      return
    return
  return

$(document).ready(ready);
$(document).on('page:load', ready);