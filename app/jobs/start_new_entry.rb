module Jobs
  class StartNewEntry
    include Sidekiq::Worker

    def initialize
      @slack_service = Service::Slack.new
      @harvest_user_service = Service::HarvestUser.new
      @user_matcher = Matcher::SlackHarvestUser.new(slack_service, harvest_user_service)
      @message_serializer = Serializer::Message.new
    end

    def perform(command, slack_user_id, response_url)
      message = perform_command(command, slack_user_id)

      slack_service.respond(response_url, message_serializer.serialize(message))
    end

    private

    attr_reader :slack_service, :harvest_user_service, :user_matcher, :message_serializer

    def perform_command(command, slack_user_id)
      parser = Parser::EntryCommand.new
      harvest_user_id = user_matcher.harvest_user_id(slack_user_id)

      unless harvest_user_id
        return Response::Message.new(
          text: 'Could not find your Harvest account. Make sure you use the same email address for both Slack and Harvest.'
        )
      end

      harvest_time_service = Service::HarvestTime.new(harvest_user_id)

      parsed_command = parser.parse(command)

      project_lookup = Lookup::Project.new(harvest_time_service)
      projects = project_lookup.find(parsed_command.project)
      project = projects.first

      task_lookup = Lookup::Task.new(project)
      tasks = task_lookup.find(parsed_command.task)
      task = tasks.first

      task = Task::SwitchEntry.new(harvest_time_service, project_id: project.id, task_id: task.id,
                                         notes: parsed_command.notes, hours_ago: parsed_command.hours)

      task.execute

      Response::Message.new(text: "Now billing #{project.name} -> #{task.first.name}")
    end
  end
end
