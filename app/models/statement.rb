class Statement < ApplicationRecord
    belongs_to :user

    # user_id cannot be null
    validates :user_id, presence: true

    # will user month, year as title name(eg. Febuary, 2020). So it has to be unique
    validates :title, presence: true, uniqueness: true

    # year must present, has to be integer greater than 0
    validates :year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    # month must present, in each year month can only appear 1 time. has to be integer 1 - 12(Jan - Dec)
    validates: month, uniqueness: { scope: [:user_id, :year] },
    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }

end
