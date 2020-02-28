class Transaction < ApplicationRecord

    # relationship between table
    belongs_to :user
    belongs_to :statement

    # custom method
    before_validation :trans_type_upcase
    before_validation :set_description_for_NLE

    # custom validation
    validate :is_trans_type_valid?
    validate :is_trans_date_valid?
    validate :is_category_valid?

    # column validation
    validates :user_id, presence: true
    validates :statement_id, presence: true
    validates :description, presence: true
    validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0}
    validates :trans_type, presence: true
    validates :trans_date, presence: true
    


    
    private
    # change trans_type to uppercase
    def trans_type_upcase
        self.trans_type = self.trans_type.upcase
    end

    # if trans_type == NLE, description is blank category will become description name
    def set_description_for_NLE
        if trans_type == "NLE" && description.blank?
            self.description = self.category
        end
    end

    # if trans_type == "NLE" check for category presence, true
    def is_category_valid?
        if trans_type == "NLE" && category.blank?
            self.errors.add(:category, "Category must be selected")
        elsif trans_type == "NLE" && category.present?
            self.category = self.category.upcase
            valid_category = ["FOOD", "DRINK", "WANT", "OTHERS"]
            unless valid_category.include?(category)
                self.errors.add(:category, "Invalid category")
            end
        else
            self.category = nil
        end
    end

    # check for valid transaction_type = ["INCOME", "LE", "NLE"]
    # INCOME = Income
    # LE = Living Expense
    # NLE = Non-Living Expense
    def is_trans_type_valid?
        valid_trans_type = ["INCOME", "LE", "NLE"]
        unless valid_trans_type.include?(trans_type)
            self.errors.add(:trans_type, "Invalid Transaction-Type")
        end
    end

    # check for is transaction date valid
    def is_trans_date_valid?
        # transaction date
        trans_year = trans_date.strftime("%Y").to_i
        trans_month = trans_date.strftime("%m").to_i
        trans_day = trans_date.strftime("%d").to_i

        # current date
        current_year = DateTime.now.strftime("%Y").to_i
        current_month = DateTime.now.strftime("%m").to_i
        current_day = DateTime.now.strftime("%d").to_i
        
        # statement date
        @statement = Statement.find_by id: statement_id
        state_year = @statement.period.strftime("%Y").to_i
        state_month = @statement.period.strftime("%m").to_i

        if !(state_year == trans_year)
            self.errors.add(:base, "Transaction year and Statement year do not match")
        elsif !(state_month == trans_month)
            self.errors.add(:base, "Tranaction month and Statement month do not match")
        elsif state_year == current_year && state_month == current_month && current_day < trans_day
            self.errors.add(:base, "Day cannot be in the future")
        end
    end
end
