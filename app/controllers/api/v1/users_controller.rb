class Api::V1::UsersController < ApplicationController
    before_action :authenticate_user!, except: [:create]
    before_action :find_user, only: [:update, :destroy, :password_update]
    before_action :authorize!, only: [:update, :destroy, :password_update]
    
    # get current_user info
    def current
        render json: current_user
    end

    # create user
    def create
        user = User.new user_params
        if user.save
            session[:user_id] = user.id
            render json: user
        else
            render json: { status: 422, errors: user.errors.full_messages.first } # Unprocessable Entity(WebDAV)
        end
    end

    # update user
    def update
        if @user.update user_params
            render json: @user, status: 200 #OK
        else
            render json: { status: 422, errors: @user.errors.full_messages.first } # Unprocessable Entity(WebDAV)
        end
    end

    # change password
    def password_update
        current_password = params[:password]
        new_password = params[:new_password]
        new_password_confirmation = params[:new_password_confirmation]

        if !(@user && @user.authenticate(current_password))
            render json: { status: 422, errors: "Current password is incorrect" } # Unprocessable Entity(WebDAV)
        elsif !(new_password == new_password_confirmation)
            render json: { status: 422, errors: "New password does not match" } # Unprocessable Entity(WebDAV)
        elsif @user.update password: new_password, password_confirmation: new_password_confirmation
            session[:user_id] = nil
            render json: { status: 200 } # OK
        else
            render json: { status: 404, errors: "Oops problem occured. Failed to update" } # Not Found
        end
    end

    # destroy user
    def destroy
        session[:user_id] = nil
        @user.destroy
        render json: { status: 200 }
    end

    private
    def user_params
        params.require(:user).permit(
            :first_name,
            :last_name,
            :email,
            :balance,
            :password,
            :password_confirmation
        )
    end

    def find_user
        @user = User.find_by id: params[:id]
        if @user == nil
            render json: { status: 404, errors: "User does not exist" } # Not Found
        end
    end

    def authorize!
        unless @user.id == session[:user_id]
            render json: { status: 401, errors: "Unauthorized" } # Unauthorized
        end
    end
end