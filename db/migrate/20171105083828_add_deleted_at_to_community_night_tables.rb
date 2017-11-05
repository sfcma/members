class AddDeletedAtToCommunityNightTables < ActiveRecord::Migration[5.0]
  def change
    add_column :community_nights, :deleted_at, :datetime
    add_index :community_nights, :deleted_at

    add_column :member_community_nights, :deleted_at, :datetime
    add_index :member_community_nights, :deleted_at
  end
end
