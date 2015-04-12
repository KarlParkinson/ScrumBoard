class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :check_login

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def check_login
    user = current_user
    if user
      if user.oauth_expires_at < Time.now
        flash[:expired] = true
        redirect_to signout_path
      end
    end
  end

end
