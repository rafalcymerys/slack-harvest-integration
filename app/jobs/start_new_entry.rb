module Jobs
  class StartNewEntry
    include Sidekiq::Worker

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
    end
  end
end
