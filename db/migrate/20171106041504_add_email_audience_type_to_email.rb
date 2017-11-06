class AddEmailAudienceTypeToEmail < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :email_audience_type, :string
  end
end
