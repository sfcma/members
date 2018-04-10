class AddVariantToSetMemberInstrument < ActiveRecord::Migration[5.0]
  def change
    add_column :set_member_instruments, :variant, :string, null: true
  end
end
