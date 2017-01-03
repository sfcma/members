class AddDescriptionToPerformanceSet < ActiveRecord::Migration[5.0]
  def change
    add_column :performance_sets, :description, :string, null: true
  end
end
