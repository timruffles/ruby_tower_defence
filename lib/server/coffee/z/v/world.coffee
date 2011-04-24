class World
  constructor: ->
    d sub 'event', this, 'event'
  render: ->
    unless @world_rendered
      @cells = {}
      for y in [0..@y_size]
        row = doc.createElement('tr')
        for x in [0..@x_size]
          row.appendChild(cell = doc.createElement('td'))
          @cells["#{x},#{y}"] = cell
    cell for cell in @cells
      cell.attr('class','')
    actor for actor in @actors
      $(@cells["#{actor.x},#{actor.y}"]).attr('class',actor.type)
  event:  ->
    actor = @actors[event.aid]
    switch event.type
      when 'AttributeChange'
        for attribute, value in event.attributes
          actor.set attribute, value
    
    
    
      
      
  
