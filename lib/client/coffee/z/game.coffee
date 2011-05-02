$.get('http://localhost:4568/games/1',
  ((ticks) ->
    setup = ticks.shift()[0][3][0]
    console.log(setup)
    world = new World _.extend({el:$('#world')[0]},setup)
    feed = new Feed {el:$('#feed')[0]}
    dispatcher = new Dispatcher(ticks,setup.actors)
  ),
  'jsonp')


  

