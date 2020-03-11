class StatementCollectionSerializer < ActiveModel::Serializer
  attributes(
    :id, 
    :title, 
    :period,
    :budget_start,
    :average_budget,
    :average_income,
    :average_savings,
    :average_le,
    :average_nle,
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
    :memo
  )

  # statement net_total
  def statement_total
    '%.2f' % (
      Transaction.where(statement_id: object.id, trans_type: "income".upcase).sum(:amount) -
      Transaction.where(statement_id: object.id, trans_type: "savings".upcase).sum(:amount) -
      Transaction.where(statement_id: object.id, trans_type: "le".upcase).sum(:amount) -
      Transaction.where(statement_id: object.id, trans_type: "nle".upcase).sum(:amount)
    )
  end

  def average_budget
    '%.2f' % (
      (Transaction.where(user_id: object.user_id, trans_type: "income".upcase).sum(:amount) -
      Transaction.where(user_id: object.user_id, trans_type: "savings".upcase).sum(:amount) -
      Transaction.where(user_id: object.user_id, trans_type: "le".upcase).sum(:amount) -
      Transaction.where(user_id: object.user_id, trans_type: "nle".upcase).sum(:amount)) / Statement.where(user_id: object.user_id).count
      )
  end

  def budget_start
    '%.2f' % (
      Transaction.where(statement_id: object.id, trans_type: "income".upcase).sum(:amount) -
      Transaction.where(statement_id: object.id, trans_type: "savings".upcase).sum(:amount) -
      Transaction.where(statement_id: object.id, trans_type: "le".upcase).sum(:amount)
    )
  end

  def average_income
    '%.2f' % (Transaction.where(user_id: object.user_id, trans_type: "income".upcase).sum(:amount) /
    Statement.where(user_id: object.user_id).count)
  end

  def average_savings
    '%.2f' % (Transaction.where(user_id: object.user_id, trans_type: "savings".upcase).sum(:amount) /
    Statement.where(user_id: object.user_id).count)
  end

  def average_le
    '%.2f' % (Transaction.where(user_id: object.user_id, trans_type: "le".upcase).sum(:amount) /
    Statement.where(user_id: object.user_id).count)
  end

  def average_nle
    '%.2f' % (Transaction.where(user_id: object.user_id, trans_type: "nle".upcase).sum(:amount) /
    Statement.where(user_id: object.user_id).count)
  end

  # statement income_total
  def income_total
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "income".upcase).sum(:amount)
  end

  # statement Savings total
  def savings_total
    '%.2f' % Transaction.where(statement_id: object.id, trans_type: "savings".upcase).sum(:amount)
  end

  # statement Living Expense total
  def living_expense_total
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "le".upcase).sum(:amount)
  end

  # statement Non-Living Expense total
  def non_living_expense_total
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "nle".upcase).sum(:amount)
  end

  # Non-Living Expense category: Drink total
  def category_drink
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "nle".upcase, category: "drink".upcase).sum(:amount)
  end

  # Non-Living Expense category: Food total
  def category_food
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "nle".upcase, category: "food".upcase).sum(:amount)
  end

  # Non-Living Expense category: want total
  def category_want
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "nle".upcase, category: "want".upcase).sum(:amount)
  end

  # Non-Living Expense category: Others total
  def category_others
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "nle".upcase, category: "others".upcase).sum(:amount)
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

  def initial_balance
    '%.2f' % User.where(id: object.user_id).sum(:balance)
  end
end