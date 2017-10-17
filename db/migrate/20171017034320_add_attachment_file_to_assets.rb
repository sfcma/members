class AddAttachmentFileToAssets < ActiveRecord::Migration
  def self.up
    change_table :assets do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :assets, :file
  end
end
