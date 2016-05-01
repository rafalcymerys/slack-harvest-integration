module Service
  class HarvestUser
    def user_id_for_email(email)
      harvest_client.users.all.select { |user| user.email == email }.map(&:id).first
    end

    private

    def harvest_client
      ::Harvest.client(subdomain: Configuration.harvest_subdomain,
                       username: Configuration.harvest_username,
                       password: Configuration.harvest_password)
    end
  end
end
