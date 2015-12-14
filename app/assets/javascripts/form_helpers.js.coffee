form_helpers = ->
  $(document).on 'click', 'a[data-add-to]', ->
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

  42

$(document).ready(form_helpers)
$(document).on('page:load', form_helpers)
