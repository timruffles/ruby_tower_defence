#!/usr/bin/ruby
require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :server

ROOT_DIR = Pathname.new(File.dirname(__FILE__)).realpath
set :public, ROOT_DIR

Dir.glob("jssrc/**/*.js").each do |js|
  `rm -rf js && mkdir js`
  rep = js.split('/')
  dir = ['js'].concat(rep.slice(1...-1)).join('/')
  file = rep.slice(-1)
  `mkdir -p #{dir}`
  cmd = "ln -s #{ROOT_DIR}/#{js} #{ROOT_DIR}/#{dir}/#{file}"
  `#{cmd}`
end

get "/" do
  haml :index
end
get "/new" do
end
get "/:id" do |id|
end

# sass handler
get /\/(.*)\.css$/ do |stylesheet|
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass stylesheet.to_sym
end

# coffee script handler
get %r{/(.*)\.js$} do |js|
  # compile coffee script and place in respective JS folder
  js = js.split('/').slice(1..-1).join('/')
  coffee = "#{ROOT_DIR}/coffee/#{js}.coffee"
  target = "#{ROOT_DIR}/js/#{js}.js"
  if File.exists? coffee
    output = CoffeeScript.compile File.read(coffee)
  else
    output = open "#{ROOT_DIR}/jssrc/#{js}.js"
  end
  output
end