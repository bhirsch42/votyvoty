window.validationErrors = false

validateEmail = (email) ->
  re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
  re.test email

stripeResponseHandler = (status, response) ->
  if response.error
    $('#card-number').parent().find('.error').html(response.error.message)
    $('#submit').prop 'disabled', false
  else
    token = response.id
    submitPayment(token)

submitPayment = (token) ->
  if window.validationErrors
    return

  ticketNames = []
  for i in [1..parseInt($('#tickets').val())]
    fname = $('#ticket-first-name-' + i).val()
    lname = $('#ticket-last-name-' + i).val()
    ticketNames.push({'first_name': fname, 'last_name': lname})

  console.log ticketNames

  $.post '/pay',
    names       : JSON.stringify(ticketNames),
    email       : $('#email').val(),
    tickets     : $('#tickets').val(),
    token       : token
  , ->
    console.log "PAYMENT SUCCESSFUL!"
    $('#myModal').modal('hide')
    $('#buy-tickets').html('Purchase Successful!').prop('disabled', true)
      .append("<h6 class=\"small\">An email has been sent</h6>")


window.onload = ->
  Stripe.setPublishableKey 'pk_live_DU7Bp9hKLze0s8vO8ejP9NqY'
  # Stripe.setPublishableKey 'pk_test_1nIlBMwLLFerk5aZeNtqEdrl' # TESTING

  $('#tickets').on 'change', ->
    tickets = $(this).val()
    price = parseFloat($('#calc-price').html())
    $('#calc-tickets').html(tickets)
    $('#calc-total').html((parseInt(tickets) * price).toFixed(2))

    $ticket_name_template = $($('#ticket-group').children()[0])
    $('.ticket-name').remove()
    for i in [1..parseInt(tickets)]
      $ticket_name_template = $ticket_name_template.clone()

      $ticket_name_template.find('label').each ->
        for_attr = $(this).attr 'for'
        $(this).attr('for', for_attr.substring(0, for_attr.length-1) + i)

      $ticket_name_template.find('input').each ->
        input_name = $(this).attr 'name'
        $(this).attr('name', input_name.substring(0, input_name.length-1) + i)

        input_id = $(this).attr 'id'
        $(this).attr('id', input_id.substring(0, input_id.length-1) + i)

      $('#ticket-group').append($ticket_name_template)

  $('form').on 'submit', (e) ->
    e.preventDefault()
    $('#submit').prop 'disabled', true

    first_name  = $('#first-name').val()
    last_name   = $('#last-name').val()
    email       = $('#email').val()
    card_number = $('#card-number').val()
    card_cvc    = $('#card-cvc').val()
    card_month  = $('#card-month').val()
    card_year   = $('#card-year').val()
    tickets     = $('#tickets').val()

    window.validationErrors = false

    $('.error').each ->
      $(this).text ''

    if not validateEmail(email)
      $('#email').parent().find('.error').text('This email looks invalid.')
      $('#submit').prop 'disabled', false
      window.validationErrors = true

    Stripe.card.createToken $('form'), stripeResponseHandler
