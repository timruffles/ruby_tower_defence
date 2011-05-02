module Runner
  class Test
    def self.run
      world = World.new(
        :actors => [Zombie.new(:x => 10, :y => 2),Zombie.new(:x => 6, :y => 2, :hps => 14), Player.new],
        :area => Areas::Random.new(:x_size => 20, :y_size => 20, :actors_to_spawn => 10, :chunk_size => 0.1, :spawn_rate_ticks => 5, :target_population => 4))
      world.run
      world.messages_for_client
    end
  end
end