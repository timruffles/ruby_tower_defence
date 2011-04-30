require 'bundler'
Bundler.setup
require 'active_support/core_ext/module'
require 'active_support/core_ext/class'
require 'geometry'

require 'pp'

require_relative 'core_ext'
require_relative 'hash_initializer'
require_relative 'sorted_queue'

require_relative 'publish'
require_relative 'area'
  require_relative 'areas/random'
require_relative 'world'
require_relative 'actors'
require_relative 'abilities'
require_relative 'views/ascii'

require_relative 'ai'
require_relative 'ai/base'
Dir.glob(File.dirname(__FILE__) + '/ai/*.rb').each do |file|
  require file
end