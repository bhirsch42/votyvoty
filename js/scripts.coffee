window.onload = ->
  $('#create-option').on 'submit', ->
    console.log 'submitted'
    val = $('#new-option-text').val()
    if not val
      return false
    $('#ballot').append($('<div class="option"></div>').html(val))
    $(this).detach()
    $('#ballot').append($(this))
    $('#new-option-text').focus().val('')
    return false

  $('#sidebar-toggle').click ->
    console.log $('#sidebar').toggleClass('open')