#!/Users/timruffles/.rvm/rubies/ruby-1.9.2-p0/bin/ruby
require_relative '../lib/engine'
require 'pp'
ascii = Views::Ascii.new
world = World.new(:area => Areas::Random.new(:x_size => 20, :y_size => 20, :actors_to_spawn => 10, :chunk_size => 0.1, :spawn_rate_ticks => 5, :target_population => 4))
world.universalise
world.actors = [Zombie.new(:x => 10, :y => 2),Zombie.new(:x => 6, :y => 2, :hps => 15), Player.new]
world.run do |world|
  ascii.view(world)
end