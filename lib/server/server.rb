#!/usr/bin/ruby
require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :client

require_relative '../engine'

get '/games/:id' do |id|
  messages = Runner::Test.run
  "#{params[:callback]}(#{messages.to_json});"
end