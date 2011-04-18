require 'bundler'
Bundler.setup
require_relative '../engine'
get "/" do
  puts "<a href='/new'>New Game</a>"
end
get "/new" do
end
get "/:id" do |id|
end

ROOT_DIR = Pathname.new(File.dirname(__FILE__)).realpath

# sass handler
get /\/(.*)\.css/ do |stylesheet|
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass stylesheet.to_sym
end

# coffee script handler
get %r{/(.*)\.js} do |js|
  # compile coffee script and place in respective JS folder
  coffee = "#{ROOT_DIR}/js/#{js}.coffee"
  target = "#{ROOT_DIR}/js/compiled/#{js}.js"
  raise "Couldn't find #{coffee}" unless File.exists? coffee
  output = CoffeeScript.compile File.read(coffee)
  File.open(target,'w+') {|f| f.puts output }
  output
end