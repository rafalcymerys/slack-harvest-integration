module Command
  class SwitchEntry
    def initialize(harvest_service, project_id:, task_id:, notes:, hours_ago: nil)
      finish_current_entry = FinishCurrentEntry.new(harvest_service, hours_ago: hours_ago)
      start_new_entry = StartNewEntry.new(harvest_service, project_id: project_id, task_id: task_id, notes: notes,
                                          hours_ago: hours_ago)

      @commands = [finish_current_entry, start_new_entry]
    end

    def execute
      commands.each(&:execute)

      true
    end

    private

    attr_reader :commands
  end
end
