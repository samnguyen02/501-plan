json.extract! ideathon_event, :id, :ideathon_year_id, :event_name, :event_description, :event_date, :event_time, :created_at, :updated_at
json.url ideathon_event_url(ideathon_event, format: :json)
