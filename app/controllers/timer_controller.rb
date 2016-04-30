module Controllers
  class TimerController < Sinatra::Base
    post '/' do
      request_validator.validate_request(params)

      'testcior'
    end

    private

    def request_validator
      Security::SlackRequestValidator.new
    end
  end
end
