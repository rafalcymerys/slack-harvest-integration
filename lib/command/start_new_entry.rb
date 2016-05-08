module Command
  class StartNewEntry
    def initialize(parsed_command, harvest_time_service:)
      @slack_service = Service::Slack.new
      @harvest_time_service = harvest_time_service
      @error_message_factory = Response::ErrorMessageFactory.new

      @parsed_command = parsed_command
    end

    def execute
      project_lookup = Lookup::Project.new(harvest_time_service)
      project_match = project_lookup.find(parsed_command.project)

      return error_message_factory.message_for_incorrect_project(project_match) unless project_match.single?

      project = project_match.get

      task_lookup = Lookup::Task.new(project)
      task_match = task_lookup.find(parsed_command.task)

      return error_message_factory.message_for_incorrect_task(task_match) unless task_match.single?

      task = task_match.get

      switch_entry_task = Task::SwitchEntry.new(harvest_time_service, project_id: project.id, task_id: task.id,
                                                notes: parsed_command.notes, hours_ago: parsed_command.hours)

      switch_entry_task.execute

      Response::Message.new(text: "Now billing #{project.name} -> #{task.name}")
    end

    private

    attr_reader :slack_service, :harvest_time_service, :error_message_factory
    attr_reader :parsed_command
  end
end
