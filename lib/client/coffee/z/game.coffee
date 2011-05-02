$.getJSON('http://localhost:4568/games/1?callback=?',
  ((ticks) ->
    setup = ticks[0].shift()[3]
    console.log(setup)
    world = new World _.extend({el:$('#world')[0]},setup)
    feed = new Feed {el:$('#feed')[0]}
    dispatcher = new Dispatcher(ticks,setup.actors)
  ))


  

