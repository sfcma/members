class EmailDeletedAtColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :deleted_at, :datetime
    add_index :emails, :deleted_at

    add_column :email_logs, :deleted_at, :datetime
    add_index :email_logs, :deleted_at
  end
end