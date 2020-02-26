class Statement < ApplicationRecord
    # relationship between table
    belongs_to :user
    has_many :transactions, dependent: :destroy

    # column validation
    validates :user_id, presence: true
    validates :title, presence: true, uniqueness: { scope: :user_id }
    validates :period, uniqueness: { scope: :user_id }

    # custom validation
    before_validation :set_default_memo
    validate :period_valid?

    private
    def set_default_memo
        self.memo ||= ""
    end
    
    def period_valid?
        # selected date
        selected_year = period.strftime("%Y").to_i
        selected_month = period.strftime("%m").to_i

        # current date
        current_year = DateTime.now.strftime("%Y").to_i
        current_month = DateTime.now.strftime("%m").to_i

        if current_year < selected_year
            self.errors.add(:period, "Year cannot be in the future")
        elsif current_year == selected_year && current_month < selected_month
            self.errors.add(:period, "Month cannot be in the future")
        end
    end

end
