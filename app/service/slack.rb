module Service
  class Slack
    def respond(url, message)
      params = {text: message}
      RestClient.post(url, params.to_json, :content_type => :json, :accept => :json)
    end
  end
end
