require 'rspec'
require 'pathname'
lib_path = Pathname.new(File.join(File.dirname(__FILE__),'..','lib'))
lib = Class.new do
  define_method :req do |path|
    require lib_path.join(path).to_s
  end
end
Lib = lib.new