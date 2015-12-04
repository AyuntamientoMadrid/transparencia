linkables = ->
  $('.linkable').click ->
    window.document.location = $(this).data("url")
    return

$(document).ready(linkables);
$(document).on('page:load', linkables);