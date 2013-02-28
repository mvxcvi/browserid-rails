# Shared context for authenticated controller access.
shared_context "authenticated user" do
  let(:authenticated_email) { "user@example.com" }
  let(:browserid_current_user) { User.new.tap { |user| user.email = authenticated_email } }

  def authenticated_session(vars={})
    vars.update browserid_config.session_variable => authenticated_email
  end
end
