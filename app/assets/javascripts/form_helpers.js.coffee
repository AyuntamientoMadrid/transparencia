form_helpers = ->
  $('a[data-add-to]').click ->
    $this = $(this)
    source_selector = $this.data('add-from')
    destination_selector = $this.data('add-to')

    random_id = Math.floor(Math.random() * (100000 - 100)) + 100;
    source_body = $(source_selector).html().split("{id}").join(random_id)

    $(source_body).appendTo($(destination_selector))
    false

  $(document).on 'click', '[data-delete-parent]', ->
    $this = $(this)
    $this.parents($this.data('delete-parent')).remove()
    false

  $('#person_portrait').on 'change', (event) ->
    files = event.target.files
    image = files[0]
    reader = new FileReader

    reader.onload = (file) ->
      img = new Image
      img.src = file.target.result
      $('#image_preview').html img
      return

    reader.readAsDataURL image

$(document).ready(form_helpers)
$(document).on('page:load', form_helpers)
