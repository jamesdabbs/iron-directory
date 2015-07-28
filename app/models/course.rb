class Course < ActiveRecord::Base
  belongs_to :campus
  belongs_to :topic
  belongs_to :instructor, class_name: "Yardigan"

  validates_presence_of :campus, :topic, :instructor, :start_on
end
