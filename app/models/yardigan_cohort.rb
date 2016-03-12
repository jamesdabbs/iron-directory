class YardiganCohort < ActiveRecord::Base
  belongs_to :yardigan
  belongs_to :cohort

  validates :yardigan, presence: true
  validates :cohort, presence: true, uniqueness: { scope: :yardigan }
end
