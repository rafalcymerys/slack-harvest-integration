module Jobs
  class StartNewEntry
    include Sidekiq::Worker

    def initialize
      @slack_service = Service::Slack.new
      @harvest_user_service = Service::HarvestUser.new
    end

    def perform(command, slack_user_id, response_url)
      parser = Parser::EntryCommand.new
      harvest = Service::HarvestTime.new(harvest_user_id(slack_user_id))

      parsed_command = parser.parse(command)

      project_lookup = Lookup::Project.new(harvest)
      project = project_lookup.find(parsed_command.project)

      task_lookup = Lookup::Task.new(project)
      task = task_lookup.find(parsed_command.task)

      command = Command::SwitchEntry.new(harvest, project_id: project.id, task_id: task.id,
                                         notes: parsed_command.notes, hours_ago: parsed_command.hours)

      command.execute

      slack_service.respond(response_url, "Now billing #{project.name} -> #{task.name}")
    end

    private

    attr_reader :slack_service, :harvest_user_service

    def harvest_user_id(slack_user_id)
      matcher = Matcher::SlackHarvestUser.new(slack_service, harvest_user_service)
      matcher.harvest_user_id(slack_user_id)
    end
  end
end
