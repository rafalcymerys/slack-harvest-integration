require 'rspec'
require 'rack/test'

require_relative '../application'

RSpec.configure do |config|
  config.include(Rack::Test::Methods, type: :controller)

  config.before(type: :controller) do
    def app
      described_class
    end
  end
end
