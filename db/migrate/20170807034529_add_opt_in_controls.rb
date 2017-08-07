class AddOptInControls < ActiveRecord::Migration[5.0]
  def change
    add_column :performance_set_instruments, :available_to_opt_in, :boolean
    add_column :performance_set_instruments, :opt_in_message_type, :string
    add_column :performance_set_instruments, :opt_in_message_id, :number
  end
end
