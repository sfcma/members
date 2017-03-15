class NewMemberFields < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :contact_reply_date, :datetime
    add_column :members, :introduction, :text
    add_column :members, :reply_user_id, :integer
    add_column :members, :source_website, :boolean
    add_column :members, :source_other, :string
  end
end
