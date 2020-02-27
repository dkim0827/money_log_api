class Api::V1::TransactionsController < ApplicationController
    before_action :authenticate_user!

    def create
        @statement = Statement.find(params[:statement_id])
        s_month = @statement.period.strftime("%m").to_i
        s_year = @statement.period.strftime("%Y").to_i

        transaction = Transaction.new transaction_params
        date_array = params[:transaction][:trans_date].split("/")
        t_month = date_array[0].to_i
        t_day = date_array[1].to_i
        t_year = date_array[2].to_i
        transaction.trans_date = DateTime.new(t_year, t_month, t_day)
        transaction.user = current_user
        transaction.statement = @statement
  
        if transaction.save
            render json: { transaction: transaction }
        else
            render json: { errors: transaction.errors }, status: 422
        end
    end

    def edit
        @statement = Statement.find(params[:statement_id])
        s_month = @statement.period.strftime("%m").to_i
        s_year = @statement.period.strftime("%Y").to_i

        @transaction = Transaction.find(params[:id])
        date_array = params[:transaction][:trans_date].split("/")
        t_month = date_array[0].to_i
        t_day = date_array[1].to_i
        t_year = date_array[2].to_i
        transaction.trans_date = DateTime.new(t_year, t_month, t_day)
        transaction.user = current_user
        transaction.statement = @statement
  
        if !(s_year == t_year)
            render json: { status: 401, errors: ["Selected year does not match with statement year"] }
        elsif !(s_month == t_month)
            render json: { status: 401, errors: ["Selected month does not match with statement month"] }
        elsif @transaction.update
            render json: { transaction: transaction }
        else
            render json: { errors: transaction.errors }, status: 422
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
            :trans_type,
            :description,
            :amount,
            :expense_type,
            :trans_date
        )
    end
end
