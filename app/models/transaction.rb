class Transaction < ApplicationRecord
    belongs_to :user
    belongs_to :statement, dependent: :destroy

    # user_id cannot be null
    validates :user_id, presence: true

    # statement_id cannot be null
    validates :statement_id, presence: true

    validates :description, presence: true

    validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0}

    validates :date, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }

end
