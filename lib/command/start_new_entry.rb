module Command
  class StartNewEntry
    def initialize(harvest_service, project_id:, task_id:, notes:, hours_ago: nil)
      @harvest_service = harvest_service
      @project_id = project_id
      @task_id = task_id
      @notes = notes
      @hours_ago = hours_ago
    end

    def execute
      entry = Harvest::TimeEntry.new(project_id: project_id, task_id: task_id, notes: notes, hours: hours_ago)
      created_entry = harvest_service.create_entry(entry)

      harvest_service.toggle_entry(created_entry) if hours_ago

      true
    end

    private

    attr_reader :harvest_service, :project_id, :task_id, :notes, :hours_ago
  end
end
