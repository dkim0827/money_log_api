class Api::V1::TransactionsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_statement, only: [:create, :show, :update, :destroy]
    before_action :find_transaction, only: [:show, :update, :destroy]
    before_action :authorize!, only: [:create, :show, :update, :destroy]

    # new transaction
    def create
        transaction = Transaction.new transaction_params
        transaction.user = current_user
        transaction.statement = @statement
        if transaction.save
            render json: transaction
        else
            render json: { status: 422, errors: transaction.errors.full_messages.first } # Unprocessable Entity
        end
    end

    def show
        render json: @transaction
    end

    # update transaction
    def update
        if @transaction.update transaction_params
            render json: @transaction
        else
            render json: { status: 422, errors: @transaction.errors.full_messages.first } # Unprocessable Entity
        end
    end

    # destroy transaction
    def destroy 
        @transaction.destroy 
        render json: { status: 200 } # OK
    end

    private
    def transaction_params 
        params.require(:transaction).permit(
            :id,
            :trans_type,
            :description,
            :amount,
            :category,
            :trans_date,
            :statement_id
        )
    end

    def find_statement
        @statement = Statement.find_by id: params[:statement_id]
        if @statement == nil
            render json: { status: 404, errors: "Statement does not exist" } # Not Found
        end
    end

    def find_transaction
        @transaction = Transaction.find_by id: params[:id]
        if @transaction == nil
            render json: { status: 404, errors: "Transaction does not exist" } # Not Found
        end
    end

    def authorize!
        unless can?(:crud, @statement)
            render json: { status: 401, errors: "Unautorized" }
        end
    end
end
