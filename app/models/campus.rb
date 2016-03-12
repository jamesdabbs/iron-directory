class Campus < ActiveRecord::Base
  has_many :courses

  validates :tiyo_id, presence: true, uniqueness: true
  validates :name, presence: true
end
