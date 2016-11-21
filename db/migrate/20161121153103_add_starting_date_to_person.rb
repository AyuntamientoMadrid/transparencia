class AddStartingDateToPerson < ActiveRecord::Migration
  def change
    add_column :people, :starting_date, :date
  end
end
