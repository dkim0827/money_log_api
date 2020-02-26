class Api::V1::StatementsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_statement, only: [:show, :update, :destroy]
    before_action :authorize!, only: [:show, :update, :destroy]

    def create
        statement = Statement.new statement_params
        period_array = params[:statement][:period].split("/")
        year = period_array[0].to_i
        month = period_array[1].to_i

        statement.period = DateTime.new(year, month)
        statement.title = "#{statement.period.strftime("%B")}, #{statement.period.strftime("%Y")}"
        statement.user = current_user

        if statement.save
            render json: { statement: statement }
        else
            render json: { errors: statement.errors }, status: 422 # Unprocessable Entity
        end
    end

    def index
        statements = Statement.order(period: :DESC).where(user: current_user)
        render json: statements # , each_serializer: QuestionCollectionSerializer
    end

    def show
        @statement = Statement.find_by id:params[:id]
        @income = Transaction.where(statement_id: @statement.id, trans_type: "income".upcase).sum(:amount)
        @living_expense = Transaction.where(statement_id: @statement.id, trans_type: "le".upcase).sum(:amount)
        @non_living_expense = Transaction.where(statement_id: @statement.id, trans_type: "nle".upcase).sum(:amount)
        
        @nle_drink = Transaction.where(statement_id: @statement.id, trans_type: "nle".upcase, expense_type: "drink".upcase).sum(:amount)
        @nle_food = Transaction.where(statement_id: @statement.id, trans_type: "nle".upcase, expense_type: "food".upcase).sum(:amount)
        @nle_want = Transaction.where(statement_id: @statement.id, trans_type: "nle".upcase, expense_type: "want".upcase).sum(:amount)
        @nle_others = Transaction.where(statement_id: @statement.id, trans_type: "nle".upcase, expense_type: "others".upcase).sum(:amount)
        
        
        @statement_total = @income - @living_expense - @non_living_expense
        render json: {
            statement: @statement, 
            income: @income, 
            living_expense: @living_expense, 
            non_living_expense: @non_living_expense,
            nle_drink: @nle_drink,
            nle_food: @nle_food,
            nle_want: @nle_want,
            nle_others: @nle_others,
            statement_total: @statement_total
        }
        # render json: @statement, include: [:user, { transactions: [:user] }]
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
        render( json: { status: 200 }, status: 200)
    end

    private
    def find_statement
        @statement = Statement.find params[:id]
    end

    def statement_params
        params.require(:statement).permit(:title, :period, :memo)
    end

    def authorize!
        unless can?(:crud, @statement)
            render json: { status: 401, errors: ["Unautorized"] }
        end
    end
end
