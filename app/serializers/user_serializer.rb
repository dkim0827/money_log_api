class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :initial_balance, :current_balance

  # users current_balance
  def current_balance
    '%.2f' % (
      User.where(id: object.id).sum(:balance) + 
      Transaction.where(user_id: object.id, trans_type: "income".upcase).sum(:amount) -
      Transaction.where(user_id: object.id, trans_type: "le".upcase).sum(:amount) -
      Transaction.where(user_id: object.id, trans_type: "nle".upcase).sum(:amount)
    )
  end

  # users initial_balance
  def initial_balance
    '%.2f' % User.where(id: object.id).sum(:balance)
  end

end
