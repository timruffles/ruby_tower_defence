require 'yaml'
module Views
  class Ascii
    def view world
      puts "\e[H\e[2J" # clear screen
      actors_at_coords = world.actors_by_coords
      (world.y_size..0).each do |row_i|
        row = []
        (0..world.x_size).each do |col_i|
          at_coord = actors_at_coords[[col_i,row_i]]
          output = case at_coord
                     when nil
                       ' '
                     when at_coord.dead?
                       "O"
                     when Enemy
                       'Z'
                     when Player
                       'P'
                   end
          row << output
        end
        puts "|#{row.join(' ')}|\n"
      end
      @last_events ||= 0
      pp world.publish_context.events.slice(@last_events..-1)
      @last_events = world.publish_context.events.length
    end
  end
end