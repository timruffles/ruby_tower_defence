module Areas
  class Random < Area
    def tick
      super
      if world.actors.length < target_population && world.tick - last_spawn < spawn_rate_ticks
        spawn actors_to_spawn * chunk_size
        last_spawn = world.tick
      end
    end
    def spawn num
      (0..num).each do |y|
        world.actors << Zombie.new(:x => world.right, :y => y)
      end
      self.actors_to_spawn -= num
    end
  end
end