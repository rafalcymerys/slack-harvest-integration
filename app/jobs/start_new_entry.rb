module Jobs
  class StartNewEntry
    include Sidekiq::Worker

    def initialize
      @slack_service = Service::Slack.new
    end

    def perform(command, response_url)
      parser = Parser::EntryCommand.new
      harvest = Service::Harvest.new

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

    attr_reader :slack_service
  end
end
