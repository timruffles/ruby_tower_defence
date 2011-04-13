require 'rspec'
require 'mocha'
require_relative '../lib/engine'
RSpec.configure do |config|
  config.mock_framework = :mocha
end