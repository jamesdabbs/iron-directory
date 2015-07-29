class UpdateTeam
  attr_reader :team

  def initialize id
    @team    = SlackTeam.find id
    @members = @team.members.to_a
  end

  def run! courses:, campuses:
    set_all :campus_id, campuses
    set_all :latest_course_id, courses
    commit!
  end

  def set_all field, map
    @members.each do |member|
      updated_value = map[member.id.to_s]
      next unless updated_value.present?
      next if updated_value.to_s == member.send(field).to_s
      member.send "#{field}=", updated_value
    end
  end

  def commit!
    @members.each { |m| m.save! if m.changed? }
  end
end
