JS.require 'z.v.World', 'z.v.Feed', 'libs.dojo.Dojo' ->
  actors = {
    1: {
      x: 3,
      y: 3,
      hps: 10
    },
    2: {
      x: 5,
      y: 3,
      name: 'Zombie'
    }
  }
  ticks = [
    [
      {
        aid: 2,
        type: 'AttributeChange',
        attributes: {
          x: 4
        }
      }
    ],
    [
      {
        aid: 2,
        type: 'Attack',
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

  world = new World actors
  feed = new Feed

  tick = ->
    next = ticks.pop
    if next
      for event in next
        dojo.pub 'event', event


