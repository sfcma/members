class FixSetMemberInstrument2 < ActiveRecord::Migration[5.0]
  def change
    rename_column :set_member_instruments, :set_members, :set_member_id
    rename_column :set_member_instruments, :member_instruments, :member_instrument_id
  end
end
