class SessionsController < ApplicationController
  def create
    respond_to_browserid
  end

  def destroy
    logout_browserid
    head :ok
  end
end
