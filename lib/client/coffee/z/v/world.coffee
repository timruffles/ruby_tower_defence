@World = BB.View.extend
  initialize: (opts) ->
    _.extend(this,opts)
    for event in ['moved','change','ranged','melee','add_actor','stats','lost']
       dojo.sub event, this, "on_#{event}"
    dojo.sub 'tickStart', this, 'render'
    null
  render: ->
    unless @world_rendered
      @cells = {}
      for y in [0..@area.y_size]
        row = doc.createElement('ul')
        this.el.appendChild(row)
        for x in [0..@area.x_size]
          row.appendChild(cell = doc.createElement('li'))
          @cells["#{x},#{y}"] = cell
      @world_rendered = true
    for coords, cell of @cells
      cell.setAttribute('class','')
      $(cell).empty()
    for id, actor of @actors
      @cells[actor.point].setAttribute('class',actor.type)
    null
  on_add_actor: (type,actor,newActor) ->
    @actors[newActor.id] = newActor
  on_moved: (type,actor,newPos,oldPos) ->
    actor.point = newPos
  on_change: (type,actor,attribute,newVal) ->
    actor[attribute] = newVal
  on_ranged: (type,actor,victimId,dmg) ->
    $(@cells[actor.point]).addClass('ranged')
    if @actors[victimId]
      @cells[@actors[victimId].point].appendChild($("<div class='change negative'>#{dmg}</div>")[0])
  on_melee: (type,actor,victimId,dmg) ->
    $(@cells[actor.point]).addClass('melee')
    @cells[actor.point].setAttribute('class',"#{actor.type}_melee")
    if @actors[victimId]
      @cells[@actors[victimId].point].appendChild($("<div class='change negative'>#{dmg}</div>")[0])
    null
  on_stats: (type, actor, stats) ->
    @stats = stats
  on_lost: ->
    alert("You fought hard, firing #{@stats.shots}, killing #{@stats.zombies_killed} and losing #{@stats.player_hps_lost}hps before you perished.")