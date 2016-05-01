module Service
  class Harvest
    def initialize(user_id)
      @user_id = user_id
    end

    def active_entry
      harvest_client.time.all(Time.now, user_id).select(&:timer_started_at).first
    end

    def toggle_entry(entry)
      harvest_client.time.toggle(entry.id, user=user_id)
    end

    def create_entry(entry)
      harvest_client.time.create(entry, user=user_id)
    end

    def update_entry(entry)
      harvest_client.time.update(entry, user=user_id)
    end

    def trackable_projects
      harvest_client.time.trackable_projects(Time.now, user=user_id)
    end

    private

    attr_reader :user_id

    def harvest_client
      ::Harvest.client(subdomain: Configuration.harvest_subdomain,
                       username: Configuration.harvest_username,
                       password: Configuration.harvest_password)
    end
  end
end
