json.staff @members do |m|
  json.(m, :id, :email, :first_name, :last_name, :title, :slack_username, :skype_username, :phone_number)
  m.avatars.each do |k,v|
    json.set! k,v
  end
end
