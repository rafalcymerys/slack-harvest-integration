module Lookup
  class Project
    def initialize(projects)
      @projects = projects
      @filter = FieldBasedFilter.new(:name, :code)
    end

    def find(phrase)
      filter.filter(projects, phrase)
    end

    private

    attr_reader :projects, :filter
  end
end
