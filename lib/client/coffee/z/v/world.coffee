@World = BB.View.extend
  initialize: (opts) ->
    _.extend(this,opts)
    # for event in ['moved','ranged','melee','change']
    #   dojo.sub event, this, "on#{event.ucfirst}"
  render: ->
    this.$().empty()
    unless @world_rendered
      @cells = {}
      for y in [0..@ySize]
        row = doc.createElement('tr')
        this.el.appendChild(row)
        for x in [0..@xSize]
          row.appendChild(cell = doc.createElement('td'))
          @cells["#{x},#{y}"] = cell
      @world_rendered = true
    for coords, cell of @cells
      cell.setAttribute('class','')
    for id, actor of @actors
      @cells["#{actor.x},#{actor.y}"].setAttribute('class',actor.type)
    null
  onMoved: (type,actor,newPos,oldPos) ->