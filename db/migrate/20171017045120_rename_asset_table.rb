class RenameAssetTable < ActiveRecord::Migration[5.0]
  def change
    rename_table :assets, :attachments
  end
end
