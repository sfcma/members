json.extract! opt_in_message, :id, :message, :created_at, :updated_at
json.url opt_in_message_url(opt_in_message, format: :json)