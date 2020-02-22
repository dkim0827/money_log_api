class Api::V1::SessionsController < ApplicationController

    def create
        user = User.find_by_email params[:email]
        if !user
            render json: { status: 404, errors: ["Email does not exist"] }
        else
            if user&.authenticate(params[:password])
                session[:user_id] = user.id
                render json: {
                    status: :created,
                    logged_in: true,
                    user: user
                }
            else
                render json: { status: 404, errors: ["Your password is incorrect"] }
            end
        end
    end

    def destroy
        session[:user_id] = nil
        render json: { status: 200 }, status: 200 # OK
    end
end
