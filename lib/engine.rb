require 'bundler'
Bundler.setup
require 'active_support/core_ext/module'
require 'active_support/core_ext/class'
require 'geometry'

require 'pp'

require_relative 'core_ext'
require_relative 'util'

require_relative 'publish'
require_relative 'map'
require_relative 'world'
require_relative 'ai'
require_relative 'actors'
require_relative 'abilities'
require_relative 'views/ascii'
