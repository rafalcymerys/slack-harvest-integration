module Parser
  class EntryCommandResult
    def initialize(project:, task:, notes:, hours: nil)
      @project = project
      @task = task
      @notes = notes
      @hours = hours
    end

    attr_reader :project, :task, :notes, :hours
  end
end
