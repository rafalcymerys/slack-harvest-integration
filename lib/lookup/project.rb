module Lookup
  class Project
    def initialize(harvest_time_service)
      @harvest_time_service = harvest_time_service
      @filter = FieldBasedFilter.new(:name, :code)
    end

    def find(phrase)
      projects = harvest_time_service.trackable_projects
      filter.filter(projects, phrase)
    end

    private

    attr_reader :harvest_time_service, :filter
  end
end
