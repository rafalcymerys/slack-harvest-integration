module Lookup
  class Task
    def initialize(tasks)
      @tasks = tasks
      @filter = FieldBasedFilter.new(:name)
    end

    def find(phrase)
      filter.filter(tasks, phrase)
    end

    private

    attr_reader :tasks, :filter
  end
end
