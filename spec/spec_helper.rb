ENV['RACK_ENV'] = 'test'

require 'rack/test'
require_relative '../lib/app'

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.include Rack::Test::Methods
end
