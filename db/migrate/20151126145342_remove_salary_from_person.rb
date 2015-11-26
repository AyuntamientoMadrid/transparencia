class RemoveSalaryFromPerson < ActiveRecord::Migration
  def change
    remove_column :people, :salary, :float
  end
end
