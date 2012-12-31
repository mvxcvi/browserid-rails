# Shared context for testing with browserid config.
shared_context "browserid config" do
  before { save_browserid_config }
  after { reload_browserid_config }

  # Helper method to access the engine configuration.
  def browserid_config
    Rails.application.config.browserid
  end

  # Saves a duplicate of the current browserid config.
  def save_browserid_config
    @saved_config = browserid_config.dup
  end

  # Reloads the saved browserid config.
  def reload_browserid_config
    Rails.application.config.browserid = @saved_config.dup
  end
end
