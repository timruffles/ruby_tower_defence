require 'yaml'
module Views
  class Ascii
    def view world
      puts "\e[H\e[2J" # clear screen
      world.y_size.downto(0).each do |row_i|
        row = []
        (0..world.x_size).each do |col_i|
          at_coord = world.at_coords[p(col_i,row_i)]
          output = at_coord.empty? ? ' ' : at_coord.map do |actor|
            case actor
              when Enemy
                'Z'
              when Player
                'P'
            end
          end.join('')
          row << output
        end
        puts "|#{row.join(' ')}|\n"
      end
      msgs = world.publish_context.messages
      pp msgs.to_json
    end
  end
end