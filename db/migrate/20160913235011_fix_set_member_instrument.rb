class FixSetMemberInstrument < ActiveRecord::Migration[5.0]
  def change
    add_column :set_member_instruments, :set_members, :integer
    add_column :set_member_instruments, :member_instruments, :integer
  end
end
