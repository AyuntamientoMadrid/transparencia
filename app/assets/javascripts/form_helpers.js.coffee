form_helpers = ->
  $('[data-add-to]').click ->
    $this = $(this)
    source_selector = $this.data('add-from')
    destination_selector = $this.data('add-to')

    random_id = Math.floor(Math.random() * (100000 - 100)) + 100;
    source_body = $(source_selector).html().split("{id}").join(random_id)

    $(destination_selector).append($.parseHTML(source_body))
    false

  $('[data-delete-parent]').click ->
    $this = $(this)
    $this.parents($this.data('delete-parent')).remove()
    false

$(document).ready(form_helpers)
$(document).on('page:load', form_helpers)
