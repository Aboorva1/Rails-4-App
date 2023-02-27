json.array!(@students) do |student|
  json.extract! student, :id, :name, :register_no, :maths, :science
  json.url student_url(student, format: :json)
end
