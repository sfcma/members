class AddPerformanceSetName < ActiveRecord::Migration[5.0]
  def change
    add_column :performance_sets, :name, :string
  end
end
