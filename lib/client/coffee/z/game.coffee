$ ->
  world = new World {el:$('#world')[0],actors:actors}
  feed = new Feed {el:$('#feed')[0]}

tick = ->
  next = ticks.pop()
  if next
    console.log 'ticked to', next
    dojo.pub 'tick', [next]
    setTimeout tick, 500
  null

tick()
  


