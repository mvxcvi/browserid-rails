require 'spec_helper'

describe SessionsController do
  include_context "browserid config"
  include_context "authenticated user"

  describe "#browserid_email" do
    subject(:email) { controller.browserid_email }

    context "when not authenticated" do
      it { should be_nil }
    end

    context "when authenticated" do
      before do
        controller.login_browserid(authenticated_email)
      end

      it "returns the authenticated email" do
        email.should eq(authenticated_email)
      end
    end

    context "with configured session variable" do
      let(:variable) { :rails_browserid_email_ }

      before do
        browserid_config.session_variable = variable
        controller.login_browserid(authenticated_email)
      end

      it "stores the email in the session" do
        session[variable].should eq(authenticated_email)
      end
    end
  end

  describe "#browserid_current_user" do
    context "when not authenticated" do
      it "returns nil" do
        controller.browserid_current_user.should be_nil
      end
    end

    context "when authenticated" do
      before do
        controller.login_browserid(authenticated_email)
        User.should_receive(:find_by_email).with(authenticated_email).and_return(browserid_current_user)
      end

      it "returns the current user" do
        controller.browserid_current_user.should be(browserid_current_user)
        controller.browserid_current_user.should be(browserid_current_user) # test memoization
      end
    end

    context "with configured model and properties" do
      class Employee; end
      let(:browserid_current_user) { Employee.new }

      before do
        browserid_config.user_model = 'Employee'
        browserid_config.email_field = :address

        controller.login_browserid(authenticated_email)
        Employee.should_receive(:find_by_address).with(authenticated_email).and_return(browserid_current_user)
      end

      it "returns the current user" do
        controller.browserid_current_user.should be(browserid_current_user)
      end
    end
  end

  describe "#create" do
    context "without assertion parameter" do
      before { post :create, assertion: nil }

      it "responds with bad request status" do
        response.should be_bad_request
      end
    end

    context "with invalid assertion" do
      let(:assertion) { "invalid-assertion-data" }
      let(:failure_message) { "Reason the authentication failed" }

      before do
        verifier = double("verifier")
        verifier.should_receive(:verify).with(assertion, kind_of(String)).and_raise(StandardError.new(failure_message))
        browserid_config.verifier = verifier

        post :create, assertion: assertion
      end

      it "responds with forbidden status" do
        response.should be_forbidden
      end

      it "responds with failure message" do
        response.body.should eq(failure_message)
      end
    end

    context "with valid assertion" do
      let(:assertion) { "valid-assertion-data" }

      before do
        verifier = double("verifier")
        verifier.should_receive(:verify).with(assertion, kind_of(String)).and_return([authenticated_email, "login.mozilla.org"])
        browserid_config.verifier = verifier

        post :create, assertion: assertion
      end

      it "responds with ok status" do
        response.should be_ok
      end

      it "logs in the email" do
        controller.browserid_email.should eq(authenticated_email)
      end

      it "sets browserid_authenticated? status" do
        User.should_receive(:find_by_email).with(authenticated_email).and_return(browserid_current_user)

        controller.should be_authenticated
      end
    end
  end

  describe "#destroy" do
    before do
      post :destroy, nil, authenticated_session
    end

    it "responds with ok status" do
      response.should be_ok
    end

    it "clears the authenticated email" do
      controller.browserid_email.should be_nil
    end
  end
end
