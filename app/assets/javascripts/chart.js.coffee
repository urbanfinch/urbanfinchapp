(($) ->
  
  Chart =
    init: (canvas, context, data = [], options = {}) ->
      Chart.animating = false
      Chart.animation_counter = 0
      Chart.animationFrame = window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or (callback) ->
        window.setTimeout callback, 1000 / 60
      
      Chart.canvas = canvas
      Chart.context = context
      Chart.data = data
      Chart.options = options
      
      Chart.points = []
      
      Chart.height = $(canvas).height() - (2 * options.offset)
      Chart.width = $(canvas).width() - (2 * options.offset)
      Chart.origin =
        x: Chart.options.offset
        y: Chart.options.offset + Chart.height
        
      Chart.x_max = Chart.data.length - 1
      Chart.y_max = 0
      $(Chart.data).each (index, value) ->
        if parseInt(value) > Chart.y_max
          Chart.y_max = parseInt(value)
          
      Chart.context.font = "8pt Garamond"
      
      context.save()
      context.setTransform(1, 0, 0, 1, 0, 0)
      context.clearRect(0, 0, canvas.width, canvas.height)
      context.restore()
        
    draw: ->
      Chart.animating = true
      
      Chart.context.save()
      Chart.context.setTransform(1, 0, 0, 1, 0, 0)
      Chart.context.clearRect(0, 0, Chart.canvas.width, Chart.canvas.height)
      Chart.context.restore()
      
      Chart.drawScale()
      Chart.drawData(Chart.animation_counter)
      Chart.animation_counter += 2
      
      if Chart.animation_counter <= 100
        Chart.animationFrame.call window, ->
          Chart.draw()
      else
        Chart.animating = false
        console.log(Chart.points)
        
    drawScale: ->
      Chart.context.lineWidth = 2.0
      Chart.drawLine(Chart.origin.x, Chart.origin.y, Chart.width + Chart.options.offset, Chart.origin.y, Chart.options.scale_color)
      Chart.drawLine(Chart.origin.x, Chart.origin.y, Chart.origin.x, Chart.options.offset, Chart.options.scale_color)
      Chart.context.lineWidth = 1.0
      Chart.drawMarkers()

    drawData: (animation_counter) ->
      if Chart.data
        last_point = {
          x: 0
          y: 0
        }
      
        $(Chart.data).each (index, value) ->
          x = Chart.origin.x + (Chart.width / Chart.x_max) * index
          y = Chart.origin.y - (((value / Chart.y_max) * (Chart.animation_counter / 100)) * Chart.height)
        
          if index > 0
            Chart.drawLine(last_point.x, last_point.y, x, y, Chart.options.line_color)
          last_point.x = x
          last_point.y = y
        
        $(Chart.data).each (index, value) ->
          x = Chart.origin.x + (Chart.width / Chart.x_max) * index
          y = Chart.origin.y - (((value / Chart.y_max) * (Chart.animation_counter / 100)) * Chart.height)
          Chart.drawCircle(x, y, Chart.options.radius, Chart.options.point_color)
          
          if Chart.animation_counter == 100
            Chart.points.push({x: x, y: Chart.height + Chart.options.offset - (((value / Chart.y_max) * (Chart.animation_counter / 100)) * Chart.height)})
        
    drawMarkers: ->
      i = 0
      while i <= Chart.x_max
        if i % Chart.options.division == 0 || i == 0 || i == Chart.x_max
          distance = ((Chart.width / Chart.x_max) * i) - (Chart.context.measureText(i).width * 0.5)
          marker_x = Chart.origin.x + distance
          marker_y = Chart.origin.y + 14
          Chart.context.fillStyle = Chart.options.label_color;
          Chart.context.fillText Chart.x_max - i, marker_x, marker_y, 20
        i++
      Chart.context.save()
      
    hitIndex: (element, event) ->
      canvasX = event.pageX - $(element).offset().left
      canvasY = event.pageY - $(element).offset().top
      
      hit = false
      i = 0
      $(Chart.points).each (index, point) ->
        if (canvasX > point.x - 5 && canvasX < point.x + 5) && (canvasY > point.y - 5 && canvasY < point.y + 5)
          hit = true
          i = index
          
      if hit
        i
      else
        false
      
    drawLabel: (element, event) ->
      index = Chart.hitIndex(element, event)
      if index != false
        value = Chart.data[index]
        point = Chart.points[index]
        Chart.context.fillStyle = Chart.options.label_color;
        Chart.context.fillText value, point.x + 5, point.y - 5, 20
      
    drawCircle: (x, y, radius, color) ->
      Chart.context.beginPath()
      Chart.context.arc(x, y, radius, 0, 2 * Math.PI, false)
      Chart.context.fillStyle = color
      Chart.context.fill()
      
    drawLine: (x, y, X, Y, color) ->
      Chart.context.beginPath()
      Chart.context.moveTo(x, y)
      Chart.context.lineTo(X, Y)
      Chart.context.closePath()
      Chart.context.strokeStyle = color
      Chart.context.stroke()
      
  $.fn.chart = (data = [], options = {}) ->
    
    settings = $.extend(
      point_color: "#666666"
      line_color: "#999999"
      scale_color: "#111111"
      label_color: "#333333"
      x_label: "X"
      y_label: "Y"
      offset: 20
      division: 1
      radius: 5
    , options)
    
    @each ->
      canvas = $(this)[0]
      if canvas && canvas.getContext
        context = canvas.getContext('2d')
        
      Chart.init(canvas, context, data, settings)
      Chart.draw()
      
      $(this).click (event) ->
        if !Chart.animating
          Chart.drawLabel(this, event)
      
    return this
) jQuery