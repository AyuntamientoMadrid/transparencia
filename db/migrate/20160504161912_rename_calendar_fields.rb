class RenameCalendarFields < ActiveRecord::Migration
  def change
    rename_column :people, :calendar, :calendar_url
    rename_column :people, :previous_calendar, :previous_calendar_url
  end
end
