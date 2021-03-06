module Task
  class SwitchEntry
    def initialize(harvest_time_service, project_id:, task_id:, notes:, hours_ago: nil)
      finish_current_entry = FinishCurrentEntry.new(harvest_time_service, hours_ago: hours_ago)
      start_new_entry = StartNewEntry.new(harvest_time_service, project_id: project_id, task_id: task_id, notes: notes,
                                          hours_ago: hours_ago)

      @tasks = [finish_current_entry, start_new_entry]
    end

    def execute
      tasks.each(&:execute)

      true
    end

    private

    attr_reader :tasks
  end
end
