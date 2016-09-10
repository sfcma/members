class ModifySetMemberInstrument < ActiveRecord::Migration[5.0]
  def change
    add_column :set_member_instruments, :set_status, :string
    add_column :set_member_instruments, :rotating, :boolean
  end
end
