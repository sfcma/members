class CommunityNightCleanup < ActiveRecord::Migration[5.0]
  def change
    create_table :community_night_instruments do |t|
      t.integer :community_night_id
      t.string :instrument
      t.integer :limit
      t.boolean :available_to_opt_in

      t.timestamps
    end

    remove_column :member_community_nights, :instrument
    add_column :member_community_nights, :member_instrument_id, :integer
  end
end
