@Dispatcher = (ticks, actors) ->
  tickNo = 0
  @tick = =>
    tickNo++
    dojo.pub 'tickStart'
    messages = ticks.shift()
    for message in messages
      [event, subjectType, subjectId, args...] = message
      msg = [event, [subjectType, actors[subjectId], args...]]
      console.log("publishing #{tickNo}",msg...)
      dojo.pub(msg...)
    dojo.pub 'tickEnd'
    setTimeout @tick, 500 unless ticks.length == 0
    null
  setTimeout @tick, 500

