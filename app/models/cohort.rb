class Cohort < ActiveRecord::Base
  belongs_to :campus

  validates :tiyo_id, presence: true, uniqueness: true
  validates :campus, presence: true
  validates :title, presence: true

  def current?
    return false unless start_on && end_on
    (start_on .. end_on).cover? Time.now
  end
end
