class AddNoteTypeToMemberNote < ActiveRecord::Migration[5.0]
  def change
    add_column :member_notes, :private_note, :boolean, default: false
  end
end
