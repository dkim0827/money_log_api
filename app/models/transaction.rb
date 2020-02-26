class Transaction < ApplicationRecord
    # relationship between table
    belongs_to :user, dependent: :destroy
    belongs_to :statement, dependent: :destroy

    # column validation
    validates :user_id, presence: true
    validates :statement_id, presence: true
    validates :description, presence: true
    validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0}
    validates :trans_type, presence: true
    validates :trans_date, presence: true
    
    # custom validation
    before_validation :trans_type_upcase
    validate :is_trans_type_valid?
    validate :is_trans_date_valid?
    validate :is_NLE?

    
    private


    def trans_type_upcase
        self.trans_type = self.trans_type.upcase
    end

    # if trans_type == "NLE" check for expense_type presence, true
    def is_NLE?
        if trans_type == "NLE" && expense_type.blank?
            self.errors.add(:expense_type, "NLE-Type must be present")
        elsif trans_type == "NLE" && expense_type.present?
            self.expense_type = self.expense_type.upcase
            valid_input = ["FOOD", "DRINK", "WANT", "OTHERS"]
            unless valid_input.include?(expense_type)
                self.errors.add(:expense_type, "Invalid NLE-Type")
            end
        else
            self.expense_type = nil
        end
    end

    # check for valid transaction_type = ["INCOME", "LE", "NLE"]
    # income = income
    # LE = Living Expense
    # NLE = Non-Living Expense
    def is_trans_type_valid?
        valid_input = ["INCOME", "LE", "NLE"]
        unless valid_input.include?(trans_type)
            self.errors.add(:trans_type, "Invalid Transaction-Type")
        end
    end

    # check for is transaction date valid
    def is_trans_date_valid?
        # transaction date
        trans_year = trans_date.strftime("%Y").to_i
        trans_month = trans_date.strftime("%m").to_i
        trans_day = trans_date.strftime("%d").to_i

        # current day
        current_day = DateTime.now.strftime("%d").to_i
        
        # statement month && year
        @statement = Statement.find_by id:statement_id
        state_year = @statement.period.strftime("%Y").to_i
        state_month = @statement.period.strftime("%m").to_i

        if !(state_year == trans_year)
            self.errors.add(:trans_date, "Transaction year and Statement year do not match")
        elsif !(state_month == trans_month)
            self.errors.add(:trans_date, "Tranaction month and Statement month do not match")
        elsif current_day < trans_day
            self.errors.add(:trans_date, "Day cannot be in the future")
        end
    end
end
