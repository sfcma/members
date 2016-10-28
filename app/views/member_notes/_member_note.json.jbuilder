json.extract! member_note, :id, :member_id, :user_id, :note, :created_at, :updated_at
json.url member_note_url(member_note, format: :json)
