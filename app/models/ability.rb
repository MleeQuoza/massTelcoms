class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    @user.roles.each { |role| send(role) }

    guest if @user.roles.size == 0
  end

  def guest
  end

  def user
    can :manage, MoneyRequest
    can :manage, MoneyTransaction
    can :manage, PaymentAccount
  end

  def business
    user
    can :read, User
  end

  def admin
    can :manage, :all
  end

end