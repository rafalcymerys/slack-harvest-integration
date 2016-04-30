module Lookup
  class Project
    def initialize(harvest_service)
      @harvest_service = harvest_service
      @filter = FieldBasedFilter.new(:name, :code)
    end

    def find(phrase)
      projects = harvest_service.trackable_projects
      filter.filter(projects, phrase)
    end

    private

    attr_reader :harvest_service, :filter
  end
end
