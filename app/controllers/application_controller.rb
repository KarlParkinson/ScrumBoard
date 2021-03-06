class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :valid_login?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def valid_login?
    if current_user
      !current_user.oauth_expires_at.past?
    else
      false
    end
  end

  def owns_board(board_id)
    board = Board.find(board_id)
    current_user.uid == board.uid
  end
end
