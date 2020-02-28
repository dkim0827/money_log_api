class StatementSerializer < ActiveModel::Serializer

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
    :memo, 
    :income_transactions,
    :living_expense_transactions,
    :non_living_expense_transactions
  )

  def income_transactions
    Transaction
    .order(trans_date: :DESC, created_at: :DESC).where(statement_id: object.id, trans_type: "income".upcase)
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
      Transaction.where(statement_id: object.id, trans_type: "le".upcase).sum(:amount) -
      Transaction.where(statement_id: object.id, trans_type: "nle".upcase).sum(:amount)
    )
  end

  def income_total
    '%.2f' % Transaction.where(statement_id: object.id, trans_type: "income".upcase).sum(:amount)
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

  class TransactionSerializer < ActiveModel::Serializer
    attributes :id, :trans_date, :trans_type, :category, :description, :trans_amount
    belongs_to :user

    def trans_amount
      '%.2f' % Transaction.where(id: object.id).sum(:amount)
    end
  end
end
