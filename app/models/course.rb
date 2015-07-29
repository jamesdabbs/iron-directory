class Course < ActiveRecord::Base
  belongs_to :campus
  belongs_to :topic
  belongs_to :instructor, class_name: "Yardigan"

  validates_presence_of :campus, :topic, :instructor, :start_on

  def title
    "#{topic.title} - #{start_on.strftime '%b %y'}"
  end

  def end_on
    # This assumes we always start on a Monday and end on a Friday
    # Might need to migrate this to a DB column at some point
    start_on + 11.weeks + 4.days
  end
end
