class Configuration
  class << self
    def slack_token
      ENV['SLACK_TOKEN']
    end

    def slack_domain
      ENV['SLACK_DOMAIN']
    end

    def slack_api_token
      ENV['SLACK_API_TOKEN']
    end

    def harvest_subdomain
      ENV['HARVEST_SUBDOMAIN']
    end

    def harvest_username
      ENV['HARVEST_USERNAME']
    end

    def harvest_password
      ENV['HARVEST_PASSWORD']
    end
  end
end
