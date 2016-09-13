class ChangeMemberSetRelations2 < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :set_member_instruments, :set_members
    remove_column :set_member_instruments, :member_instrument_id
    remove_column :set_member_instruments, :set_status
    remove_column :set_member_instruments, :rotating
    remove_column :set_member_instruments, :set_id
  end
end
