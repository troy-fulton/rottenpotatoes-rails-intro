class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :set_current_user
  protected
  def set_current_user
    redirect_to login_path and return unless session[:user_id]
    
    @current_user = Moviegoer.find(session[:user_id])
    redirect_to login_path and return unless @current_user
  end
end
