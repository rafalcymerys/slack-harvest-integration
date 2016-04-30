module Lookup
  class Project
    def initialize(harvest_service)
      @harvest_service = harvest_service
    end

    def find(phrase)
      projects = trackable_projects
      downcase_phrase = phrase.downcase

      exact_matches = exact_matches(downcase_phrase, projects)
      return exact_matches.first if exact_matches.count == 1

      partial_matches = partial_matches(downcase_phrase, projects)
      return partial_matches.first if partial_matches.count == 1

      partial_matches
    end

    private

    attr_reader :harvest_service

    def trackable_projects
      harvest_service.time.trackable_projects
    end

    def exact_matches(phrase, projects)
      projects.select { |project| project.name.downcase == phrase || project.code&.downcase == phrase }
    end

    def partial_matches(phrase, projects)
      projects.select do |project|
        project.name.downcase.start_with?(phrase) || project.code&.downcase&.start_with?(phrase)
      end
    end
  end
end
