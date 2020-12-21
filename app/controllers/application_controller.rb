class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      flash[:error] = "Must be logged in to do that."
      redirect_to root_path
    end
  end

  def require_admin
    access_denied unless logged_in? && current_user.admin?
    
  end

  def access_denied
    flash[:error] = "You can't do that."
    redirect_to root_path
  end
end
