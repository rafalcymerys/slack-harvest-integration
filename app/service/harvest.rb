module Service
  class Harvest
    def user_by_email(email)
      harvest_client.users.all.select { |user| user.email == email }.first
    end

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

    def trackable_projects
      harvest_client.time.trackable_projects
    end

    private

    def harvest_client
      ::Harvest.client(subdomain: Configuration.harvest_subdomain,
                       username: Configuration.harvest_username,
                       password: Configuration.harvest_password)
    end
  end
end
