class AddTiyoFields < ActiveRecord::Migration
  def change
    drop_table :courses

    create_table :cohorts do |t|
      t.belongs_to :campus, null: false, index: true, foreign_key: true
      t.integer :tiyo_id, null: false, index: true
      t.string :title, null: false
      t.date :start_on
      t.date :end_on

      t.timestamps null: false
    end

    add_column :campuses, :tiyo_id, :integer, unique: true

    add_column :yardigans, :tiyo_id, :integer, unique: true
    add_column :yardigans, :name, :string
    remove_column :yardigans, :latest_course_id, :integer
  end
end
