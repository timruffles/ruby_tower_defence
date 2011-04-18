module Views
  class Ascii
    defaults :last_events => []
    def view world
      puts "\e[H\e[2J"
      actors_at_coords = world.actors_by_coords
      (0..world.y_size).each do |row_i|
        row = []
        (0..world.x_size).each do |col_i|
          at_coord = actors_at_coords[[col_i,row_i]]
          output = case at_coord
                     when nil
                       ' '
                     when Enemy
                       'E'
                     when Player
                       'P'
                   end
          row << output
        end
        puts "|#{row.join(' ')}|\n"
      end
      puts (world.publish_context.events - last_events).inspect
      last_events = world.publish_context.events
    end
  end
end