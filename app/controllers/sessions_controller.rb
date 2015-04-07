class SessionsController < ApplicationController
  def create
    reset_session
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to boards_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
