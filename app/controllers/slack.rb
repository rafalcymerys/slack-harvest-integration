module Controllers
  class Slack < Sinatra::Base
    post '/' do
      request_validator.validate_request(params)

      Jobs::StartNewEntry.perform_async(params[:text], params[:response_url])

      ''
    end

    private

    def request_validator
      Security::SlackRequestValidator.new
    end
  end
end
