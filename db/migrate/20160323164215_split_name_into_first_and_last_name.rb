class SplitNameIntoFirstAndLastName < ActiveRecord::Migration
  def change
    add_column :people, :first_name, :string, index: true
    add_column :people, :last_name, :string, index: true
    remove_column :people, :name, :string
  end
end
