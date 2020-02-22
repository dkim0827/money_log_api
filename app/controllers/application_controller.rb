class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token

    private
    def current_user
        if session[:user_id].present?
            @current_user ||= User.find_by(id: session[:user_id])
        end
    end
    helper_method :current_user

    def authenticate_user!
        unless current_user.present?
            render json: { status: 401 }, status: 401 # Unauthrized
        end
    end
end
