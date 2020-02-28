class User < ApplicationRecord

    # relationship between table
    has_many :statements, dependent: :destroy
    has_many :transactions, dependent: :destroy

    # custom method
    before_validation :set_default_balance

    # column validation
    validates :email, presence: true, uniqueness: true, format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    validates :balance, numericality: true
    has_secure_password

    # custom method for users full_name
    def full_name
        "#{first_name} #{last_name}".strip.squeeze
    end

    private
    # sets initial user balance as 0 if not given
    def set_default_balance
        self.balance ||= 0
    end
end
