class UpdateEmailLogColumnTypes < ActiveRecord::Migration[5.0]
  def change
    change_column :email_logs, :opened_at, :datetime
    change_column :emails, :sent_at, :datetime
  end
end
