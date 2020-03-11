class StatementSerializer < ActiveModel::Serializer

  attributes(
    :id, 
    :title,
    :period,
    :budget_start,
    :balance_left_start_of_statement,
    :balance_left_end_of_statement,
    :statement_total,
    :income_total,
    :savings_total,
    :living_expense_total, 
    :non_living_expense_total, 
    :category_drink, 
    :category_food, 
    :category_want, 
    :category_others, 
    :memo, 
    :income_transactions,
    :savings_transactions,
    :living_expense_transactions,
    :non_living_expense_transactions
  )

  def budget_start
    '%.2f' % (
      Transaction.where(statement_id: object.id, trans_type: "income".upcase).sum(:amount) -
      Transaction.where(statement_id: object.id, trans_type: "savings".upcase).sum(:amount) -
      Transaction.where(statement_id: object.id, trans_type: "le".upcase).sum(:amount)
    )
  end

  def income_transactions
    Transaction
    .order(trans_date: :DESC, created_at: :DESC).where(statement_id: object.id, trans_type: "income".upcase)
    .select("id, trans_date, trans_type, description, amount")
  end

  def savings_transactions
    Transaction
    .order(trans_date: :DESC, created_at: :DESC).where(statement_id: object.id, trans_type: "savings".upcase)
    .select("id, trans_date, trans_type, description, amount")
  end

  def living_expense_transactions
    Transaction
    .order(trans_date: :DESC, created_at: :DESC).where(statement_id: object.id, trans_type: "le".upcase)
    .select("id, trans_date, trans_type, description, amount")
  end

  def non_living_expense_transactions
    Transaction
    .order(trans_date: :DESC, created_at: :DESC).where(statement_id: object.id, trans_type: "nle".upcase)
    .select("id, trans_date, trans_type, description, amount, category")
  end

  def statement_total
    '%.2f' % (
      Transaction.where(statement_id: object.id, trans_type: "income".upcase).sum(:amount) -
      Transaction.where(statement_id: object.id, trans_type: "savings".upcase).sum(:amount) -
      Transaction.where(statement_id: object.id, trans_type: "le".upcase).sum(:amount) -
      Transaction.where(statement_id: object.id, trans_type: "nle".upcase).sum(:amount)
    )
  end

  def income_total
    '%.2f' % Transaction.where(statement_id: object.id, trans_type: "income".upcase).sum(:amount)
  end

  def savings_total
    '%.2f' % Transaction.where(statement_id: object.id, trans_type: "savings".upcase).sum(:amount)
  end

  def living_expense_total
    '%.2f' % Transaction.where(statement_id: object.id, trans_type: "le".upcase).sum(:amount)
  end

  def non_living_expense_total
    '%.2f' % Transaction.where(statement_id: object.id, trans_type: "nle".upcase).sum(:amount)
  end

  def category_drink
    '%.2f' % Transaction.where(statement_id: object.id, trans_type: "nle".upcase, category: "drink".upcase).sum(:amount)
  end

  def category_food
    '%.2f' % Transaction.where(statement_id: object.id, trans_type: "nle".upcase, category: "food".upcase).sum(:amount)
  end

  def category_want
    '%.2f' % Transaction.where(statement_id: object.id, trans_type: "nle".upcase, category: "want".upcase).sum(:amount)
  end

  def category_others
    '%.2f' % Transaction.where(statement_id: object.id, trans_type: "nle".upcase, category: "others".upcase).sum(:amount)
  end

  # balance left after end of the statement
  def balance_left_end_of_statement
    '%.2f' % (
      User.where(id: object.user_id).sum(:balance) + 
      Transaction.where(user_id: object.user_id, trans_type: "income".upcase, trans_date: DateTime.new()...object.period + 1.month).sum(:amount) -
      Transaction.where(user_id: object.user_id, trans_type: "le".upcase, trans_date: DateTime.new()...object.period + 1.month).sum(:amount) -
      Transaction.where(user_id: object.user_id, trans_type: "nle".upcase, trans_date: DateTime.new()...object.period + 1.month).sum(:amount)
    )
  end

  # balance left after end of the statement
  def balance_left_start_of_statement
    '%.2f' % (
      User.where(id: object.user_id).sum(:balance) + 
      Transaction.where(user_id: object.user_id, trans_type: "income".upcase, trans_date: DateTime.new()...object.period).sum(:amount) -
      Transaction.where(user_id: object.user_id, trans_type: "le".upcase, trans_date: DateTime.new()...object.period).sum(:amount) -
      Transaction.where(user_id: object.user_id, trans_type: "nle".upcase, trans_date: DateTime.new()...object.period).sum(:amount)
    )
  end

  class TransactionSerializer < ActiveModel::Serializer
    attributes :id, :trans_date, :trans_type, :category, :description, :trans_amount
    belongs_to :user

    def trans_amount
      @statement = Statemend.find_by id: object.id
    end
  end
end
