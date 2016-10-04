class AddLeavingDateToPeople < ActiveRecord::Migration
  def change
    add_column :people, :leaving_date, :date
  end
end
