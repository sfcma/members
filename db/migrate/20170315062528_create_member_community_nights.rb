class CreateMemberCommunityNights < ActiveRecord::Migration[5.0]
  def change
    create_table :member_community_nights do |t|
      t.string :status
      t.string :instrument
      t.integer :member_id
      t.integer :community_night_id

      t.timestamps
    end
  end
end
