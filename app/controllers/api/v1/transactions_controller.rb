class Api::V1::TransactionsController < ApplicationController
    before_action :authenticate_user!
    
    def create
        @statement = Statement.find(params[:statement_id])
        @transaction = Transaction.new transaction_params
        @transaction.user = current_user
        @transaction.statement = @statement
        if @transaction.save 
            render json: { id: @transaction.id }
        else
            render json: { status: 401, errors: ["Failed to create transaction"] }
        end
    end

    def destroy 
        @transaction = Transaction.find(params[:id])
        if can? :crud, @transaction
            @transaction.destroy 
            render(json: { status: 200 }, status: 200)
        else
            render json: { status: 401, errors: ["Unautorized"] }
        end
    end

    private
    def transaction_params 
        params.require(:transaction).permit(
            :transaction_type,
            :description,
            :amount,
            :expense_type,
            :date
        )
    end
end
