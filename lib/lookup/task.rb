module Lookup
  class Task
    def initialize(project)
      @project = project
      @filter = FieldBasedFilter.new(:name)
    end

    def find(phrase)
      tasks = project.tasks
      filter.filter(tasks, phrase)
    end

    private

    attr_reader :project, :filter
  end
end
