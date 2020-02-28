class Api::V1::SessionsController < ApplicationController

    # Sign In
    def create
        user = User.find_by_email params[:email]
        if !user
            render json: { status: 404, errors: "Email does not exist" } # Not Found
        elsif user&.authenticate(params[:password])
                session[:user_id] = user.id
                render json: user
        else
            render json: { status: 404, errors: "Your password is incorrect" } # Not Found
        end
    end

    # Sign Out
    def destroy
        session[:user_id] = nil
        render json: { status: 200 } # OK
    end
end
