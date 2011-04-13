#!/Users/timruffles/.rvm/rubies/ruby-1.9.2-p0/bin/ruby
require_relative '../lib/engine'
ascii = Views::Ascii.new
world = World.new :actors => [Zombie.new, Player.new]
world.universalise
world.run do |world|
  ascii.view world
end