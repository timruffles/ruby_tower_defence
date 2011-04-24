World = BB.View.extend
  initialize: (opts) ->
    d.sub 'tick', this, 'tick'
    @actors = opts.actors
    @x_size = 10
    @y_size = 7
    this.render()
  render: ->
    this.$().empty()
    unless @world_rendered
      @cells = {}
      for y in [0..@y_size]
        row = doc.createElement('tr')
        this.el.appendChild(row)
        for x in [0..@x_size]
          row.appendChild(cell = doc.createElement('td'))
          @cells["#{x},#{y}"] = cell
      @world_rendered = true
    for coords, cell of @cells
      cell.setAttribute('class','')
    for id, actor of @actors
      @cells["#{actor.x},#{actor.y}"].setAttribute('class',actor.type)
    null
  tick: (events) ->
    for event in events
      actor = @actors[event.aid]
      switch event.type
        when 'Move'
          actor = @actors[event.aid]
          @cells["#{actor.x},#{actor.y}"].setAttribute('class','')
          actor.x = event.x
          actor.y = event.y
          @cells["#{actor.x},#{actor.y}"].setAttribute('class',actor.type)
        when 'AttributeChange'
          for attribute, value in event.attributes
            actor.set attribute, value
    this.render()
    null
@World = World

    
      
      
  
