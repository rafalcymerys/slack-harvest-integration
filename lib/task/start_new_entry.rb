module Task
  class StartNewEntry
    def initialize(harvest_time_service, project_id:, task_id:, notes:, hours_ago: nil)
      @harvest_time_service = harvest_time_service
      @project_id = project_id
      @task_id = task_id
      @notes = notes
      @hours_ago = hours_ago
    end

    def execute
      entry = Harvest::TimeEntry.new(project_id: project_id, task_id: task_id, notes: notes, hours: hours_ago)
      created_entry = harvest_time_service.create_entry(entry)

      harvest_time_service.toggle_entry(created_entry) if hours_ago

      true
    end

    private

    attr_reader :harvest_time_service, :project_id, :task_id, :notes, :hours_ago
  end
end
