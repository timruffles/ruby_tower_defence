World =
  render: ->
    html = ''
    for y in [0..@ySize]
      html += "<tr>"
      for x in [0..@xSize]
        html += "<td class='#{actor.type if actor}'></td>" for actor in atCoord(x,y)
      html += "</tr>"
  atCoord: (x,y) ->
    
    
    
      
      
  
