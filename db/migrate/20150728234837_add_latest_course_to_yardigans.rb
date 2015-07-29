class AddLatestCourseToYardigans < ActiveRecord::Migration
  def change
    add_column :yardigans, :latest_course_id, :integer
  end
end
