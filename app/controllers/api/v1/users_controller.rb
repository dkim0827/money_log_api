class Api::V1::UsersController < ApplicationController
    before_action :authenticate_user!, except: [:create]
    before_action :find_user, only: [:update, :destroy, :password_update]
    
    def current
        render json: current_user
    end

    def create
        user = User.new user_params
        if user.save
            session[:user_id] = user.id
            render json: { id: user.id }
        else
            render json: { errors: user.errors.full_messages }, status: 422 # Unprocessable Entity(WebDAV)
        end
    end

    def update
        # if user is not current_user
        if @user.id != session[:user_id]
            render json: { status: 401, errors: ["Unautorized"] } # Unauthorized
        else
            # if user == current_user
            if @user.update user_params
                render json: @user #OK
            else
                render json: { status: 404, errors: ["Email has already been taken"] } # Not Found
            end
        end
    end

    def password_update
        current_password = params[:password]
        new_password = params[:new_password]
        new_password_confirmation = params[:new_password_confirmation]

        # if user is not current_user
        if @user.id != session[:user_id]
            render json: { status:401, errors: ["Unauthorized"] } # Unauthorized
        # if user == current_user try to log in with current_password
        elsif !(@user && @user.authenticate(current_password))
            render json: { status: 404, errors: ["Current password is incorrect"]} # Not Found
        # if new_password && new_password_confirmation does not match
        elsif !(new_password == new_password_confirmation)
            render json: { status: 404, errors: ["New password does not match"] } # Not Found
        # if updated successfully
        elsif @user.update password: new_password, password_confirmation: new_password_confirmation
            render json: { status: 200 } # OK
        # if other error occurs
        else
            render json: { status: 404, errors: ["Oops problem occured. Failed to Update"] }
        end
    end

    def destroy
        session[:user_id] = nil
        @user.destroy
        render json: { status: 200 }, status: 200
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
            render json: { status: 404, errors: ["User does not exist"] } # Not Found
        end
    end
end
