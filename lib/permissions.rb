module Permissions

  def self.special_global_admin(user)
    user && 
      (
        (
          Rails.env == 'production' && (
            user.id == 1 || user.id == 14
          )
        ) || (
          user.global_admin? && (
            Rails.env == 'development' || Rails.env == 'staging'
          )
        )
      )
  end
  
end