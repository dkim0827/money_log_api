class Statement < ApplicationRecord
    belongs_to :user
    has_many :transactions, dependent: :destroy

    validate :period_valid?

    # user_id cannot be null
    validates :user_id, presence: true

    # will user month, year as title name(eg. Febuary, 2020). So it has to be unique
    validates :title, presence: true, uniqueness: { scope: :user_id }

    # month must present, in each year month can only appear 1 time. has to be integer 0 - 11(Jan - Dec)
    validates :period, uniqueness: { scope: :user_id }
    private

    def period_valid?
        selected_year = period.strftime("%Y").to_i
        selected_month = period.strftime("%m").to_i
        current_year = DateTime.now.strftime("%Y").to_i
        current_month = DateTime.now.strftime("%m").to_i

        if current_year < selected_year
            self.errors.add(:period, "Cannot select future year")
        elsif current_year == selected_year && current_month < selected_month
            self.errors.add(:period, "Cannot select future month")
        end
    end

end
