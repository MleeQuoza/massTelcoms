class ActiveAdminAbility
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    @user.roles.each { |role| send(role) }
  
    guest if @user.roles.size == 0
    can :manage, ActiveAdmin, id: user.id
    can :read, ActiveAdmin::Page, name: 'Dashboard', namespace_name: :admin
  end
  
  def support
    can :manage, Advert
    can :manage, Announcement
  end
  
  def admin
    can :read, :all
  end
  
  def superuser
    can :manage, :all
  end
end