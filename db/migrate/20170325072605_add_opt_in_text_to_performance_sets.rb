class AddOptInTextToPerformanceSets < ActiveRecord::Migration[5.0]
  def change
    add_column :performance_sets, :opt_in_message, :text
  end
end
