json.staff @members do |m|
  json.(m, :id, :email, :first_name, :last_name, :title, :slack_username, :skype_username, :phone_number)
  json.campus m.campus.try(:name)

  m.avatars.each do |k,v|
    json.set! k,v
  end

  json.current_course do
    next unless course = m.latest_course
    json.topic    course.topic.title
    json.start_on course.start_on
  end
end
