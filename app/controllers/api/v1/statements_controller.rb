class Api::V1::StatementsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_statement, only: [:show, :update, :destroy]
    before_action :authorize!, only: [:show, :update, :destroy]

    def create
        statement = Statement.new statement_params
        statement.user = current_user
        if statement.save
            render json: { id: statement.id }
        else
            render json: { errors: statement.errors }, status: 422 # Unprocessable Entity
        end
    end

    def index
        statements = Statement.order(year: :desc, month: :desc).where(user_id: current_user.id)
        render json: statements # , each_serializer: QuestionCollectionSerializer
    end

    def show
        @statement = Statement.find_by id:params[:id]
        render json: @statement
    end

    def update
        if @statement.update statement_params
            render json: { status: 200, statement: @statement } #OK
        else
            render :edit
        end
    end

    def destroy
        @statement.destroy
        render( json: { statement: 200 }, status: 200)
    end

    private
    def find_statement
        @statement = Statement.find params[:id]
    end

    def statement_params
        params.require(:statement).permit(:title, :month, :year, :memo)
    end

    def authorize!
        unless can?(:crud, @statement)
            render json: { status: 401, errors: ["Unautorized"] }
        end
    end
end
