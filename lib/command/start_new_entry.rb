module Command
  class StartNewEntry
    def initialize(parsed_command, harvest_time_service:)
      @slack_service = Service::Slack.new
      @harvest_time_service = harvest_time_service

      @parsed_command = parsed_command
    end

    def execute
      project_lookup = Lookup::Project.new(harvest_time_service)
      project_match = project_lookup.find(parsed_command.project)

      if project_match.empty?
        return Response::Message.new(text: Response::Text::PROJECT_NOT_FOUND)
      elsif project_match.multiple?
        return Response::Message.new(text: Response::Text::MULTIPLE_PROJECTS_FOUND)
      end

      project = project_match.get

      task_lookup = Lookup::Task.new(project)
      task_match = task_lookup.find(parsed_command.task)

      if task_match.empty?
        return Response::Message.new(text: Response::Text::TASK_NOT_FOUND)
      elsif task_match.multiple?
        return Response::Message.new(text: Response::Text::MULTIPLE_TASKS_FOUND)
      end

      task = task_match.get

      switch_entry_task = Task::SwitchEntry.new(harvest_time_service, project_id: project.id, task_id: task.id,
                                   notes: parsed_command.notes, hours_ago: parsed_command.hours)

      switch_entry_task.execute

      Response::Message.new(text: "Now billing #{project.name} -> #{task.name}")
    end

    private

    attr_reader :slack_service, :harvest_time_service
    attr_reader :parsed_command
  end
end
