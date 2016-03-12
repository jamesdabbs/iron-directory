json.staff @members do |m|
  json.(m, :id, :email, :first_name, :last_name, :title, :slack_username, :skype_username, :phone_number)
  json.campus m.campus.try(:name)

  m.avatars.each do |k,v|
    json.set! k,v
  end

  json.current_course do
    next unless cohort = m.current_cohort
    json.(cohort, :start_on, :end_on)
    json.topic    cohort.title
  end
end
