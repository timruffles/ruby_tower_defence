@Dispatcher = (ticks, actors) ->
  tickNo = 0
  @tick = =>
    tickNo++
    dojo.pub 'tickStart'
    messages = ticks.shift()
    for message in messages
      [event, subjectType, subjectId, args...] = message
      if actors[subjectId]
        console.log("publishing #{tickNo}",event, [subjectType, actors[subjectId], args...])
        dojo.pub event, [subjectType, actors[subjectId], args...]
    dojo.pub 'tickEnd'
    setTimeout @tick, 500 unless ticks.length == 0
    null
  setTimeout @tick, 500

