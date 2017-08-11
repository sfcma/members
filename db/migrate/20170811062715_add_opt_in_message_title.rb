class AddOptInMessageTitle < ActiveRecord::Migration[5.0]
  def change
    add_column :opt_in_messages, :title, :string
  end
end
