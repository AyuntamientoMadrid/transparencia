class AddCalendarToPerson < ActiveRecord::Migration
  def change
    add_column :people, :calendar, :string
  end
end
