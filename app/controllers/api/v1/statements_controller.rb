class Api::V1::StatementsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_statement, only: [:show, :update, :destroy]
    before_action :authorize!, only: [:show, :update, :destroy]

    # all statements
    def index
        statements = Statement.order(period: :DESC).where(user: current_user)
        render json: statements, each_serializer: StatementCollectionSerializer
    end

    # new statement
    def create
        statement = Statement.new statement_params
        statement.title = statement.period.strftime("%B") + ", " + statement.period.strftime("%Y")
        statement.user = current_user

        if statement.save
            render json: statement
        else
            render json: { status: 422, errors: statement.errors.full_messages.first } # Unprocessable Entity
        end
    end

    # show single statement
    def show
        render json: @statement
    end

    # update single statement
    def update
        if @statement.update statement_params
            render json: @statement
        else
            render json: { status: 422, errors: statement.errors.full_messages.first } # Unprocessable Entity
        end
    end

    # delete single statement
    def destroy
        @statement.destroy
        render json: { status: 200 } # OK
    end


    private
    # find single statement
    def find_statement
        @statement = Statement.find_by id: params[:id]
        if @statement == nil
            render json: { status: 404, errors: "Statement does not exist" } # Not Found
        end
    end

    # available parameter for statement
    def statement_params
        params.require(:statement).permit(:title, :period, :memo)
    end

    # authorization
    def authorize!
        unless can?(:crud, @statement)
            render json: { status: 401, errors: "Unautorized" }
        end
    end
end
