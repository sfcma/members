class CreateCommunityNights < ActiveRecord::Migration[5.0]
  def change
    create_table :community_nights do |t|
      t.datetime :start
      t.datetime :end
      t.string :type
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
