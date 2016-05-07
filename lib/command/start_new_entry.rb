module Command
  class StartNewEntry
    def initialize(parsed_command, harvest_time_service:)
      @slack_service = Service::Slack.new
      @harvest_time_service = harvest_time_service

      @parsed_command = parsed_command
    end

    def execute
      project_lookup = Lookup::Project.new(harvest_time_service)
      projects = project_lookup.find(parsed_command.project)

      if projects.empty?
        return Response::Message.new(text: Response::Text::PROJECT_NOT_FOUND)
      elsif projects.size > 1
        return Response::Message.new(text: Response::Text::MULTIPLE_PROJECTS_FOUND)
      end

      project = projects.first

      task_lookup = Lookup::Task.new(project)
      tasks = task_lookup.find(parsed_command.task)

      if tasks.empty?
        return Response::Message.new(text: Response::Text::TASK_NOT_FOUND)
      elsif tasks.size > 1
        return Response::Message.new(text: Response::Text::MULTIPLE_TASKS_FOUND)
      end

      task = tasks.first

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
