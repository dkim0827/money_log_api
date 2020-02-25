class Statement < ApplicationRecord
    belongs_to :user
    has_many :transactions, dependent: :destroy

    validate :time_valid?

    # user_id cannot be null
    validates :user_id, presence: true

    # will user month, year as title name(eg. Febuary, 2020). So it has to be unique
    validates :title, presence: true, uniqueness: { scope: :user_id }

    # year must present, has to be integer greater than 0
    validates :year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    # month must present, in each year month can only appear 1 time. has to be integer 0 - 11(Jan - Dec)
    validates :month, uniqueness: { scope: [:user_id, :year] },
    numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 11 }

    private

    def time_valid?
        if Time.now.strftime("%Y").to_i < year
            self.errors.add(:year, "Cannot select future year")
            # render json: { status: 422, errors: ["Cannot select future year"] }
        elsif Time.now.strftime("%Y").to_i == year && Time.now.strftime("%m").to_i - 1 < month
            self.errors.add(:month, "Cannot select future month")
            # render json: { status: 422, errors: ["Cannot select future month"] }
        end
    end

end
