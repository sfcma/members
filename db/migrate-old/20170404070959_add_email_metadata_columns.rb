class AddEmailMetadataColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :email_type, :integer
    add_column :emails, :sent_at, :date
    add_column :email_logs, :opened_at, :date
  end
end
