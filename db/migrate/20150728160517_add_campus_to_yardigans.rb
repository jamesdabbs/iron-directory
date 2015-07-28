class AddCampusToYardigans < ActiveRecord::Migration
  def change
    add_reference :yardigans, :campus, index: true, foreign_key: true
  end
end
