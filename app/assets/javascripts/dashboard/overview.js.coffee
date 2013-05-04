class DashboardOverviewController
    init: ->
      
    index: ->
      chart = $('nav div.nav_left a.selected').data('value')
      period = $('nav div.nav_right a.selected').data('value')
      $.getJSON $('div.nav_left a.selected').attr('href'), { chart: chart, period: period }, (data) ->
        $('canvas#dashboard_chart').chart(data)
        
      $('.chart nav a').click (event) ->
        $(this).siblings().removeClass('selected')
        $(this).addClass('selected')
        
        chart = $('nav div.nav_left a.selected').data('value')
        period = $('nav div.nav_right a.selected').data('value')
        
        options = {}
        if period == 180
          options.division = 15
        else if period == 90
          options.division = 5
          
        $.getJSON $(this).attr('href'), { chart: chart, period: period }, (data) ->
          $('canvas#dashboard_chart').chart(data, options)
        
        event.preventDefault()
      
UrbanFinchApp.dashboard_overview = new DashboardOverviewController