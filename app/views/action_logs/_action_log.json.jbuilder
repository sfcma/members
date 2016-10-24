json.extract! action_log, :id, :member_id, :user_id, :action, :created_at, :updated_at
json.url action_log_url(action_log, format: :json)
