class StatementCollectionSerializer < ActiveModel::Serializer
  attributes(
    :id, 
    :title, 
    :period,
    :statement_total,
    :income_total, 
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
    Transaction.where(statement_id: object.id, trans_type: "le".upcase).sum(:amount) -
    Transaction.where(statement_id: object.id, trans_type: "nle".upcase).sum(:amount)
    )
  end

  # statement income_total
  def income_total
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "income".upcase).sum(:amount)
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
end
