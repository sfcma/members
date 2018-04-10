class ChangeSubFoundToString < ActiveRecord::Migration[5.0]
  def change
    change_column :absences, :sub_found, :string
  end
end
