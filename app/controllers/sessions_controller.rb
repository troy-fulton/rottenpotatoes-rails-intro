class SessionsController < ApplicationController
    skip_before_filter :set_current_user
    def create
        auth = request.env["omniauth.auth"]
        user = Moviegoer.find_by(:provider => auth["provider"], :uid => auth["uid"])
        if user == nil
            user = Moviegoer.create_with_omniauth(auth)
        end
        session[:user_id] = user.id
        flash[:notice] = 'Logged #{@current_user.name} in successfully'
        redirect_to movies_path
    end
    def destroy
        session.delete(:user_id)
        flash[:notice] = 'Logged out successfully.'
        redirect_to movies_path
    end
end