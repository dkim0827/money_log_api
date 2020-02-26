class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :create, :read, :update, :destroy, to: :crud

    can(:crud, Statement) do |statement|
      statement.user == user
    end

    can(:crud, Transaction) do |transaction|
      transaction.user == user
    end

    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
