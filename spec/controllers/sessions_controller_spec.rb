require 'spec_helper'

describe SessionsController do
  describe "#create" do
    context "without assertion parameter" do
      it "responds with bad request status"
    end

    context "with invalid assertion" do
      it "responds with forbidden status"
      it "responds with error message"
    end

    context "with valid assertion" do
      it "responds with ok status"
      it "logs in the email"
    end
  end

  describe "#destroy" do
    it "clears the authenticated email"
    it "responds with ok status"
#    include_context "authenticated user"
#
#    it "clears the authenticated email" do
#      post :destroy, nil, authenticated_session
#      session[:browserid_email].should be_nil
#    end
#
#    it "returns ok" do
#      post :destroy, nil, authenticated_session
#      response.should be_ok
#    end
  end
end
