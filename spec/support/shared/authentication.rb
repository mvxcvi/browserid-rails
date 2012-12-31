# Shared context for authenticated controller access.
shared_context "authenticated user" do
  let(:authenticated_email) { "user@example.com" }
  let(:current_user) { User.new.tap { |user| user.email = authenticated_email } }

  def authenticated_session(vars={})
    vars.update browserid_config.session_variable => authenticated_email
  end
end

# User model stub.
class User
  attr_accessor :email
end
