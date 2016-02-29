class AddDistrictToPeople < ActiveRecord::Migration
  def change
    add_column :people, :district, :string
  end
end
