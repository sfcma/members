class AddSentOnBehalfOfToEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :behalf_of_name, :string
    add_column :emails, :behalf_of_email, :string
  end
end
