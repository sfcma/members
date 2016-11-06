class AddProgramNameToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :program_name, :string
  end
end
