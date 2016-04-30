module Command
  class FinishCurrentEntry
    def initialize(harvest_service, hours_ago: nil)
      @harvest_service = harvest_service
      @hours_ago = hours_ago
    end

    def execute
      active_entry = harvest_service.active_entry
      return false unless active_entry

      harvest_service.toggle_entry(active_entry)
      subtract_hours(active_entry)

      true
    end

    private

    attr_reader :harvest_service, :hours_ago

    def subtract_hours(active_entry)
      if hours_ago
        active_entry.hours -= hours_ago
        harvest_service.update_entry(active_entry)
      end
    end
  end
end
