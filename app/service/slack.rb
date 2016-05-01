module Service
  class Slack
    def initialize(client=nil)
      @client = client || ::Slack.client(token: Configuration.slack_api_token)
    end

    def respond(url, message)
      params = {text: message}
      RestClient.post(url, params.to_json, :content_type => :json, :accept => :json)
    end

    def email_for_user(user_id)
      response = client.users_info(user: user_id)
      response['user']['profile']['email'] if response['ok']
    end

    private

    attr_reader :client
  end
end
