class StatementCollectionSerializer < ActiveModel::Serializer
  attributes(
    :id, 
    :title, 
    :period,
    :statement_total,
    :income_total, 
    :living_expense_total, 
    :non_living_expense_total, 
    :nle_drink, 
    :nle_food, 
    :nle_want, 
    :nle_others, 
    :memo
  )

  def statement_total
    (
    '%.2f' % (
    Transaction.where(statement_id: object.id, trans_type: "income".upcase).sum(:amount) -
    Transaction.where(statement_id: object.id, trans_type: "le".upcase).sum(:amount) -
    Transaction.where(statement_id: object.id, trans_type: "nle".upcase).sum(:amount)
    ))
  end

  def income_total
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "income".upcase).sum(:amount)
  end

  def living_expense_total
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "le".upcase).sum(:amount)
  end

  def non_living_expense_total
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "nle".upcase).sum(:amount)
  end

  def nle_drink
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "nle".upcase, expense_type: "drink".upcase).sum(:amount)
  end

  def nle_food
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "nle".upcase, expense_type: "food".upcase).sum(:amount)
  end

  def nle_want
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "nle".upcase, expense_type: "want".upcase).sum(:amount)
  end

  def nle_others
    '%.2f' % 
    Transaction.where(statement_id: object.id, trans_type: "nle".upcase, expense_type: "others".upcase).sum(:amount)
  end
end
