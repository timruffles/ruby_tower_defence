#!/usr/bin/ruby
require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :client

require_relative '../engine'

get '/games/:id' do |id|
  messages = Runner::Test.run
  content_type "text/javascript"
  "#{params[:callback]}(#{messages});"
end