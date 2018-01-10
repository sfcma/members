class RenamePoorlyNamedCommunityNightColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :community_nights, :start, :start_datetime
    rename_column :community_nights, :end, :end_datetime
  end
end
