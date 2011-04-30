# test
zombies = ['ugly zombie','smelly zombie']
players = ['Joe','Fred']
types = Severities_by_type.keys

(1..10).to_a.each do |n|
  p injury_phrase players.sample, Severities_by_type.keys.sample, zombies.sample,  Body.parts.sample, (rand * 100).to_i
end