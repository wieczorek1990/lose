API = 'http://localhost:4567/api/'

Handlebars.registerPartial('note', Lose.templates.note)

$.get API, (notes) ->
  $('#notes').html(Lose.templates.notes(notes: notes))

  del = (self) ->
    $this = $(self)
    $.ajax {
      url: API + $this.data('id')
      method: 'DELETE'
      success: ->
        $this.parents('p').remove()
    }

  newNote = (self) ->
    $.ajax {
      url: API,
      method: 'POST'
      contentType: 'application/json'
      data: JSON.stringify({
        text: $('#new-input').val()
      }),
      success: (note) ->
        $('#notes').append(Lose.templates.note(note))
        $('.delete:last').click ->
          del(self)
        $('#new-input').val('')
    }

  $('.delete').click ->
    del(this)

  $('#new-button').click ->
    newNote(this)

  $('#new-input').keypress (event) ->
    if event.which == 13
      newNote(this)

