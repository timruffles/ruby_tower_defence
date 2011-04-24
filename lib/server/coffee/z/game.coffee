actors = {
  1: {
    x: 3,
    y: 3,
    hps: 10,
    type: "Player"
  },
  2: {
    x: 5,
    y: 3,
    name: 'Zombie',
    type: "Zombie"
  }
}
ticks = [
  [
    {
      aid: 2,
      type: 'Move',
      x: 4
      y: 3
    }
  ],
  [
    {
      aid: 2,
      type: 'Attack',
      description: "Zombie bites your finger!"
    },
    {
       aid: 1,
       type: 'AttributeChange',
       attributes: {
         hps: 9
       }
    }
  ]
]

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
  


