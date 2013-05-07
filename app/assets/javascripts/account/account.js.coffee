class AccountAccountController
    init: ->
      UrbanFinchApp.nav()
      
    edit: ->
      $('a#regenerate').click (event) ->
        event.preventDefault()
        $.getJSON $(this).attr('href'), (data) ->
          $('input#account_api_secret').val(data.account.api_secret)
      
UrbanFinchApp.account_account = new AccountAccountController