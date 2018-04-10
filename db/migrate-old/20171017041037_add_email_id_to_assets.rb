class AddEmailIdToAssets < ActiveRecord::Migration[5.0]
  def change
    add_column :assets, :email_id, :integer, default: 0, null: false
  end
end
