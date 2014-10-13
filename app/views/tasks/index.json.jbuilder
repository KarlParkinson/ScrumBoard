json.array!(@tasks) do |task|
  json.extract! task, :id, :title, :description, :state
  json.url task_url(task, format: :json)
end
