class Topic < ActiveRecord::Base
  has_many :courses

  validates :title, presence: true, uniqueness: true
end
