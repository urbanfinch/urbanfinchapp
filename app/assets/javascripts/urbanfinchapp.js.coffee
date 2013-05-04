window.UrbanFinchApp ?=
  init: ->
    $(document).ready ->
      UrbanFinchApp.bootstrap()
          
  bootstrap: ->
    body = $('body')
    controller = body.data('controller').replace(/\//g, '_')
    action = body.data('action')

    active_controller = UrbanFinchApp[controller]

    if active_controller != undefined
      if $.isFunction active_controller.init
        active_controller.init()

      if $.isFunction active_controller[action]
        active_controller[action]()
        
  nav: ->
    nav = $('nav.content_nav')
    content_divs = $('div.content_div')
    
    content_divs.hide();
    content_divs.eq(0).show();
    
    $('a', nav).click (event) ->
      $('div', nav).removeClass('selected')
      $(this).parent().addClass('selected')
      
      content_div = $(this).attr('href').split('#')[1]
      
      content_divs.hide();
      content_divs.filter('#' + content_div).show()
      
      event.preventDefault()
      
  form: ->
    $('form').on 'click', '.remove_fields', (event) ->
        $(this).prev('input[type=hidden]').val('1')
        $(this).closest('fieldset').hide()
        event.preventDefault()
        
    $('form').on 'click', '.add_fields', (event) ->
        time = new Date().getTime()
        regexp = new RegExp($(this).data('id'), 'g')
        $(this).closest('.content_div').find('.fields').append($(this).data('fields').replace(regexp, time))
        event.preventDefault()
        
  import_export: ->
    $('a.import_export').click (event) ->
      $('div.import_export').slideToggle({duration: 200, easing: 'linear'})
      event.preventDefault()
      
  tree: ->
    $('.tree ul').hide()
    $('.tree li span').click (event) ->
      $(this).siblings('ul').toggle()
      $(this).parent().toggleClass('opened')
      $(this).parent().toggleClass('closed')
    $('.tree > ul').show()

UrbanFinchApp.init()