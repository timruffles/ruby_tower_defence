require 'bundler'
Bundler.setup
require 'active_support/core_ext/module'
require 'active_support/core_ext/class'

require 'active_support/callbacks'
Bundler.require :always_require

require 'pp'
require 'json'

require_relative 'core_ext'
require_relative 'hash_initializer'
require_relative 'sorted_queue'
require_relative 'has_identity'


require_relative 'publish'
require_relative 'area'
  require_relative 'areas/random'
require_relative 'world'
require_relative 'actors'
require_relative 'abilities'
require_relative 'api'
require_relative 'runner/test'


require_relative 'ai'
require_relative 'ai/base'
Dir.glob(File.dirname(__FILE__) + '/ai/*.rb').each do |file|
  require file
end