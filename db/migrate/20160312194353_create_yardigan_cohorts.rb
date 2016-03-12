class CreateYardiganCohorts < ActiveRecord::Migration
  def change
    create_table :yardigan_cohorts do |t|
      t.belongs_to :yardigan, index: true, foreign_key: true
      t.belongs_to :cohort, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
