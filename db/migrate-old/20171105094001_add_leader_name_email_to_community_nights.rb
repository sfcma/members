class AddLeaderNameEmailToCommunityNights < ActiveRecord::Migration[5.0]
  def change
    add_column :community_nights, :leader_name, :string
    add_column :community_nights, :leader_email, :string
    add_column :community_nights, :leader_user_id, :integer
  end
end
