class AddSortingNameToPerson < ActiveRecord::Migration
  def change
    add_column :people, :sorting_name, :string, index: true
  end
end
