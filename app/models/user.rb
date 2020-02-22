class User < ApplicationRecord
    has_many :statements, dependent: :destroy

    # email must be present, need to be unique
    validates :email, presence: true, uniqueness: true,
    # format for proper email
    format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    # from gem 'bcrypt'. adds password, password confirmation && validation
    has_secure_password


    def full_name
        "#{first_name} #{last_name}".strip.squeeze
    end
end
