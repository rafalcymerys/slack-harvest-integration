module Service
  class Harvest
    def active_entry
      harvest_client.time.all.select(&:timer_started_at).first
    end

    def toggle_entry(entry)
      harvest_client.time.toggle(entry.id)
    end

    def create_entry(entry)
      harvest_client.time.create(entry)
    end

    def update_entry(entry)
      harvest_client.time.update(entry)
    end

    private

    def harvest_client
      ::Harvest.client(subdomain: Configuration.harvest_subdomain,
                       username: Configuration.harvest_username,
                       password: Configuration.harvest_password)
    end
  end
end
