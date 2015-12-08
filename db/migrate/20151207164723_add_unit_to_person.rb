class AddUnitToPerson < ActiveRecord::Migration
  def change
    add_column :people, :unit, :string
  end
end
