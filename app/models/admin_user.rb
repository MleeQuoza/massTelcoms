class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %w(support admin superuser)

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def role?(role_name)
    self.role.present? && self.role.name == role_name.to_s
  end

  def is?(role)
    roles.include?(role.to_s)
  end
  
  def donations
    []
  end
  
  def withdrawals
    []
  end
end
