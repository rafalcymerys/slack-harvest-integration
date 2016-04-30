module Security
  class SlackRequestValidator
    def validate_request(params)
      raise Security::InvalidTokenError unless params[:token] == Configuration.slack_token
      raise Security::InvalidDomainError unless params[:team_domain] == Configuration.slack_domain
    end
  end
end
