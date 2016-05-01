require 'rspec'
require 'rack/test'
require 'sidekiq/testing'

require_relative '../application'

RSpec.configure do |config|
  config.include(Rack::Test::Methods, type: :controller)

  config.before(type: :controller) do
    def app
      described_class
    end

    Sidekiq::Testing.fake!
  end
end
