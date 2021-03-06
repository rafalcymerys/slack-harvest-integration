module Matcher
  class SlackHarvestUser
    def initialize(slack_service, harvest_user_service)
      @slack_service = slack_service
      @harvest_user_service = harvest_user_service
    end

    def harvest_user_id(slack_user_id)
      email = slack_service.email_for_user(slack_user_id)
      return nil unless email
      harvest_user_id = harvest_user_service.user_id_for_email(email)
      return nil unless harvest_user_id

      harvest_user_id
    end

    private

    attr_reader :slack_service, :harvest_user_service
  end
end
