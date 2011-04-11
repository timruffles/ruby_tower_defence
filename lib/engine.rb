require 'bundler'
Bundler.setup
require 'active_support/core_ext/module'

def lib_path path
  File.join(File.dirname(__FILE__),'..','lib',path)
end

require_relative 'core_ext'
require_relative 'util'

require_relative 'publish'
require_relative 'map'
require_relative 'world'
require_relative 'actors'
require_relative 'abilities'
