module Jobs
  class StartNewEntry
    include Sidekiq::Worker

    def initialize
      @slack_service = Service::Slack.new
      @harvest_user_service = Service::HarvestUser.new
      @user_matcher = Matcher::SlackHarvestUser.new(slack_service, harvest_user_service)

      @parser = Parser::EntryCommand.new
      @message_serializer = Serializer::Message.new
    end

    def perform(command, slack_user_id, response_url)
      message = perform_command(command, slack_user_id)

      slack_service.respond(response_url, message_serializer.serialize(message))
    end

    private

    attr_reader :slack_service, :harvest_user_service, :user_matcher, :parser, :message_serializer

    def perform_command(command, slack_user_id)
      parsed_command = parser.parse(command)

      harvest_user_id = user_matcher.harvest_user_id(slack_user_id)

      unless harvest_user_id
        return Response::Message.new(
          text: Response::Text::USER_NOT_FOUND
        )
      end

      harvest_time_service = Service::HarvestTime.new(harvest_user_id)

      command = Command::StartNewEntry.new(parsed_command, harvest_time_service: harvest_time_service)
      command.execute
    end
  end
end
