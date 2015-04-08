switchView = (id) ->
  console.log 'switchView', id
  $('.view').velocity
    opacity: 0
  , complete: ->
      console.log 'switchView complete'
      $('.view').addClass('hidden')
      $('#' + id).removeClass('hidden')
      $('#' + id).velocity {opacity: 1}

newVoty = ->
  $.post '/new',
    success = (data, textStatus, jqXHR) ->
      window.Noty = JSON.parse(data)
      switchView('voty')
      initVoty()

initVoty = ->
  $('#create-option').on 'submit', ->
    console.log 'submitted'
    val = $('#new-option-text').val()
    if not val
      return false
    slabEl = $('<span style="width: 100%; margin: 5px;"></span>').html(val)
    newOption = $('<div class="option"></div>').append(slabEl)
    $('#ballot').append(newOption)
    slabEl.slabText()
    $(this).detach()
    $('#ballot').append($(this))
    $('#new-option-text').focus().val('')
    return false

  $('#sidebar-toggle').click ->
    $('#sidebar').toggleClass('open')
    $(this).toggleClass('open')

initHome = ->
  $('#new-voty').click ->
    newVoty()
    return false

window.onload = ->
  initHome()
  initVoty()