class AddPreviousCalendarFieldsToPerson < ActiveRecord::Migration
  def change
    add_column :people, :previous_calendar_until, :date
    add_column :people, :previous_calendar, :string
  end
end
