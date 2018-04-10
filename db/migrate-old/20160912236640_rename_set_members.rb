class RenameSetMembers < ActiveRecord::Migration[5.0]
  def change
    rename_table :set_member, :member_sets
  end
end
