class Ascii
  def view world
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
  end
end