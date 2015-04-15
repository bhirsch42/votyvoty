switchView = (id) ->
  $('.view').velocity
    opacity: 0
  , complete: ->
      $('.view').addClass('hidden')
      $('#' + id).removeClass('hidden')
      $('#' + id).velocity {opacity: 1}

clickOption = ($option) ->
  if $option.hasClass('selected')
    $.post '/option/downvote',
      id: Voty.id
      message: Voty.options[parseInt($option.data('index'))].message
    $option.removeClass('selected')
  else
    $.post '/option/upvote',
      id: Voty.id
      message: Voty.options[parseInt($option.data('index'))].message
    $option.addClass('selected')

createClientOption = (message) ->
  if not message
    return false
  for option in Voty.options
    if option.message.toUpperCase() == message.toUpperCase()
      return false

  Voty.options.push {'message': message, votes: 0}

  slabEl = $('<span style="width: 100%; margin: 5px;"></span>').html(message)
  newOption = $('<div class="option"></div>').append(slabEl)
  $('#ballot').append(newOption)
  newOption.attr('data-index', Voty.options.length - 1)
  newOption.click ->
    clickOption($(this))
  slabEl.slabText()
  createOption = $('#create-option').detach()
  $('#ballot').append(createOption)
  $('#new-option-text').focus().val('')

createServerOption = (message) ->
  $.post 'option/add',
    id: window.Voty.id,
    message: message

newVoty = ->
  $.post 'voty/new',
    success = (data, textStatus, jqXHR) ->
      # Load the server data into the client model
      window.Voty = JSON.parse(data)
      url = document.location
      document.location = url + window.Voty.id
      # switch to new view
      switchView('voty')
      initVoty()

loadVoty = (voty_id) ->
  $.post 'voty/get' ,
    id: voty_id,
    success = (data, textStatus, jqXHR) ->
      # Load the server data into the client model
      window.Voty = JSON.parse(data)
      # switch to new view
      switchView('voty')
      initVoty()
      # Add options to view
      options = window.Voty.options
      window.Voty.options = []
      $(window).delay(500).queue ->
        for option in options
          createClientOption(option.message)


initVoty = ->
  $('#create-option').on 'submit', ->
    val = $('#new-option-text').val()
    createClientOption(val)
    createServerOption(val)
    return false

  $('#sidebar-toggle').click ->
    $('#sidebar').toggleClass('open')
    $(this).toggleClass('open')

  $('#results-button').click ->
    $('#ballot').css('display', 'none')
    $results = $('#results')
    $results.css('display', 'block')
    $results.empty()
    $.post 'voty/get' ,
      id: window.Voty.id,
      success = (data, textStatus, jqXHR) ->
        window.Voty = JSON.parse(data)
        for option in window.Voty.options
          $results.append $("<div>" + option.message + ", " + option.votes + "</div>")

  $('#ballot-button').click ->
    $('#ballot').css('display', '')
    $('#results').css('display', 'none')



initHome = ->
  $('#new-voty').click ->
    newVoty()
    return false

window.onload = ->
  voty_id = document.location.pathname
  voty_id = voty_id.substring 1, voty_id.length
  console.log voty_id
  if voty_id
    loadVoty(voty_id)
  else
    initHome()


