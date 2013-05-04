class AccountAccountController
    init: ->
      UrbanFinchApp.nav()
      
    index: ->
      $('a#regenerate').click (event) ->
        event.preventDefault()
        $.getJSON $(this).attr('href'), (data) ->
          $('input#account_secret').val(data.account.secret)
      
UrbanFinchApp.account_account = new AccountAccountController