module Service
  class Slack
    def respond(url, message)
      RestClient.post(url, message)
    end
  end
end
