class AddNoContactFlagToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :no_contact, :boolean, default: false
  end
end
