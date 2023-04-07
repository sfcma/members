module Permissions

  def self.special_global_admin(user)
    if user
      puts "--"
      puts user.id
      puts "--"
    end
    user && 
      (
        (
          Rails.env == 'production' && (
            user.id == 1 || user.id == 116
          )
        ) || (
          user.global_admin? && (
            Rails.env == 'development' || Rails.env == 'staging'
          )
        )
      )
  end
  
end