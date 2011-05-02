@World = BB.View.extend
  initialize: (opts) ->
    _.extend(this,opts)
    for event in ['moved','change'] #'ranged','melee']
       dojo.sub event, this, "on_#{event}"
    dojo.sub 'tickStart', this, 'render'
    null
  render: ->
    this.$().empty()
    unless @world_rendered
      @cells = {}
      for y in [0..@area.y_size]
        row = doc.createElement('tr')
        this.el.appendChild(row)
        for x in [0..@area.x_size]
          row.appendChild(cell = doc.createElement('td'))
          @cells["#{x},#{y}"] = cell
      @world_rendered = true
    for coords, cell of @cells
      cell.setAttribute('class','')
    for id, actor of @actors
      @cells[actor.point].setAttribute('class',actor.type)
    null
  on_moved: (type,actor,newPos,oldPos) ->
    p 'on moved'
    actor.point = newPos
  on_change: (type,actor,attribute,newVal) ->
    p 'on change'
    actor[attribute] = newVal