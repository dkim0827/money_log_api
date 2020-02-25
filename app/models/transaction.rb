class Transaction < ApplicationRecord
    belongs_to :user, dependent: :destroy
    belongs_to :statement, dependent: :destroy

    validates :user_id, presence: true
    validates :statement_id, presence: true
    validates :trans_type, presence: true
    validates :description, presence: true
    validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0}
    validates :trans_date, presence: true
    
    validate :is_NLE?
    validate :isdate_valid?

    private
    def is_NLE?
        if trans_type == "NLE" && expense_type.blank?
            self.errors.add(:expense_type, "NLE-Type must be present")
        end
    end

    def isdate_valid?
        trans_year = trans_date.strftime("%Y").to_i
        trans_month = trans_date.strftime("%m").to_i
        trans_day = trans_date.strftime("%d").to_i
        current_day = DateTime.now.strftime("%d").to_i
       

        @statement = Statement.find_by id:statement_id
        state_year = @statement.period.strftime("%Y").to_i
        state_month = @statement.period.strftime("%m").to_i
        
        # current_year = DateTime.now.strftime("%Y").to_i
        # current_month = DateTime.now.strftime("%m").to_i
        # current_day = DateTime.now.strftime("%d").to_i
        if !(state_year == trans_year)
            self.errors.add(:trans_date, "Year does not match with statement")
        elsif !(state_month == trans_month)
            self.errors.add(:trans_date, "Month does not match with statement")
        elsif current_day < trans_day
            self.errors.add(:trans_date, "Cannot select future date")
        end
    end
end
